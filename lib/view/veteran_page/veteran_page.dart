import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veterans/data/firebase_providers/veterans_firestore_provider.dart';
import 'package:veterans/data/repositories/veterans/firestore_veterans_repository.dart';
import 'package:veterans/data/repositories/veterans/veterans_repository.dart';
import 'package:veterans/domain/veteran/veteran_bloc.dart';
import 'package:veterans/model/veterans/veteran.dart';
import 'package:veterans/view/app_frame.dart';
import 'package:veterans/view/error_page.dart';
import 'package:veterans/view/main_app_bar.dart';
import 'package:veterans/view/nested_item.dart';
import 'package:veterans/view/photo_slider.dart';
import 'package:veterans/view/veteran_page/veteran_info.dart';
import 'package:veterans/view/veteran_page/veteran_preview_pdf.dart';
import 'package:veterans/view/veteran_page/youtube_dropdown.dart';
import '../history_slider.dart';
import 'back_button_preview_veteran_pdf.dart';

class VeteranPage extends StatelessWidget {
  String _id;
  VeteranRepository _veteransRepository =
      FirestoreVeteransRepository(VeteransProvider());

  VeteranPage({@required id}) : _id = id;
  Veteran _veteran;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VeteranBloc>(
      create: (context) =>
          VeteranBloc(firestoreRepository: _veteransRepository, documentId: _id)
            ..add(StartVeteranPage()),
      child: Container(
        child:
            BlocBuilder<VeteranBloc, VeteranState>(builder: (context, state) {
          if (state is VeteranSuccess) {
            _veteran = state.veteran;
            return AppFrame(
                mainAppBar: MainAppBar(
                title: Text(
                  state.veteran.fio,
                  style: Theme.of(context).tabBarTheme.labelStyle,
                ),
                actions: [
                  IconButton(
                    padding: EdgeInsets.only(right: 10),
                    iconSize: 30,
                    icon: Icon(
                      Icons.share,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () {
                      BlocProvider.of<VeteranBloc>(context).add(
                          VeteranLoadPdfPreview(
                              context: context, veteran: state.veteran));
                    },
                  )
                ],
              ),
              body: Container(
                  child: (state.veteran.story == null)
                      ? SingleChildScrollView(
                    child: ItemVeteran(state: state),
                  )
                      : CustomNestedView(
                    header: ItemVeteran(state: state),
                    body: HistorySlider(stories: state.veteran.story),
                  )),
              );
          }
          if (state is VeteranPdfPreview) {
            return VeteranPreviewPdf(
              veteranPdfFile: state.pdfFile,
              veteran: state.veteran,
            );
          }
          if (state is VeteranInitial) {
            return
              AppFrame(
                mainAppBar: MainAppBar(
                  title: Text(
                    'Загрузка...',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                body: progress(),
              );
          }
          if (state is VeteranPdfLoadProgress) {
            return
              AppFrame(
                mainAppBar: MainAppBar(
                  backButton: BackButtonPreviewVeteranPdf(
                      veteran: _veteran, context: context),
                  title: Text(
                    'Создается pdf файл...',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                body: progress(),
              );
          }
          if(state is VeteranFailure){
            return ErrorPage(titleMessage: state.titleMessage, bodyMessage: state.bodyMessage,);
          }
          else {
            return ErrorPage(titleMessage: 'Ошибка', bodyMessage: 'Что-то пошло не так, попробуйте позже!',);
          }
        }),
      ),
    );
  }

  Widget progress() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ItemVeteran extends StatelessWidget {
  VeteranSuccess state;

  ItemVeteran({this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: Center(
                child: PhotoSlider(
              images: state.veteran.images,
            )),
            padding: EdgeInsets.only(bottom: 25),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Wrap(
              runSpacing: 25,
              children: [
                (state.veteran.youtubeLinks == null)
                    ? SizedBox.shrink()
                    : YoutubeDropDown(youtubeLinks: state.veteran.youtubeLinks),
                VeteranInfo(veteran: state.veteran),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
