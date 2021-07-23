import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:veterans/model/story.dart';

import 'lib/css_text.dart';
import 'selected_photo_indicator.dart';

class HistorySlider extends StatefulWidget {
  List<Story> stories;

  HistorySlider({this.stories});

  @override
  _HistorySliderState createState() => _HistorySliderState();
}

class _HistorySliderState extends State<HistorySlider> {
  int photoIndex = 0;
  double heightChildContent;
  List<Color> listColor;
  final ScrollController _scrollController = ScrollController();

  getTitle(Story story) {
    if (story.title == null || story.title.isEmpty) return SizedBox.shrink();
    return Expanded(
      flex: 2,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '${story.title}',
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.headline3,
          maxLines: 1,
        ),
      ),
    );
  }

  getDesc(Story story) {
    if (story.description == null || story.description.isEmpty)
      return SizedBox.shrink();
    int flex = (story.photo.isEmpty || story.photo == null) ? 16 : 7;
    return Expanded(
      flex: flex,
      child: Scrollbar(
        controller: _scrollController,
//            isAlwaysShown: true,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: RichText(
            text: HTML.toTextSpan(
                context, story.description, HexColor("#ebeeec")),
          ),
        ),
      ),
    );
  }

  getPhotoStory(Story story) {
    if (story.photo == null || story.photo.isEmpty)
      return SizedBox.shrink();
    else {
      return Expanded(
        flex: 9,
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
          ),
          child: CachedNetworkImage(
            imageUrl: story.photo,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                      image: AssetImage(
                          'assets/images/memory_in_each_street.png'))),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      );
    }
  }

  itemsForHistory(int i){
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      getPhotoStory(widget.stories[i]),
      SizedBox(
        height: 10,
      ),
      getTitle(widget.stories[i]),
      SizedBox(
        height: 10,
      ),
      getDesc(widget.stories[i]),
    ]);
  }

  decorationItem(){
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment(1, 4),
            colors: listColor,
          )),
      padding: EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10),
      child:itemsForHistory(0),
    );
  }

  decorationItemSlider() {
    List<Widget> decorationPhotos = [];
    for (int i = 0; i < widget.stories.length; i++) {
        if(!widget.stories[i].isEmpty()){
          decorationPhotos.add(
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(1, 4),
                    colors: listColor,
                  )),
              padding: EdgeInsets.only(top: 50, bottom: 10, right: 10, left: 10),
              child: itemsForHistory(i)
            ),
          );
        }
    }
    return decorationPhotos;
  }

  pageView() {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          child: PageView(
            children: decorationItemSlider(),
            onPageChanged: (value) => {
              setState(() {
                photoIndex = value;
              })
            },
          ),
        ),
        Positioned(
          top: 25,
          left: 10,
          right: 10,
          child: SelectedPhotoIndicator(
            numberOfLines: widget.stories.length,
            photoIndex: photoIndex,
            colorActivePhoto: Theme.of(context).colorScheme.secondary,
            colorInActivePhoto: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    listColor = [Theme.of(context).primaryColor, Colors.white];
    Widget history;
    if (widget.stories == null)
      return SizedBox.shrink();
    else if (widget.stories.length == 1)
      history = decorationItem();
    else {
      history = pageView();
    }
    return Container(
      child: history,
    );
  }
}
