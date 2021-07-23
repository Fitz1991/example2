import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:veterans/domain/veteran/from_file/veteran_file_bloc.dart';
import '../../main.dart';
import '../app_frame.dart';
import '../main_app_bar.dart';
import 'back_button_share_veteran_pdf.dart';

class ShareVeteranPage extends StatelessWidget {
  File pdfFile;
  String _title = '';
  String _text = '';
  String veteranFio;

  ShareVeteranPage({this.pdfFile, this.veteranFio});

  @override
  Widget build(BuildContext context) {
    pdfFile =
        (BlocProvider.of<VeteranFileBloc>(context).state as ShareVeteranInfo)
            .pdfFile;
    return AppFrame(
        mainAppBar: MainAppBar(
          title: Text(
            'Поделиться',
            style: Theme.of(context).textTheme.headline1,
          ),
          backButton: BackButtonShareVeteranPdf(
              context: context, pathToFileVeteran: pdfFile),
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Wrap(
              runSpacing: 10,
              children: [
                CupertinoTextField(
                  placeholder: 'Сообщение',
                  onChanged: (value) => _title = value,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.attach_file,
                      color: Theme.of(context).dividerColor,
                    ),
                    Text('$veteranFio.pdf')
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            IconData(MyApp.codePoint, fontFamily: 'send'),
            color: Colors.white,
          ),
          onPressed: () {
            try {
              FlutterShare.shareFile(
                title: _title,
                text: _text,
                filePath: "${pdfFile.path}",
              ).then((value) => {
                    if (!value)
                      {
                        BlocProvider.of<VeteranFileBloc>(context)
                            .add(FailureShareVeteran())
                      }
                  });
            } catch (e) {
              BlocProvider.of<VeteranFileBloc>(context)
                  .add(FailureShareVeteran());
            }
          },
        ));
  }
}
