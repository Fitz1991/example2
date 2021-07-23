part of 'map_bloc.dart';

@immutable
abstract class MapState {}

class InitialMap extends  MapState{}

class Map extends MapState {
  Map();
}

class VeteransOnMap extends MapState {
  List<Veteran> veterans;
  double latitude;
  double longitude;
  VeteransOnMap(this.veterans, this.latitude, this.longitude);
}


class MapWithVeterans extends MapState {
  Veteran veteran;
  List<Veteran> veterans;
  MapWithVeterans(this.veteran, this.veterans);
}

class VeteranOnMap extends MapState {
  Veteran veteran;
  List<Veteran> veterans;
  VeteranOnMap(this.veteran, this.veterans);
}



class MapLoading extends MapState {}
class LocationPermissionError extends MapState {}
