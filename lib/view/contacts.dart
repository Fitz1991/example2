import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:veterans/view/app_frame.dart';
import 'package:veterans/view/config.dart';
import 'package:veterans/view/main_app_bar.dart';

import '../main.dart';
import 'bottom_navigation.dart';

class ContactsPage extends StatelessWidget {

  double widthContactWidget = 65.0;
  double heightContactWidget = 65.0;

  BuildContext _context;
  final scrollController = ScrollController(initialScrollOffset: 0);
  @override
  Widget build(BuildContext context) {
    _context = context;
    return
      AppFrame(
        mainAppBar: MainAppBar(
          title: Text(
            'Контакты',
            style: Theme
                .of(context)
                .textTheme
                .headline1,
          ),
          actions: [
            IconButton(
              tooltip: 'Расскажите о ветеране',
              padding: EdgeInsets.only(right: 10),
              iconSize: 30,
              icon: Icon(
                IconData(MyApp.codePoint, fontFamily: 'megaphone'),
                color: Theme
                    .of(context)
                    .colorScheme
                    .secondary,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/story_veteran');
              },
            )
          ],
        ),
        body: SingleChildScrollView(
            controller: scrollController,
            child:
            Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  CachedNetworkImage(
                    imageUrl: 'https://firebasestorage.googleapis.com/v0/b/memory-verans.appspot.com/o/photo_2021-02-22%2018.59.43.jpeg?alt=media&token=dfba2ddb-233e-41f4-8433-146fec02cdd5',
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
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Wrap(
                      runSpacing: 40,
                      children: [
                        Wrap(
                          runSpacing: 5,
                          children: [
                            Text(
                              'Дворец детского (юношеского) творчества г.Чебоксары',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headline1,
                            ),
                            Divider(
                              height: 1,
                              color: Theme
                                  .of(context)
                                  .dividerColor,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Icon(
                                    IconData(
                                        MyApp.codePoint, fontFamily: 'geolocation'),
                                    color: Theme
                                        .of(context)
                                        .colorScheme
                                        .secondary,
                                  ),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Expanded(
                                  flex: 10,
                                  child: Text(
                                    Config.address,
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .subtitle2,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              child: contactWidget(icon: 'phone'),
                              onTap: () {
                                Uri phone = Uri(scheme: 'tel', path: Config.phone);
                                _launchURL(phone);
                              },
                              borderRadius: BorderRadius.circular(25),
                            ),
                            InkWell(
                              child: contactWidget(icon: 'mail'),
                              onTap: () {
                                Uri email = Uri(scheme: 'mailto', path: Config.email);
                                _launchURL(email);
                              },
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                                child: socialWidget(assetPath: 'assets/images/vk.svg'),
                                onTap: () {
                                  Uri vk = Uri(scheme: 'https', path: Config.vkLink);
                                  _launchURL(vk);
                                },
                                borderRadius: BorderRadius.circular(25)
                            ),
                            InkWell(
                                child: socialWidget(assetPath: 'assets/images/instagram-sketched.svg'),
                                onTap: () {
                                  Uri instagram = Uri(scheme: 'https', path: Config.instagramLink);
                                  _launchURL(instagram);
                                },
                                borderRadius: BorderRadius.circular(25)
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )

        ),
        bottomNavigation: BottomNavigation(selectedIndex: 2),
      );
  }

  Widget contactWidget({@required String icon,@required String label}) {
    return Container(
      width: widthContactWidget,
      height: heightContactWidget,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
              color: Theme
                  .of(_context)
                  .primaryColor,
              width: 1)),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(IconData(MyApp.codePoint, fontFamily: '$icon'), color: Theme
              .of(_context)
              .colorScheme
              .secondary,),
          (label != null) ? SizedBox(height: 15,) : SizedBox.shrink(),
          (label != null) ? Text(label, style: Theme.of(_context).textTheme
              .headline5,) : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget socialWidget({@required String assetPath}){
    return Container(
      width: widthContactWidget,
      height: heightContactWidget,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
              color: Theme
                  .of(_context)
                  .primaryColor,
              width: 1)),

        child :
        SvgPicture.asset(assetPath, width: 40,),
    );
  }


  _launchURL(Uri uri) async {
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch $uri';
    }
  }

}
