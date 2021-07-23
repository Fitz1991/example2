part of 'map_bloc.dart';

@immutable
abstract class MapEvent {}
class ShowVeteransOnMap extends MapEvent {
  ShowVeteransOnMap();
}

class MapLoad extends MapEvent {}


class MoveVeteransOnMap extends MapEvent {
  List<Veteran> veterans;
  double latitude;
  double longtitude;
  MoveVeteransOnMap(this.veterans, this.latitude, this.longtitude);
}

class ShowVeteranOnMap extends MapEvent {
  Veteran veteran;
  List<Veteran> veterans;
  ShowVeteranOnMap({this.veteran, this.veterans});
}

//детальеый обзор ветерана

class LoadingVeterans extends MapEvent {
  Veteran veteran;
  List<Veteran> veterans;
  LoadingVeterans(this.veteran, this.veterans);
}

class MoveVeteranOnMap extends MapEvent {
  Veteran veteran;
  List<Veteran> veterans;
  MoveVeteranOnMap(this.veteran, this.veterans);
}








