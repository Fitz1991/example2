import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:veterans/view/selected_photo_indicator.dart';

import '../main.dart';

class PhotoSlider extends StatefulWidget {
  List<String> images;

  PhotoSlider({this.images});

  @override
  _PhotoSliderState createState() => _PhotoSliderState();
}

class _PhotoSliderState extends State<PhotoSlider> {
  int photoIndex = 0;
  Widget imageWidget;

  pageView() {
    List<Widget> decorationPhotos = [];
    for (int i = 0; i < widget.images.length; i++) {
      decorationPhotos.add(
          CachedNetworkImage(
            imageUrl: widget.images[i],
            imageBuilder: (context, imageProvider) => Container(
              height: 500,
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
          ));
    }
    return Stack(
      children: [
        PageView(
          children: decorationPhotos,
          onPageChanged: (value) => {
            setState(() {
              photoIndex = value;
            })
          },
        ),
        Positioned(
          top: 10,
          left: 10,
          right: 10,
          child: SelectedPhotoIndicator(
            numberOfLines: widget.images.length,
            photoIndex: photoIndex,
            colorActivePhoto: Colors.white,
            colorInActivePhoto: MyApp.SliderInactiveStepColor,
          ),
        ),
        Positioned(
            bottom: 15,
            left: 15,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                color: Theme.of(context).colorScheme.secondary,
                width: 55,
                height: 30,
                alignment: Alignment.center,
                child: Text(
                  '${photoIndex + 1}/${widget.images.length}',
                  style: Theme.of(context).textTheme.overline,
                ),
              ),
            ))
      ],
    );
  }

  singlePhoto() {
    return
      CachedNetworkImage(
        imageUrl: widget.images[0],
        imageBuilder: (context, imageProvider) => Container(
          height: 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
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
      );
  }

  @override
  Widget build(BuildContext context) {
    imageWidget = (widget.images.length == 1) ? singlePhoto() : pageView();
    return Container(
      child: Column(
        children: [
          Center(
              child: Container(
            height: 500,
            child: imageWidget,
          )),
        ],
      ),
    );
  }
}
