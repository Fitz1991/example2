import 'package:flutter/material.dart';

import '../main.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();

    _mocklCheckForSession().then((status) {
      if (status)
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => StartPage(),
        ));
    });
  }

  Future<bool> _mocklCheckForSession() async {
    await Future.delayed(Duration(milliseconds: 2000), () {});
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/memory_in_each_street.png'),
                fit: BoxFit.contain)),
      ),
    );
  }
}
