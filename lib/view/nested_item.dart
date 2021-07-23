import 'package:flutter/material.dart';

import 'history_header_delegate.dart';

class CustomNestedView extends StatelessWidget {
  Widget header;
  Widget body;
  CustomNestedView({this.header, this.body});

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              header
            ]),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: HistoryHeaderDelegate(),
          )
        ];
      },
      body: Container(
        padding: EdgeInsets.only(top: 5),
        child: body,
      ),
    );
  }
}