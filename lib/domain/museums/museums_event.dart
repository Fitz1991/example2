part of 'museums_bloc.dart';

@immutable
abstract class MuseumsEvent {}

class StartMuseumsPage extends MuseumsEvent{
}

class MuseumsUpdated extends MuseumsEvent{
  final List<Museum> museums;
  MuseumsUpdated(this.museums);
}

class MuseumsUpdatedBySearch extends MuseumsEvent{
  final List<Museum> museums;
  MuseumsUpdatedBySearch(this.museums);
}

class MuseumsNotFound extends MuseumsEvent{}