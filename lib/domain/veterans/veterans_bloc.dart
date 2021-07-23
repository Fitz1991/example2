import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veterans/data/repositories/veterans/veterans_repository.dart';
import 'package:veterans/data/resources.dart';
import 'package:veterans/domain/adapters.dart';
import 'package:veterans/model/veterans/veteran.dart';

part 'veterans_event.dart';

part 'veterans_state.dart';

class VeteransBloc extends Bloc<VeteransEvent, VeteransState> {
  VeteranRepository veteransRepository;

  VeteransBloc({this.veteransRepository}) : super(VeteransInitialState());

  StreamSubscription _veteransSubscription;

  @override
  Stream<VeteransState> mapEventToState(
    VeteransEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapLoadVeteransToState();
    }
    if (event is VeteransEmptyPageEvent) {
      yield VeteransEmptyState();
    }
    if (event is FetchVeterans) {
      yield* _mapLoadVeteransToState();
    } else if (event is VeteransUpdated) {
      yield* _mapVeteransUpdateToState(event);
    } else if (event is VeteransNotFound) {
      yield VeteransEmptyState();
    } else {
    }
  }

  Stream<VeteransState> _mapLoadVeteransToState() async* {
    _veteransSubscription?.cancel();
    //если предыдщее состояние загружено
    if (state is VeteransLazyLoadedState) {
      //ьерем последний снимок
      DocumentSnapshot veteranSnap =
          (state as VeteransLazyLoadedState).veteransQuerySnapshot.last.docs.last;
      //поскольку это пердыдущее состояние, данные в снимке есть, берем startAfter
      veteransRepository
          .veterans(limit: veteransPageSize, startAfter: veteranSnap)
          .listen((veteransSnapshot) {
        add(VeteransUpdated(
            veteransUpdatedAdapter: FirebaseVeteransUpdatedAdapter(
                veteransSnapshot: veteransSnapshot as QuerySnapshot)));
      });
    } else {
      veteransRepository.veterans(limit: veteransPageSize).listen((veteransSnapshot) {
        add(VeteransUpdated(
            veteransUpdatedAdapter: FirebaseVeteransUpdatedAdapter(
                veteransSnapshot: veteransSnapshot as QuerySnapshot)));
      });
    }
  }

  Stream<VeteransState> _mapVeteransUpdateToState(VeteransUpdated event) async* {
    if (state is VeteransLazyLoadedState) {
      yield VeteransLazyLoadedState(event.veteransUpdatedAdapter, state);
    } else {
      yield VeteransLazyLoadedState(event.veteransUpdatedAdapter, null);
    }
  }
}
