part of 'move_place_cubit.dart';

@immutable
abstract class MovePlaceState {}

class MovePlaceInitial extends MovePlaceState {}
class MovingPlace extends MovePlaceState {
  Veteran veteran;
  double latitude;
  double longtitude;
  List<Veteran> veterans;

  MovingPlace(this.veterans, {this.veteran, this.latitude, this.longtitude});
}
