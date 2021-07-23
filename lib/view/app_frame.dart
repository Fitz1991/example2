import 'package:flutter/material.dart';
import 'bottom_navigation.dart';

class AppFrame extends StatelessWidget {
  Widget mainAppBar;
  Widget body;
  Widget bottomNavigation;
  Widget floatingActionButton;

  AppFrame(
      {this.mainAppBar,
      this.body,
      this.bottomNavigation,
      this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10), child: mainAppBar),
      ),
      body: Container(child: body),
      bottomNavigationBar:
          (bottomNavigation != null) ? bottomNavigation : BottomNavigation(),
      floatingActionButton:
          (floatingActionButton != null) ? floatingActionButton : null,
    );
  }
}
