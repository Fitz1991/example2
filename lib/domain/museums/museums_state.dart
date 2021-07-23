part of 'museums_bloc.dart';

@immutable
abstract class MuseumsState {}

class MuseumsInitial extends MuseumsState {}

class MuseumsLoadedState extends MuseumsState{
  List<Museum> museums;
  MuseumsLoadedState(this.museums);
}

class MuseumsEmptyState extends MuseumsState{}
