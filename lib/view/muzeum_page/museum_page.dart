import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veterans/data/firebase_providers/museums_provider.dart';
import 'package:veterans/data/repositories/museum_repository.dart';
import 'package:veterans/domain/museum/museum_bloc.dart';
import 'package:veterans/model/story.dart';
import 'package:veterans/view/app_frame.dart';
import 'package:veterans/view/error_page.dart';
import 'package:veterans/view/history_slider.dart';
import 'package:veterans/view/lib/css_text.dart';
import 'package:veterans/view/main_app_bar.dart';
import 'package:veterans/view/veteran_page/back_button.dart';
import '../nested_item.dart';
import '../photo_slider.dart';

class MuseumPage extends StatelessWidget {
  String id;
  List<Story> stories = [];
  MuseumRepository museumRepository = MuseumRepository(MuseumsProvider());

  MuseumPage({this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MuseumBloc>(
      create: (context) =>
          MuseumBloc(museumRepository: museumRepository, id: id)
            ..add(StartMuseumPage()),
      child: Container(
        child: BlocBuilder<MuseumBloc, MuseumState>(
          builder: (context, state) {
            if (state is MuseumSuccess) {
              return AppFrame(
                mainAppBar: MainAppBar(
                  backButton: BackButtonAppbar(context: context),
                  title: Text(
                    '${state.museum.name}',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                body: Container(
                  child: (state.museum.stories == null)
                      ? SingleChildScrollView(
                          child: ItemMuseum(
                            state: state,
                          ),
                        )
                      : CustomNestedView(
                          header: ItemMuseum(
                            state: state,
                          ),
                          body: HistorySlider(stories: state.museum.stories),
                        ),
                ),
              );
            }
            if (state is MuseumInitial) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return ErrorPage(
                titleMessage: 'Ошибка',
                bodyMessage: 'Страница с музеем отсутсвтует!',
              );
            }
          },
        ),
      ),
    );
  }
}

class ItemMuseum extends StatelessWidget {
  MuseumSuccess state;

  ItemMuseum({this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        runSpacing: 25,
        children: [
          PhotoSlider(images: state.museum.images),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'О музее',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                Container(
                    child: RichText(
                  text: HTML.toTextSpan(context, state.museum.fullDesc, null),
                )),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Wrap(
              runSpacing: 10,
              children: [
                Container(
                  child: Text(
                    'Контакты',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'E-mail: ',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Text('${state.museum.email}',
                          style: Theme.of(context).textTheme.bodyText2),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Телефон: ',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Text('${state.museum.phone}',
                          style: Theme.of(context).textTheme.bodyText2),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Адрес: ',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Expanded(
                        child: Text(state.museum.address.fullAddress()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
