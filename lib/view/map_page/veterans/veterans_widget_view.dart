import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veterans/domain/maps/map_bloc.dart';
import 'package:veterans/domain/maps/move_place_cubit.dart';
import 'package:veterans/model/veterans/veteran.dart';
import 'package:veterans/model/veterans/veteran_info_arguments.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../../main.dart';
import '../../app_frame.dart';
import '../../main_app_bar.dart';

class VeteransMapWidgetView extends StatefulWidget {
  @override
  _VeteransMapWidgetViewState createState() => _VeteransMapWidgetViewState();
}

class _VeteransMapWidgetViewState extends State<VeteransMapWidgetView> {


  double latitude;

  double longitude;

  YandexMapController controller;

  VeteranInfoArguments _veteranArguments;

  String _appBarTitle = 'Карта ветеранов';

  YandexMap yandexMap;

  BuildContext _context;

  void _move(MovingPlace state) async{
    Future.delayed(Duration(milliseconds: 300), (){
      controller.move(
          point: (state.veteran != null) ? Point(
            latitude: double.parse(state.veteran.geocode.latitude),
            longitude: double.parse(state.veteran.geocode.longitude),
          ) :  Point(
            latitude: state.latitude,
            longitude: state.longtitude,
          ),
          zoom: (state.veteran != null) ? 15.0 : 7,
          animation: const MapAnimation(smooth: true, duration: 2.0));
    });
  }

