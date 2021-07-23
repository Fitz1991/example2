import 'package:flutter/material.dart';
import 'package:veterans/view/app_frame.dart';
import 'package:veterans/view/main_app_bar.dart';

class ErrorPage extends StatelessWidget {

  String titleMessage;
  String bodyMessage;
  ErrorPage({this.titleMessage, this.bodyMessage});

  @override
  Widget build(BuildContext context) {
    return
      AppFrame(
        mainAppBar: MainAppBar(
          title: Text(
            '$titleMessage',
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        body: Container(
          child: Center(
              child: Text('$bodyMessage')),
        ),
      );
  }
}
