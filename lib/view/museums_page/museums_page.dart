import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veterans/data/firebase_providers/museums_provider.dart';
import 'package:veterans/data/repositories/museum_repository.dart';
import 'package:veterans/domain/museums/museums_bloc.dart';
import 'package:veterans/domain/search/museums/search_museums_bloc.dart';
import 'package:veterans/domain/veterans/veterans_bloc.dart';
import 'package:veterans/view/museums_page/search_museums_bloc_builder.dart';

import '../../main.dart';

class MuseumsPage extends StatelessWidget {
  final MuseumRepository _museumRepository =
      MuseumRepository(MuseumsProvider());

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MuseumsBloc>(
          create: (BuildContext context) =>
              MuseumsBloc(museumRepository: _museumRepository)
                ..add(StartMuseumsPage()),
        ),
        BlocProvider<SearchMuseumsBloc>(
          create: (context) =>
              SearchMuseumsBloc(museumRepository: _museumRepository),
        ),
      ],
      child: Container(
        child: Column(children: [
          SearchMuseumsBlocBuilder(),
          MuseumsList()
        ]),
      ),
    );
  }
}

class MuseumsList extends StatelessWidget {
  MuseumsList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MuseumsBloc, MuseumsState>(builder: (context, state) {
      if (state is MuseumsInitial) {
        return Expanded(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      if (state is MuseumsLoadedState) {
        return Expanded(
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: state.museums.length,
              itemBuilder: (context, index) {
                return InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                          context, 'museum/${state.museums[index].id}');
                    },
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            imageUrl: state.museums[index].images[0],
                            imageBuilder: (context, imageProvider) => Container(
                              height: 250,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) =>
                                Container(
                                  height: 250,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage('assets/images/memory_in_each_street.png')
                                      )
                                  ),
                                ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Wrap(
                              runSpacing: 5,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    '${state.museums[index].name}',
                                    style:
                                        Theme.of(context).textTheme.headline1,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Divider(
                                    height: 1,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                ),
                                Stack(
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Wrap(
                                              runSpacing: 10,
                                              children: [
                                                Text(
                                                  '${state.museums[index].introDesc}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Icon(
                                                        IconData(
                                                            MyApp.codePoint,
                                                            fontFamily:
                                                                'geolocation'),
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 6,
                                                    ),
                                                    Expanded(
                                                      flex: 5,
                                                      child: Text(
                                                        state.museums[index]
                                                            .address
                                                            .fullAddress(),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .subtitle2,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox.shrink(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned.fill(
                                      right: -2,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              top: 8,
                                              bottom: 8,
                                              left: 8,
                                              right: 5),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(25),
                                                  bottomLeft:
                                                      Radius.circular(25))),
                                          child: Text(
                                            'Подробнее',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ));
              }),
        );
      }
      if (state is VeteransEmptyState) {
        return Text('');
      } else {
        return Text('');
      }
    });
  }
}
