import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class Search<Event, State> extends StatelessWidget {
  void Function(String) _onChangeSearch;

//  BlocBuilder<Bloc<Event, State>, State> _blocBuilder;


  Search(this._onChangeSearch);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: MyApp.HorizontalPagePadding,
                    vertical: MyApp.SearchPadding),
            child: Column(children: [
              Container(
                child:  CupertinoTextField(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                  clearButtonMode: OverlayVisibilityMode.editing,
                  keyboardType: TextInputType.text,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 0,
                        color: CupertinoColors.inactiveGray,
                      ),
                    ),
                  ),
                  placeholder: 'Поиск',
                  onChanged: (value) => _onChangeSearch(value),
                ),
              ),
            ])));
  }
}
