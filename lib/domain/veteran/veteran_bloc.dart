import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:veterans/data/repositories/veterans/veterans_repository.dart';
import 'package:veterans/model/veterans/veteran.dart';
import 'package:veterans/view/veteran_page/veteran_pdf_page.dart';

part 'veteran_event.dart';

part 'veteran_state.dart';

class VeteranBloc extends Bloc<VeteranEvent, VeteranState> {
  String documentId;
  VeteranRepository firestoreRepository;
  VeteranPdfPage veteranPdfPage;
  Uint8List pdfFile;

  VeteranBloc({this.documentId, this.firestoreRepository})
      : super(VeteranInitial());

  @override
  Stream<VeteranState> mapEventToState(
    VeteranEvent event,
  ) async* {
    if (event is StartVeteranPage) {
      yield* _loadVeteran(documentId);
    }
    if (event is VeteranLoadPdfPreview) {
      yield* _veteranLoadPdfPreview(event);
    }
    if (event is VeteranLoaded) {
      yield* _loadedVeteran(event);
    }
    if (event is VeteranLoadedPdfPreview) {
      yield* _veteranLoadedPdfPreview(event);
    }
  }

  Stream<VeteranState> _loadedVeteran(VeteranLoaded event) async* {
    yield VeteranSuccess(veteran: event.veteran);
  }

  Stream<VeteranState> _loadVeteran(String documentId) async* {
    try {
      firestoreRepository.veteran(documentId).listen((veteran) {
        add(VeteranLoaded(veteran: veteran));
      });
    } catch (_) {
      yield VeteranFailure();
    }
  }

  Stream<VeteranState> _veteranLoadPdfPreview(VeteranLoadPdfPreview event) async* {
    try {
      yield VeteranPdfLoadProgress();
      veteranPdfPage = VeteranPdfPage(context: event.context);
      pdfFile = await veteranPdfPage.build(event.veteran);
      add(VeteranLoadedPdfPreview(pdfFile: pdfFile, veteran: event.veteran));
    }catch (e) {
      if(e is SocketException) yield VeteranFailure(titleMessage: 'Ошибка сети', bodyMessage: 'Проверьте соединение с интернетом');
      else{
        print(e);
        print(e.stackTrace);
        yield VeteranFailure();
      }
    }
  }

  Stream<VeteranState> _veteranLoadedPdfPreview(VeteranLoadedPdfPreview event) async* {
    yield VeteranPdfPreview(pdfFile: event.pdfFile, veteran: event.veteran);
  }
}
