part of 'search_veterans_bloc.dart';

@immutable
abstract class SearchVeteransState {}

class SearchVeteransInitial extends SearchVeteransState {}


class SearchVeteransProgress extends SearchVeteransState {}

class SearchVeteransSuccess extends SearchVeteransState {
  List<Veteran> veterans = [];
  List<AlgoliaQuerySnapshot> veteransSnapshots = [];
  VeteransUpdatedAdapter veteransUpdatedAdapter;
  int page;
  String text;

  SearchVeteransSuccess(this.veteransUpdatedAdapter, SearchVeteransSuccess state){
    page = (veteransUpdatedAdapter as AlgoliaVeteransUpdatedAdapter).page;
    text = (veteransUpdatedAdapter as AlgoliaVeteransUpdatedAdapter).text;
    veterans = (state != null) ? state.veterans : [];
    AlgoliaQuerySnapshot veteranSnap = veteransUpdatedAdapter.getSnapshot() as
    AlgoliaQuerySnapshot;
    veteransSnapshots.add(veteranSnap);
    veterans.addAll(veteransUpdatedAdapter.veterans);
  }
}

class NotFoundState extends SearchVeteransState {}

class EmptySearchVeteran extends SearchVeteransState{}
