import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:veterans/model/veterans/youtube_link.dart';

class YoutubeDropDown extends StatefulWidget {
  List<YoutubeLink> youtubeLinks;

  YoutubeDropDown({this.youtubeLinks, Key key}) : super(key: key);

  @override
  _YoutubeDropDownState createState() => _YoutubeDropDownState();
}

class _YoutubeDropDownState extends State<YoutubeDropDown> {
  String dropdownValue;

  getVideoLinks(List<YoutubeLink> textLinks) {
    return textLinks.map<DropdownMenuItem<String>>((item) => DropdownMenuItem(
      value: item.link,
      child: Text(item.title),
    ))
        .toList();
  }
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButton<String>(
//      value: dropdownValue,
          isExpanded: true,
          hint: Text('Видео'),
          icon: RotatedBox(
            quarterTurns: 3,
            child: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).primaryColor,
            ),
          ),
          iconSize: 15,
          style: Theme.of(context).textTheme.subtitle2,
          underline: Container(
            height: 1,
            color: Theme.of(context).dividerColor,
          ),
          onChanged: (String newValue) {
            setState(() {
              _launchURL(newValue);
            });
          },
          items: getVideoLinks(widget.youtubeLinks)),
    );
  }
}