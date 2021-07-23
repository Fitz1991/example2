import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:veterans/domain/simple_bloc_observer.dart';
import 'package:veterans/view/map_page/veterans/veterans_map_widget.dart';
import 'package:veterans/view/museums_page/museums_page.dart';
import 'package:veterans/view/not_found.dart';
import 'package:veterans/view/splash_screen_page.dart';
import 'package:veterans/view/story_veteran_page.dart';
import 'package:veterans/view/veteran_page/veteran_page.dart';
import 'package:veterans/view/veterans_page/veterans_page.dart';
import 'view/bottom_navigation.dart';
import 'view/contacts.dart';
import 'view/info.dart';
import 'view/muzeum_page/museum_page.dart';
import 'view/tower_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static final PrimaryColor = HexColor('#708160');
  static final AccentColor = HexColor('#48533E');
  static final LineColor = HexColor('#D8C593');
  static final SecondaryColor = HexColor('#F44336');
  static final UnselectedWidgetColor = HexColor('#98AA86');
  static final SliderInactiveStepColor = HexColor('#04DE71');
  static const codePoint = 0xe900;

  static final double HorizontalPagePadding = 15;
  static final double SearchPadding = 8;
  static final double CardPadding = 15;
  static final double CardItemPadding = 8;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) {
          return MaterialApp(
            navigatorKey: _navigatorKey,
            title: 'Ветераны',
            locale: DevicePreview.locale(context), // Add the locale here
            builder: DevicePreview.appBuilder, // Add
            home: StartPage(),
            initialRoute: '/splash_screen',
            debugShowCheckedModeBanner: false,
            routes: {
              '/splash_screen': (BuildContext context) => SplashScreenPage(),
              '/home': (BuildContext context) => StartPage(),
              '/info': (BuildContext context) => InfoPage(),
              '/phone': (BuildContext context) => ContactsPage(),
              '/tower': (BuildContext context) => TowerPage(),
              '/story_veteran': (BuildContext context) => StoryVeteranPage(),
              '/map': (BuildContext context) => VeteransMapWidget(),
            },
            onGenerateRoute: (settings) {
              var path = settings.name.split('/');
              if (path[0] == 'veteran') {
                return MaterialPageRoute(
                    builder: (context) => VeteranPage(id: path[1]), settings: settings);
              }
              if (path[0] == 'map') {
                return MaterialPageRoute(
                    builder: (context) => VeteransMapWidget(),
                    settings: settings.arguments);
              }
              if (path[0] == 'museum') {
                return MaterialPageRoute(
                    builder: (context) => MuseumPage(id: path[1]), settings: settings);
              } else {
                return MaterialPageRoute(
                  builder: (context) => NotFoundPage(),
                );
              }
            },
            theme: ThemeData(
              primaryColor: MyApp.PrimaryColor,
              accentColor: MyApp.AccentColor,
              backgroundColor: Colors.white,
              secondaryHeaderColor: MyApp.PrimaryColor,
              indicatorColor: Colors.transparent,
              accentColorBrightness: Brightness.light,
              buttonColor: MyApp.PrimaryColor,
              bottomAppBarColor: MyApp.PrimaryColor,
              cursorColor: MyApp.PrimaryColor,
              dividerColor: MyApp.LineColor,
              selectedRowColor: MyApp.SecondaryColor,
              fontFamily: 'LatoRegular',
              accentIconTheme: IconThemeData(color: MyApp.PrimaryColor),

              highlightColor: MyApp.LineColor,
              focusColor: MyApp.SecondaryColor,
              splashColor: Colors.lightGreen.shade600,
              hintColor: CupertinoColors.inactiveGray,
//        hoverColor: SecondaryColor,
//        disabledColor: SecondaryColor,
              unselectedWidgetColor: MyApp.UnselectedWidgetColor,
              colorScheme: ColorScheme(
                  brightness: Brightness.light,
                  error: Colors.red,
                  onError: Colors.white,
                  primaryVariant: MyApp.SecondaryColor,
                  secondaryVariant: MyApp.PrimaryColor,
                  background: Colors.white,
                  primary: MyApp.PrimaryColor,
                  secondary: MyApp.SecondaryColor,
                  onBackground: MyApp.PrimaryColor,
                  onPrimary: Colors.white70,
                  onSecondary: Colors.white70,
                  onSurface: Colors.red,
                  surface: Colors.white70),

              // Define the default TextTheme. Use this to specify the default
              // text styling for headlines, titles, bodies of text, and more.
              tabBarTheme: TabBarTheme(
                  labelColor: MyApp.PrimaryColor,
                  labelStyle: TextStyle(
                      fontSize: 20,
                      color: MyApp.PrimaryColor,
                      fontWeight: FontWeight.bold),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 20,
                    color: MyApp.UnselectedWidgetColor,
                  )),

              textTheme: TextTheme(
                  headline1: TextStyle(
                      fontSize: 20,
                      color: MyApp.PrimaryColor,
                      fontWeight: FontWeight.normal),
                  headline2: TextStyle(
                      fontSize: 20,
                      color: MyApp.SecondaryColor,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                  headline3: TextStyle(
                      fontSize: 20,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                  headline4: TextStyle(
                      fontSize: 18,
                      color: MyApp.PrimaryColor,
                      fontWeight: FontWeight.bold),
                  headline5: TextStyle(
                      fontSize: 16,
                      color: MyApp.SecondaryColor,
                      fontWeight: FontWeight.bold),
                  headline6: TextStyle(
                      fontSize: 14,
                      color: MyApp.PrimaryColor,
                      fontWeight: FontWeight.bold),
                  caption: TextStyle(
                      fontSize: 14,
                      color: MyApp.SecondaryColor,
                      fontWeight: FontWeight.normal),
                  overline: TextStyle(
                      fontSize: 14, color: Colors.white70, fontWeight: FontWeight.normal),
                  bodyText1: TextStyle(
                      fontSize: 18, color: Colors.white70, fontWeight: FontWeight.normal),
                  bodyText2: TextStyle(
                      fontSize: 16,
                      color: MyApp.PrimaryColor,
                      fontWeight: FontWeight.w200),
                  subtitle1: TextStyle(
                      fontSize: 14,
                      color: MyApp.PrimaryColor,
                      fontWeight: FontWeight.normal),
                  subtitle2: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: MyApp.SecondaryColor)),
            ),
          );
        }
        ,
      );
  }
}

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MyApp.HorizontalPagePadding, vertical: 10),
              child: AppBar(
                brightness: Brightness.light,
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.background,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(80),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).colorScheme.primary, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: TabBar(
                        labelPadding: EdgeInsets.all(0),
                        labelStyle: Theme.of(context).tabBarTheme.labelStyle,
                        unselectedLabelStyle:
                            Theme.of(context).tabBarTheme.unselectedLabelStyle,
                        tabs: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: Icon(const IconData(MyApp.codePoint,
                                      fontFamily: 'medal')),
                                ),
                                Text('Ветераны',
                                    style: TextStyle(fontFamily: 'LatoRegular')),
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: Icon(const IconData(MyApp.codePoint,
                                      fontFamily: 'museum')),
                                ),
                                Text('Музеи',
                                    style: TextStyle(fontFamily: 'LatoRegular')),
                              ]),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
        ),
        body: TabBarView(
          children: [VeteransPage(), MuseumsPage()],
        ),
        bottomNavigationBar: BottomNavigation(),
      ),
    );
  }
}
