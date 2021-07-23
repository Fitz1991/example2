part of 'veterans_bloc.dart';

class VeteransEvent {
}

class AppStarted extends VeteransEvent{
}

class VeteransEmptyPageEvent extends VeteransEvent{
}

class FetchVeterans extends VeteransEvent{
}

class VeteransUpdated extends VeteransEvent{
  VeteransUpdatedAdapter veteransUpdatedAdapter;
  VeteransUpdated({this.veteransUpdatedAdapter});
}

class VeteransUpdatedBySearch extends VeteransEvent{
  final List<Veteran> veterans;
  VeteransUpdatedBySearch(this.veterans);
}

class VeteransNotFound extends VeteransEvent{}

