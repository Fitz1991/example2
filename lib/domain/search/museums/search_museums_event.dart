part of 'search_museums_bloc.dart';

@immutable
abstract class SearchMuseumsEvent {}


class SearchStart  extends SearchMuseumsEvent{
  SearchStart(this.text);

  String text;
}
class SearchUpdated  extends SearchMuseumsEvent{
  List<Museum> museums;
  SearchUpdated(this.museums);
}

class NotFoundEvent  extends SearchMuseumsEvent{}

class EmptySearchEvent  extends SearchMuseumsEvent{}