import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:veterans/model/veterans/veteran.dart';

import '../../main.dart';

class VeteransListWidget extends StatelessWidget {
  String scrollKey;

  VeteransListWidget(this.veterans, this._setScrollController, this.scrollKey,
      {Key key})
      : super(key: key) {
    _scrollController = ScrollController();
    _setScrollController(_scrollController);
  }

  ScrollController _scrollController;
  List<Veteran> veterans;
  Function _setScrollController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MyApp.HorizontalPagePadding),
      child: ListView.separated(
        controller: _scrollController,
        key: PageStorageKey<String>(scrollKey),
        shrinkWrap: true,
        itemCount: veterans.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: MyApp.CardPadding),
            child: InkWell(
              child: ItemVeteran(
                veteran: veterans[index],
              ),
              onTap: () {
                Navigator.pushNamed(context, 'veteran/${veterans[index].id}');
              },
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: 1,
            thickness: 0.5,
          );
        },
      ),
    );
  }
}

class ItemVeteran extends StatelessWidget {
  Veteran veteran;

  ItemVeteran({this.veteran});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Row(
          children: [
            CachedNetworkImage(
              imageUrl: veteran.images[0],
              imageBuilder: (context, imageProvider) => Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage('assets/images/memory_in_each_street.png'))),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 10,
              child: Wrap(
                children: [
                  //title
                  Padding(
                    child: Text(
                        '${veteran.surname} ${veteran.firstName} ${veteran.secondName}',
                        style: Theme.of(context).textTheme.headline1),
                    padding: EdgeInsets.only(bottom: MyApp.CardItemPadding),
                  ),
                  //subtitle
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: MyApp.CardItemPadding),
                        child: Icon(IconData(MyApp.codePoint, fontFamily: 'strap'),
                            color: MyApp.SecondaryColor, size: 20),
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
            ),
            Expanded(
                flex: 1,
                child: Icon(
                  Icons.keyboard_arrow_right,
                  color: Theme.of(context).primaryColor,
                ))
          ],
        ),
        SizedBox(
          height: 16,
        ),
      ],
    ));
  }
}
