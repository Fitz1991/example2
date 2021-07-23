import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veterans/data/repositories/museum_repository.dart';
import 'package:veterans/model/museums/museum.dart';


part 'museums_event.dart';
part 'museums_state.dart';

class MuseumsBloc extends Bloc<MuseumsEvent, MuseumsState> {
  MuseumRepository museumRepository;
  MuseumsBloc({this.museumRepository}) : super(MuseumsInitial());

  @override
  Stream<MuseumsState> mapEventToState(
    MuseumsEvent event,
  ) async* {
    if (event is StartMuseumsPage) {
      yield* _mapLoadMuseumsToState();
    } else if (event is MuseumsUpdated) {
      yield* _mapMuseumsUpdateToState(event);
    }
    else if (event is MuseumsNotFound) {
      yield MuseumsEmptyState();
    }
    else {
    }
  }

  Stream<MuseumsState> _mapLoadMuseumsToState() async* {
    museumRepository.museums().listen((museums) {
      add(MuseumsUpdated(museums));
    });
  }

  Stream<MuseumsState> _mapMuseumsUpdateToState(
      MuseumsUpdated event) async* {
    yield MuseumsLoadedState(event.museums);
  }

}
