import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veterans/model/veterans/veteran_info_arguments.dart';
import 'veterans_widget_view.dart';


class VeteransMapWidget extends StatelessWidget {
  VeteranInfoArguments _veteranInfoArguments;

  @override
  Widget build(BuildContext context) {
    _veteranInfoArguments = (ModalRoute.of(context).settings.arguments as VeteranInfoArguments);
    return BlocProvider.value(
        value: _veteranInfoArguments.mapBloc,
        child: VeteransMapWidgetView()
    );
  }
}
