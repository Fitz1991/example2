part of 'museum_bloc.dart';

@immutable
abstract class MuseumEvent {}

class StartMuseumPage extends MuseumEvent{}

class MuseumLoaded extends MuseumEvent{
  Museum museum;

  MuseumLoaded({this.museum});
}

class MuseumLoadFailure extends MuseumEvent{}


