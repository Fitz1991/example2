part of 'museum_bloc.dart';

@immutable
abstract class MuseumState {}

class MuseumInitial extends MuseumState {}


class MuseumSuccess extends MuseumState {
  Museum museum;

  MuseumSuccess({this.museum});
}

class MuseumFailure extends MuseumState {}
