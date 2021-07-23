import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:veterans/data/repositories/museum_repository.dart';
import 'package:veterans/model/museums/museum.dart';
import 'package:rxdart/rxdart.dart';

part 'search_museums_event.dart';
part 'search_museums_state.dart';

class SearchMuseumsBloc extends Bloc<SearchMuseumsEvent, SearchMuseumsState> {
  MuseumRepository museumRepository;

  SearchMuseumsBloc({this.museumRepository}) : super(SearchMuseumsInitial());



  @override
  Stream<SearchMuseumsState> mapEventToState(
      SearchMuseumsEvent event,
      ) async* {
    if(event is SearchStart) {
      yield SearchMuseumsProgress();
      yield* _mapLoadSearchMuseums(event.text);
    }
    if(event is SearchUpdated){
      yield* _updateVeterans(event.museums);
    }
    if(event is EmptySearchEvent){
      yield* _getVeterans();
    }
    if(event is NotFoundEvent) {
      yield NotFoundState();
    }
  }

  @override
  Stream<Transition<SearchMuseumsEvent, SearchMuseumsState>> transformEvents(
      Stream<SearchMuseumsEvent> events,
      TransitionFunction<SearchMuseumsEvent, SearchMuseumsState>
      transitionFn) {
    return events.debounceTime(const Duration(milliseconds : 300 )).switchMap(transitionFn);
  }

  Stream<SearchMuseumsState> _mapLoadSearchMuseums(String text) async* {
    try{
      if(text.isNotEmpty){
        museumRepository.searchVeteransByFullName(text).listen((museums) {
          if(museums.length != 0) add(SearchUpdated(museums));
          else add(NotFoundEvent());
        });
      }
      else{
        add(EmptySearchEvent());
      }
    } catch(e) {
      add(NotFoundEvent());
    }
  }

  Stream<SearchMuseumsState> _updateVeterans(List<Museum> museums) async* {
    yield SearchMuseumsSuccess(museums);
  }

  Stream<SearchMuseumsState> _getVeterans() async* {
    museumRepository.museums().listen((museums) {
      add(SearchUpdated(museums));
    });
  }
}
