part of 'veteran_bloc.dart';

@immutable
abstract class VeteranState {}

class VeteranInitial extends VeteranState {}

class VeteranSuccess extends VeteranState {
  Veteran veteran;

  VeteranSuccess({this.veteran});
}

class VeteranFailure extends VeteranState{
  String titleMessage;
  String bodyMessage ;

  VeteranFailure({this.titleMessage = 'Неизвестная ошибка', this.bodyMessage = "Неизвестная ошибка, попробуйте еще раз"});
}

class VeteranPdfPreview extends VeteranState{
  Uint8List pdfFile;
  Veteran veteran;
  VeteranPdfPreview({this.pdfFile, this.veteran});
}

class VeteranPdfLoadProgress extends VeteranState{}