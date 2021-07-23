import 'package:flutter/material.dart';

class BackButtonAppbar {
  BuildContext context;

  BackButtonAppbar({this.context});

  backButton() {
    Navigator.pop(context);
  }
}
