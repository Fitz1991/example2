part of 'veteran_file_bloc.dart';

@immutable
abstract class VeteranFileState {}

class VeteranFileInitial extends VeteranFileState {}


class SuccessResultSaveVeteran extends VeteranFileState{
  File pdfFile;

  SuccessResultSaveVeteran({this.pdfFile});
}
class FailureShareVeteranResult extends VeteranFileState{}

class FailureSaveVeteran extends VeteranFileState{}

class ShareVeteranInfo extends VeteranFileState{
  File pdfFile;
  ShareVeteranInfo(File pdfFile) : pdfFile = pdfFile;
}

