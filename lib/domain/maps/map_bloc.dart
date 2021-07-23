import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart' as loc;
import 'package:meta/meta.dart';
import 'package:veterans/data/repositories/veterans/veterans_repository.dart';
import 'package:veterans/domain/maps/move_place_cubit.dart';
import 'package:veterans/model/veterans/veteran.dart';

part 'map_event.dart';

part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  VeteranRepository repository;

  MapBloc(this.repository) : super(InitialMap());
  bool _serviceEnabled;
  loc.Location location = new loc.Location();
  loc.LocationData _locationData;
  double _latitude;
  double _longtitude;
  loc.PermissionStatus _permissionGranted;
  MovePlaceCubit movePlaceCubit = MovePlaceCubit();

  @override
  Stream<MapState> mapEventToState(
    MapEvent event,
  ) async* {
    if (event is ShowVeteransOnMap) {
      yield* _showVeteransOnMap();
    }
    if (event is MoveVeteransOnMap) {
      yield* _moveVeteransOnMap(event);
    }
    if (event is ShowVeteranOnMap) {
      yield* _showVeteranOnMap(event);
    }
    if (event is LoadingVeterans) {
      yield MapWithVeterans(event.veteran, event.veterans);
    }
    if (event is MoveVeteranOnMap) {
      yield* _moveVeteranOnMap(event);
    }
  }

  Stream<MapState> _showVeteransOnMap() async* {
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      await _requestPermission();
    }
    if (_permissionGranted == loc.PermissionStatus.granted) {
      yield MapLoading();
      _locationData = await location.getLocation();
      //Получаем местоположение пользователся
      _latitude = _locationData.latitude;
      _longtitude = _locationData.longitude;
      repository.veteransWithGeocode().listen((snapshot) {
        var veterans = (snapshot as QuerySnapshot).docs.map((doc) {
          return Veteran.fromSnapshot(doc);
        }).toList();
        add(MoveVeteransOnMap(veterans, _latitude, _longtitude));
      });
    } else {
      yield LocationPermissionError();
    }
  }

  Future<void> _requestPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }
  }

  Stream<MapState> _showVeteranOnMap(ShowVeteranOnMap event) async* {
    //получить всех ветеранов
    yield MapLoading();
    repository.veteransWithGeocode().listen((snapshot) {
      var veterans = (snapshot as QuerySnapshot)
          .docs
          .map((doc) => Veteran.fromSnapshot(doc))
          .toList();
      add(LoadingVeterans(event.veteran, veterans));
    });
  }

  Stream<MapState> _moveVeteranOnMap(MoveVeteranOnMap event) async* {
    yield VeteranOnMap(event.veteran, event.veterans);
  }

  Stream<MapState> _moveVeteransOnMap(MoveVeteransOnMap event) async* {
    yield VeteransOnMap(event.veterans, event.latitude, event.longtitude);
  }

}
