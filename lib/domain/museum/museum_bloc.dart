import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:veterans/data/repositories/museum_repository.dart';
import 'package:veterans/model/museums/museum.dart';

part 'museum_event.dart';
part 'museum_state.dart';

class MuseumBloc extends Bloc<MuseumEvent, MuseumState> {

  MuseumRepository museumRepository;
  String id;

  MuseumBloc({this.museumRepository, this.id}) : super(MuseumInitial());

  @override
  Stream<MuseumState> mapEventToState(
    MuseumEvent event,
  ) async* {
    if(event is StartMuseumPage) _loadMuseum(id);
    if(event is MuseumLoaded) yield MuseumSuccess(museum:  event.museum);
    else yield MuseumFailure();
  }

  Stream<MuseumState> _loadMuseum(String id) {
    try{
      museumRepository.museum(id).listen((museum) {
          add(MuseumLoaded(museum: museum));
      });
    }catch(_){
      add(MuseumLoadFailure());
    }
  }
}
