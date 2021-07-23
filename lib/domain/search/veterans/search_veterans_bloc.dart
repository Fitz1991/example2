import 'dart:async';

import 'package:algolia/algolia.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:veterans/data/repositories/algolia_repository.dart';
import 'package:veterans/domain/adapters.dart';
import 'package:veterans/model/veterans/veteran.dart';

part 'search_veterans_event.dart';

part 'search_veterans_state.dart';

class SearchVeteransBloc extends Bloc<SearchVeteransEvent, SearchVeteransState> {
  AlgoliaRepository veteransRepository;

  SearchVeteransBloc({this.veteransRepository}) : super(SearchVeteransInitial());

  @override
  Stream<SearchVeteransState> mapEventToState(
    SearchVeteransEvent event,
  ) async* {
    if (event is SearchStart) {
      yield SearchVeteransProgress();
      yield* _mapSearchVeterans(event.text);
    }
    if (event is SearchFetchVeterans) {
      yield* _mapFetchVeterans();
    }
    if (event is SearchUpdated) {
      yield* _updateVeterans(event.veteransUpdatedAdapter);
    }
    if (event is EmptySearchEvent) {
      yield* _navigateToVeterans();
    }
    if (event is NotFoundEvent) {
      yield NotFoundState();
    }
  }

  @override
  Stream<Transition<SearchVeteransEvent, SearchVeteransState>> transformEvents(
      Stream<SearchVeteransEvent> events,
      TransitionFunction<SearchVeteransEvent, SearchVeteransState> transitionFn) {
    return events
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap(transitionFn);
  }

  Stream<SearchVeteransState> _mapSearchVeterans(String text) async* {
    try {
      if (text.isNotEmpty) {
        veteransRepository.searchByFullName(text).then((veteransSnapshot) {
          if (!veteransSnapshot.empty)
            add(SearchUpdated(
                AlgoliaVeteransUpdatedAdapter(veteransSnapshot: veteransSnapshot,
                    text: text, page: 0
                )));
          else
            add(NotFoundEvent());
        });
      } else {
        add(EmptySearchEvent());
      }
    } catch (e) {
      add(NotFoundEvent());
    }
  }

  _mapFetchVeterans(){
    String text = (state as SearchVeteransSuccess).text;
    int page = (state as SearchVeteransSuccess).page;
    page++;
    veteransRepository.searchByFullName(text, page: page).then((veteransSnapshot) {
      if (!veteransSnapshot.empty)
        add(SearchUpdated(
            AlgoliaVeteransUpdatedAdapter(veteransSnapshot: veteransSnapshot,
                text: text, page: page
            )));
      else
        add(NotFoundEvent());
    });
  }

  Stream<SearchVeteransState> _updateVeterans(
      VeteransUpdatedAdapter veteransUpdatedAdapter) async* {
    if(state is SearchVeteransSuccess) yield SearchVeteransSuccess
      (veteransUpdatedAdapter, state);
    else  yield SearchVeteransSuccess
      (veteransUpdatedAdapter, null);
  }

  Stream<SearchVeteransState> _navigateToVeterans() async* {
    yield EmptySearchVeteran();
  }
}
