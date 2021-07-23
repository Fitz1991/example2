import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'bottom_navigation.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  String server;

  List<String> info;

  @override
  void initState() {
    server = (Platform.isIOS) ? 'AppStore' : 'GooglePlay';
    info = [
      'Проект направлен не просто на патриотическое воспитание школьников и их родителей, а в первую очередь на решение важнейшей проблемы - замены настоящих героев псевдогероями из комиксов в массовом сознании подрастающего поколения, и как следствие переписывание истории страны.',
      'Проект предполагает использование современных технологий в патриотическом воспитании детей и их родителей. В рамках проекта в 10 школах города Чебоксары, где учится около 5000 школьников и которые посещают около 2000 родителей (курсы подготовки к школе, встреча первоклассников после уроков, родительские собрания), будут установлены «Стенды героев» нашего двора – стенды с закрепленными объемными звездами, рядом с которыми будет фамилия, имя и отчество ветерана, проживающего (проживавшего) на закрепленной за школой территорией, и QR-код, перейдя по которому школьники и их родители попадут в мобильное приложение с подробной информацией об этом ветеране и картой с указанием дома, где живет (или жил) ветеран.',
      'Проект является важным шагом на пути предотвращения переписывания истории '
          'страны, будет создана платформа для развития нового направления в патриотическом воспитании взрослого и подрастающего поколения на основе синтеза современных технологий, мероприятий патриотической направленности и семейных ценностей. Вовлечение в проект родителей школьников позволит создать еще одно важное направление в патриотическом воспитании молодежи – участие всей семьи в поиске информации о своих родственниках – героях Великой Отечественной войны.',
      'При реализации проекта используются средства государственной поддержки, выделенные в качестве гранта в соответствии с Указом Президента Российской Федерации от 30 января 2019 года № 30 «О грантах Президента Российской Федерации, предоставляемых на развитие гражданского общества» и на основании конкурса, проведенного Фондом президентских грантов.',
      '''
      В соответствии с Законом РФ «О персональных данных» все персональные данные сайта moypolk.ru хранятся на сервере $server. 
      Услуги предоставляются на основании соответствующих договоров. 
      Оплата провайдера производится за счет собственных средств ЧРООФГО "СОВЕТ ОТЦОВ ЧУВАШИИ".
      '''
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                  delegate: MySliverAppBar(expandedHeight: 200),
                  pinned: true,
                ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Text(
                      'Память в каждом дворе',
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ]),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(
                    height: 10,
                  )
                ]),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (_, index) => ListTile(
                              title: Text(
                                info[index],
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                        childCount: info.length)),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(
                    height: 10,
                  )
                ]),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  CachedNetworkImage(
                    imageUrl: 'https://firebasestorage.googleapis.com/v0/b/memory-verans.appspot.com/o/pgrants_logo_gp.png?alt=media&token=c8be3eaf-b0f1-4b54-a377-334624de2607',
                    imageBuilder: (context, imageProvider) => Container(
                      height: 250,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.contain,
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
                ]),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(selectedIndex: 1),
    );
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  MySliverAppBar({@required this.expandedHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            height: expandedHeight,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
          ),
          Opacity(
              opacity: (1 - shrinkOffset / expandedHeight),
              child: Image.asset('assets/images/memory_in_each_street.png')),
          Positioned(
            left: -3,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1, color: Theme.of(context).colorScheme.primary),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: GestureDetector(
                  child: IconButton(
                      iconSize: 15,
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Theme.of(context).primaryColor,
                      )),
                  onTap: () {
                    Navigator.popAndPushNamed(context, '/');
                  }),
            ),
          ),
          Positioned.fill(
              child: Align(
            alignment: Alignment.center,
            child: Opacity(
              opacity: (shrinkOffset / expandedHeight),
              child: Text(
                'О нас',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
          ))
        ],
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
