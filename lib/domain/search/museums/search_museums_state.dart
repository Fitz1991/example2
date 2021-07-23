part of 'search_museums_bloc.dart';

@immutable
abstract class SearchMuseumsState {}

class SearchMuseumsInitial extends SearchMuseumsState {}


class SearchMuseumsProgress extends SearchMuseumsState {}

class SearchMuseumsSuccess extends SearchMuseumsState {
  List<Museum> museums;
  SearchMuseumsSuccess(this.museums);
}

class NotFoundState extends SearchMuseumsState {}

