import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
import 'package:veterans/domain/veteran/from_file/veteran_file_bloc.dart';
import 'package:veterans/model/veterans/veteran.dart';
import 'package:veterans/view/app_frame.dart';
import 'package:veterans/view/error_page.dart';
import 'package:veterans/view/main_app_bar.dart';
import 'package:veterans/view/veteran_page/share_veteran_page.dart';

import '../../main.dart';
import 'back_button_preview_veteran_pdf.dart';

class VeteranPreviewPdf extends StatelessWidget {
  Uint8List veteranPdfFile;
  Veteran veteran;

  VeteranPreviewPdf({this.veteranPdfFile, this.veteran});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VeteranFileBloc>(
      create: (context) => VeteranFileBloc()
        ..add(SaveVeteran(veteranDocument: veteranPdfFile, fio: veteran.fio)),
      child: BlocBuilder<VeteranFileBloc, VeteranFileState>(
        builder: (context, state) {
          if (state is SuccessResultSaveVeteran) {
            return WillPopScope(
              child: AppFrame(
                mainAppBar: MainAppBar(
                  backButton: BackButtonPreviewVeteranPdf(
                      context: context, veteran: veteran),
                  title: Text(
                    '${veteran.fio}.pdf',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  actions: [
                    IconButton(
                      padding: EdgeInsets.only(right: 10),
                      iconSize: 30,
                      icon: Icon(
                        IconData(MyApp.codePoint, fontFamily: 'share'),
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      onPressed: () {
                        context
                            .bloc<VeteranFileBloc>()
                            .add(ShareVeteranDataInfoPage(state.pdfFile));
                      },
                    )
                  ],
                ),
                body: PDF.file(
                  state.pdfFile,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              onWillPop: () {
                BackButtonPreviewVeteranPdf(context: context, veteran: veteran)
                    .backButton();
                return Future.value(false);
              },
            );
          }
          if (state is ShareVeteranInfo) {
            return ShareVeteranPage(
                pdfFile: state.pdfFile, veteranFio: veteran.fio);
          }
          if (state is FailureShareVeteranResult) {
            return ErrorPage(
              titleMessage: 'Ошибка',
              bodyMessage:
                  'Не удалось поделиться файлом, приносим наши извенения!',
            );
          }
          if (state is VeteranFileInitial) {
            return AppFrame(
              mainAppBar: MainAppBar(
                backButton: BackButtonPreviewVeteranPdf(
                    context: context, veteran: veteran),
                title: Text(
                  'Создание pdf файла...',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              body: Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else {
            return ErrorPage(
              titleMessage: 'Ошибка',
              bodyMessage: 'Неизвестная ошибка, приносим наши извенения!',
            );
          }
        },
      ),
    );
  }
}
