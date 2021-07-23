part of 'veterans_bloc.dart';


class VeteransState {
}


class VeteransInitialState extends VeteransState{
}

class VeteransLazyLoadedState extends VeteransState{
  List<Veteran> veterans = [];
  List<QuerySnapshot> veteransQuerySnapshot=[];
  VeteransUpdatedAdapter veteransUpdatedAdapter;

  VeteransLazyLoadedState(this.veteransUpdatedAdapter, VeteransLazyLoadedState state){
    veterans = (state != null) ? state.veterans : [];
    QuerySnapshot veteranSnap = veteransUpdatedAdapter.getSnapshot() as
    QuerySnapshot;
    veteransQuerySnapshot.add(veteranSnap);
    veterans.addAll(veteransUpdatedAdapter.veterans);
  }
}

class VeteransEmptyState extends VeteransState{}




