part of 'search_veterans_bloc.dart';

@immutable
abstract class SearchVeteransEvent {}

class SearchStart  extends SearchVeteransEvent{
  SearchStart(this.text);

  String text;
}

class SearchFetchVeterans  extends SearchVeteransEvent{
  SearchFetchVeterans();
}

class SearchUpdated  extends SearchVeteransEvent{
  VeteransUpdatedAdapter veteransUpdatedAdapter;
  SearchUpdated(this.veteransUpdatedAdapter);
}



class NotFoundEvent  extends SearchVeteransEvent{}

class EmptySearchEvent  extends SearchVeteransEvent{}