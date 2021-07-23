import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class BottomNavigation extends StatefulWidget {
  int selectedIndex = 0;

  BottomNavigation({this.selectedIndex = 0});

  @override
  BottomNavigation_State createState() => BottomNavigation_State();
}

class BottomNavigation_State extends State<BottomNavigation> {
  int selectedIndex ;
  @override
  void initState() {
     selectedIndex = widget.selectedIndex;
  }

  List<NavIconData> items = [
    NavIconData(fontFamily: "home"),
    NavIconData(fontFamily: "info"),
    NavIconData(fontFamily: "phone"),
    NavIconData(fontFamily: "tower"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.map((item) {
            var itemIndex = items.indexOf(item);
            Widget navItem = NavigationItem(
              iconData: item,
              isSelected: (selectedIndex == itemIndex),
            );
            if(itemIndex == 3){
              navItem = Tooltip(
                message: 'Сурский рубеж',
                child: navItem,
              );
            }

            return InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () {
                switch(itemIndex){
                  case 0 : return Navigator.pushReplacementNamed(context, '/home');
                  case 1 : return Navigator.pushReplacementNamed(context, '/info');
                  case 2 : return Navigator.pushReplacementNamed(context, '/phone');
                  case 3 : return Navigator.pushReplacementNamed(context, '/tower');
                }
              },
              child: navItem
            );
          }).toList()),
    );
  }
}

class NavigationItem extends StatelessWidget {
  NavIconData iconData;
  bool isSelected;

  NavigationItem({this.iconData, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    if (isSelected)
      return Container(
        padding: EdgeInsets.all(10),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50))),
        child:
        Icon(
          IconData(MyApp.codePoint, fontFamily: iconData.fontFamily),
          color: Theme.of(context).primaryColor,
        ),
      );
    else {
      return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Icon(
          IconData(MyApp.codePoint, fontFamily: iconData.fontFamily),
          color: Theme.of(context).unselectedWidgetColor,
        ),
      );
    }
  }
}

class NavIconData {
  bool isSelected;
  String fontFamily;

  NavIconData({this.isSelected = false, this.fontFamily});
}
