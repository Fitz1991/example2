part of 'veteran_file_bloc.dart';

@immutable
abstract class VeteranFileEvent {}

class SaveVeteran extends  VeteranFileEvent {
  Uint8List veteranDocument;
    String fio;

    SaveVeteran({this.veteranDocument, this.fio});
}

class SuccessShareVeteran extends VeteranFileEvent{
}

class FailureShareVeteran extends VeteranFileEvent{
}

class SuccessSaveVeteran extends VeteranFileEvent{
  File pdfFile;
  SuccessSaveVeteran({this.pdfFile});
}

class ShareVeteranDataInfoPage extends VeteranFileEvent{
  File pdfFile;
  ShareVeteranDataInfoPage(File pdfFile) : pdfFile = pdfFile;
}




