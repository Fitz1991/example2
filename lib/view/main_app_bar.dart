import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:veterans/view/veteran_page/back_button.dart';

class MainAppBar extends StatelessWidget {
  Widget customAppbar;
  Widget title;
  List<Widget> actions;
  BackButtonAppbar backButton;

  MainAppBar({this.title, this.actions, this.backButton, this.customAppbar});

  @override
  Widget build(BuildContext context) {
    return (customAppbar == null) ? AppBar(
      brightness: Brightness.light,
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.background,
      leading: Stack(
        children: [
          Positioned(
            right: 10,
            child: Container(
//          padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1, color: Theme.of(context).colorScheme.primary),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: GestureDetector(
                child: IconButton(
                  iconSize: 15,
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onTap: () {
                  (backButton != null)
                      ? backButton.backButton()
                      : Navigator.popAndPushNamed(context, '/');
                },
              ),
            ),
          )
        ],
      ),
      title: title,
      centerTitle: true,
      actions: actions,
    ) : customAppbar;
  }
}