  void _showMessage(BuildContext context, Text text) {
    final ScaffoldState scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: text,
        action: SnackBarAction(label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  void _showDialog(Veteran veteran) {
    // flutter defined function
    showDialog(
      context: _context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("${veteran.fio}"),
          content: Container(
            height: MediaQuery.of(context).size.height / 3,
            child: Column(
              children: [
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: CachedNetworkImage(
                      imageUrl: veteran.images[0],
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) =>
                          Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/images/memory_in_each_street.png')
                                )
                            ),
                          ),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error),
                    )
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Wrap(
                    children: [
                      //subtitle
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: MyApp.CardItemPadding),
                            child: Icon(
                                IconData(MyApp.codePoint, fontFamily: 'strap'),
                                color: MyApp.SecondaryColor,
                                size: 20),
                          ),
                          Flexible(
                              child: Text(
                                '${veteran.militaryRank}',
                                style: Theme.of(context).textTheme.subtitle2,
                                overflow: TextOverflow.ellipsis,
                              ))
                        ],
                      ),
                      Row(
                        children: [
                          Text('${veteran.yearOfBirth}',
                              style: Theme.of(context).textTheme.subtitle1),
                          Text('${veteran.yearOfDeath}',
                              style: Theme.of(context).textTheme.subtitle1),
                          Text(
                            '${veteran.yearsOld}',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Назад"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            new FlatButton(
              child: new Text("Перейти"),
              onPressed: () {
                Navigator.pushNamed(context, 'veteran/${veteran.id}',
                    arguments: VeteranInfoArguments(_veteranArguments.mapBloc));
              },
            ),
          ],
        );
      },
    );
  }

  void _addPlacemark(List<Veteran> veterans, Veteran currentVeteran) async {
    Future.delayed(Duration(milliseconds: 300), () async {
      Placemark _placemark;
      await Future.forEach(veterans, (Veteran veteran) async {
        if (veteran.geocode != null && veteran.geocode.latitude != 'null') {
          Point _point = Point(
              latitude: double.parse(veteran.geocode.latitude),
              longitude: double.parse(veteran.geocode.longitude));
          if (currentVeteran != null) {
            if (veteran.id == currentVeteran.id) {
              Uint8List bytes =
              (await NetworkAssetBundle(Uri.parse(currentVeteran.images[0]))
                  .load(currentVeteran.images[0]))
                  .buffer
                  .asUint8List();
              _placemark = Placemark(
                point: _point,
                scale: 0.1,
                rawImageData: bytes,
                onTap: (Point point) => _showDialog(veteran),
              );
            } else {
              _placemark = Placemark(
                point: _point,
                opacity: 0.7,
                scale: 0.4,
                iconName: 'assets/images/placemark.png',
                onTap: (Point point) => _showDialog(veteran),
              );
            }
          } else {
            _placemark = Placemark(
              point: _point,
              opacity: 0.7,
              scale: 0.4,
              iconName: 'assets/images/placemark.png',
              onTap: (Point point) => _showDialog(veteran),
            );
          }
          controller.addPlacemark(_placemark);
        }
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    _veteranArguments = ModalRoute.of(context).settings.arguments;

    BlocProvider. of<MapBloc>(context).movePlaceCubit.listen((state) {
      if(state is MovingPlace){
        _addPlacemark(state.veterans, state.veteran);
        _move(state);
      }
    });

    return
      BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          if (state is MapWithVeterans) {
            BlocProvider. of<MapBloc>(context).movePlaceCubit
                .moveToPlace(state.veterans, veteran: state.veteran);
            return  AppFrame(
              mainAppBar: MainAppBar(
                title: Text(
                  '${state.veteran.fio}',
                  style: Theme.of(context).tabBarTheme.labelStyle,
                ),
              ),
              body: YandexMap(
                onMapCreated: (YandexMapController yandexMapController) async {
                  controller = yandexMapController;
                },
              ),
            );
          }
          if(state is VeteransOnMap){
            BlocProvider. of<MapBloc>(context).
            movePlaceCubit.moveToPlace(state.veterans, latitude: state
                .latitude, longtitude:
            state.longitude, veteran: null);
            return AppFrame(
              mainAppBar: MainAppBar(
                title: Text(
                  'Ветераны на карте',
                  style: Theme.of(context).tabBarTheme.labelStyle,
                ),
              ),
              body: YandexMap(
                onMapCreated: (YandexMapController yandexMapController) async {
                  controller = yandexMapController;
                },
              ),
            );
          }
          if (state is MapLoading) {
            return AppFrame(
                mainAppBar: MainAppBar(
                  title: Text(
                    _appBarTitle,
                    style: Theme.of(context).tabBarTheme.labelStyle,
                  ),
                ),
                body: Stack(
                  children: [
                    YandexMap(
                      onMapCreated: (YandexMapController yandexMapController) async {
                        controller = yandexMapController;
                      },
                    ),
                    Center(
                      child: CircularProgressIndicator(),
                    )
                  ],
                ));
          }
          if (state is LocationPermissionError) {
            _showMessage(
              context,
              Text('Доступ к местоположению запрещен'),
            );
            return AppFrame(
                mainAppBar: MainAppBar(
                  title: Text(
                    _appBarTitle,
                    style: Theme.of(context).tabBarTheme.labelStyle,
                  ),
                ),
                body: Stack(
                  children: [
                    YandexMap(
                      onMapCreated: (YandexMapController yandexMapController) async {
                        controller = yandexMapController;
                      },
                    )
                  ],
                ));
          } else {
            return AppFrame(
                mainAppBar: MainAppBar(
                  title: Text(
                    _appBarTitle,
                    style: Theme.of(context).tabBarTheme.labelStyle,
                  ),
                ),
                body: YandexMap(
                  onMapCreated: (YandexMapController yandexMapController) async {
                    controller = yandexMapController;
                  },
                ));
          }
        },
      );
  }
}


// class VeteransMapWidgetView extends StatefulWidget {
//   double latitude;
//   double longitude;
//
//   VeteransMapWidgetView();
//
//   @override
//   _VeteransMapWidgetViewState createState() => _VeteransMapWidgetViewState();
// }
//
// class _VeteransMapWidgetViewState extends State<VeteransMapWidgetView> {
//   YandexMapController controller;
//   VeteranInfoArguments _veteranArguments;
//   String _appBarTitle = 'Карта ветеранов';
//   YandexMap yandexMap;
//
//   @override
//   void initState() {
//     super.initState();
//     yandexMap = YandexMap(
//       onMapCreated: (YandexMapController yandexMapController) async {
//         controller = yandexMapController;
//       },
//     );
//   }
//
//   void _showMessage(BuildContext context, Text text) {
//     final ScaffoldState scaffold = Scaffold.of(context);
//     scaffold.showSnackBar(
//       SnackBar(
//         content: text,
//         action: SnackBarAction(label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
//       ),
//     );
//   }
//
//   void _showDialog(Veteran veteran) {
//     // flutter defined function
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         // return object of type Dialog
//         return AlertDialog(
//           title: new Text("${veteran.fio}"),
//           content: Container(
//             height: MediaQuery.of(context).size.height / 3,
//             child: Column(
//               children: [
//                 Expanded(
//                   flex: 6,
//                   child: Padding(
//                     padding: const EdgeInsets.only(bottom: 10),
//                     child: Image.network(veteran.images[0]),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 2,
//                   child: Wrap(
//                     children: [
//                       //subtitle
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.only(bottom: MyApp.CardItemPadding),
//                             child: Icon(
//                                 IconData(MyApp.codePoint, fontFamily: 'strap'),
//                                 color: MyApp.SecondaryColor,
//                                 size: 20),
//                           ),
//                           Flexible(
//                               child: Text(
//                             '${veteran.militaryRank}',
//                             style: Theme.of(context).textTheme.subtitle2,
//                             overflow: TextOverflow.ellipsis,
//                           ))
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Text('${veteran.yearOfBirth}',
//                               style: Theme.of(context).textTheme.subtitle1),
//                           Text('${veteran.yearOfDeath}',
//                               style: Theme.of(context).textTheme.subtitle1),
//                           Text(
//                             '${veteran.yearsOld}',
//                             style: Theme.of(context).textTheme.headline6,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             // usually buttons at the bottom of the dialog
//             new FlatButton(
//               child: new Text("Назад"),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//             new FlatButton(
//               child: new Text("Перейти"),
//               onPressed: () {
//                 Navigator.pushNamed(context, 'veteran/${veteran.id}',
//                     arguments: VeteranInfoArguments(_veteranArguments.mapBloc));
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   _addPlacemark(List<Veteran> veterans, Veteran currentVeteran) async {
//     Placemark _placemark;
//     await Future.forEach(veterans, (Veteran veteran) async {
//       if (veteran.geocode != null && veteran.geocode.latitude != 'null') {
//         Point _point = Point(
//             latitude: double.parse(veteran.geocode.latitude),
//             longitude: double.parse(veteran.geocode.longitude));
//         if (currentVeteran != null) {
//           if (veteran.id == currentVeteran.id) {
//             Uint8List bytes =
//                 (await NetworkAssetBundle(Uri.parse(currentVeteran.images[0]))
//                         .load(currentVeteran.images[0]))
//                     .buffer
//                     .asUint8List();
//             _placemark = Placemark(
//               point: _point,
//               scale: 0.1,
//               rawImageData: bytes,
//               onTap: (Point point) => _showDialog(veteran),
//             );
//           } else {
//             _placemark = Placemark(
//               point: _point,
//               opacity: 0.7,
//               scale: 0.4,
//               iconName: 'assets/images/placemark.png',
//               onTap: (Point point) => _showDialog(veteran),
//             );
//           }
//         } else {
//           _placemark = Placemark(
//             point: _point,
//             opacity: 0.7,
//             scale: 0.4,
//             iconName: 'assets/images/placemark.png',
//             onTap: (Point point) => _showDialog(veteran),
//           );
//         }
//         controller?.addPlacemark(_placemark);
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     _veteranArguments = ModalRoute.of(context).settings.arguments;
//     return BlocBuilder<MapBloc, MapState>(
//       builder: (context, state) {
//
//         if (state is Map) {
//           return AppFrame(
//             mainAppBar: MainAppBar(
//               title: Text(
//                 _appBarTitle,
//                 style: Theme.of(context).tabBarTheme.labelStyle,
//               ),
//             ),
//             body: yandexMap,
//           );
//         }
//
//         if(state is VeteransOnMap){
//           _addPlacemark(state.veterans, null);
//           controller?.move(
//               point: Point(
//                 latitude: state.latitude,
//                 longitude: state.longitude,
//               ),
//               zoom: 7,
//               animation: const MapAnimation(smooth: true, duration: 2.0));
//         }
//
//         if (state is MapWithVeterans) {
//           return  AppFrame(
//               mainAppBar: MainAppBar(
//                 title: Text(
//                   '${state.veteran.fio}',
//                   style: Theme.of(context).tabBarTheme.labelStyle,
//                 ),
//               ),
//               body: yandexMap,
//             );
//         }
//         if(state is VeteranOnMap){
//           _addPlacemark(state.veterans, state.veteran);
//           controller?.move(
//               point: Point(
//                 latitude: double.parse(state.veteran.geocode.latitude),
//                 longitude: double.parse(state.veteran.geocode.longitude),
//               ),
//               animation: const MapAnimation(smooth: true, duration: 2.0));
//         }
//         if (state is MapLoading) {
//           return AppFrame(
//               mainAppBar: MainAppBar(
//                 title: Text(
//                   _appBarTitle,
//                   style: Theme.of(context).tabBarTheme.labelStyle,
//                 ),
//               ),
//               body: Stack(
//                 children: [
//                   yandexMap,
//                   Center(
//                     child: CircularProgressIndicator(),
//                   )
//                 ],
//               ));
//         }
//
//         if (state is LocationPermissionError) {
//           _showMessage(
//             context,
//             Text('permition is not granted'),
//           );
//           return AppFrame(
//               mainAppBar: MainAppBar(
//                 title: Text(
//                   _appBarTitle,
//                   style: Theme.of(context).tabBarTheme.labelStyle,
//                 ),
//               ),
//               body: Stack(
//                 children: [
//                   yandexMap
//                 ],
//               ));
//         } else {
//           return AppFrame(
//               mainAppBar: MainAppBar(
//                 title: Text(
//                   _appBarTitle,
//                   style: Theme.of(context).tabBarTheme.labelStyle,
//                 ),
//               ),
//               body: yandexMap);
//         }
//       },
//     );
//   }
// }
