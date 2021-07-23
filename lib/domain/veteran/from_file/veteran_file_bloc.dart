import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pdf/widgets.dart';
import 'package:veterans/data/file_providers/file_veteran_provider.dart';
import 'package:veterans/data/repositories/veterans/file_veteran_repository.dart';
import 'package:veterans/model/veterans/veteran.dart';

part 'veteran_file_event.dart';
part 'veteran_file_state.dart';

class VeteranFileBloc extends Bloc<VeteranFileEvent, VeteranFileState> {
  VeteranFileBloc() : super(VeteranFileInitial());

  FileVeteranRepository _fileVeteranRepository = FileVeteranRepository(FileVeteranProvider());

  File pdfFile;

  @override
  Stream<VeteranFileState> mapEventToState(
    VeteranFileEvent event,
  ) async* {
      if(event is SaveVeteran) yield* _saveVeteran(event.veteranDocument, event.fio);
      if(event is ShareVeteranDataInfoPage) yield ShareVeteranInfo(event.pdfFile);
      if(event is FailureShareVeteran) yield FailureShareVeteranResult();
      if(event is SuccessSaveVeteran) yield SuccessResultSaveVeteran(pdfFile: event.pdfFile);
  }

  Stream<VeteranFileState> _saveVeteran(Uint8List veteranDocument, String fio) async* {
    assert (veteranDocument != null);
    try{
      var veteran = Veteran(fio: fio, pdfFile: veteranDocument);
      _fileVeteranRepository.createVeteran(veteran).listen((pdfFile) {
        pdfFile = pdfFile;
        add(SuccessSaveVeteran(pdfFile: pdfFile));
      });
    } catch(e){
        yield FailureSaveVeteran();
    }
  }

}
