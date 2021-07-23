import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veterans/domain/veteran/veteran_bloc.dart';
import 'package:veterans/model/veterans/veteran.dart';
import 'package:veterans/view/veteran_page/back_button.dart';


class BackButtonPreviewVeteranPdf implements BackButtonAppbar{
  BuildContext context;
  Veteran veteran;
  BackButtonPreviewVeteranPdf({this.context, this.veteran});

  backButton()
  {
    if(veteran != null) BlocProvider.of<VeteranBloc>(context).add(VeteranLoaded(veteran: veteran));
    else BlocProvider.of<VeteranBloc>(context).add(StartVeteranPage());
  }
}