import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veterans/domain/veteran/from_file/veteran_file_bloc.dart';
import 'package:veterans/view/veteran_page/back_button.dart';


class BackButtonShareVeteranPdf implements BackButtonAppbar{
  BuildContext context;
  File pathToFileVeteran;
  BackButtonShareVeteranPdf({this.context, this.pathToFileVeteran});

  backButton()
  {
    BlocProvider.of<VeteranFileBloc>(context).add(SuccessSaveVeteran(pdfFile: pathToFileVeteran));
  }
}