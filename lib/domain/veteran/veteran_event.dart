part of 'veteran_bloc.dart';

@immutable
abstract class VeteranEvent {}

class StartVeteranPage extends VeteranEvent{}


class VeteranLoaded extends VeteranEvent{
  Veteran veteran;

  VeteranLoaded({this.veteran});
}


class VeteranLoadPdfPreview extends VeteranEvent{
  BuildContext context;
  Veteran veteran;

  VeteranLoadPdfPreview({this.context, this.veteran});
}

class VeteranLoadedPdfPreview extends VeteranEvent{
  Uint8List pdfFile;
  Veteran veteran;
  VeteranLoadedPdfPreview({this.pdfFile, this.veteran});
}

