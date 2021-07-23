import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:veterans/model/story.dart';

import 'app_frame.dart';
import 'bottom_navigation.dart';
import 'history_slider.dart';
import 'main_app_bar.dart';
import 'nested_item.dart';

class TowerPage extends StatelessWidget {
  final scrollController = ScrollController(initialScrollOffset: 0);
  List<String> historicalReference = [
    'Сурский рубеж – это оборонительное сооружение около реки Сура, на территории Чувашской и Мордовской АССР. Его задачей являлась задержка гитлеровских войск на подступах к Казани наравне с Казанским оборонительным рубежом.',
    "По территории Чувашии Сурский рубеж проходил вдоль Суры по линии с. Засурское Ядринского района — д. Пандиково Красночетайского — с. Сурский Майдан Алатырского районов — Алатырь до границы с Ульяновской областью. В строительстве сооружения приняли участие десятки тысяч жителей Республики, благодаря чему «Сурский рубеж» был построен за 45 дней.",
    'Предпосылки строительства: В октябре 1941 года в ГКО был обсужден и принят предварительный план строительства оборонительных в глубоком тылу на Оке, Дону, Волге из-за продвижения вермахта к Москве. Укрепления Горького, Казани, Куйбышева, Ульяновска, Саратова, Сталинграда и других городов предназначались для задержки противника на новых рубежах в случае неудачного для советских войск развития операций. ',
    'Строительство «Сурского рубежа» началось в 1941 году, когда немцы уже стояли под Москвой. Требовались незамедлительные действия, и уже 16 октября было принято решение: «Мобилизовать с 28 октября 1941 года для проведения работ по строительству на территории Чувашской АССР Сурского и Казанского оборонительных рубежей. Мобилизации подлежит население республики не моложе 17 лет, физически здоровых».',
    'Ход строительства: Жители Чувашии объединялись в рабочие бригады по 50 человек, а за каждым районном закреплялись прорабские участки, начальниками которых были назначены первые секретари Чувашского Республиканского комитета ВКП(б) и председатели исполкомов райсоветов депутатов трудящихся. Им поручалось «обеспечить нормальную работу мобилизованных своего района»: разместить в окружающих селениях, бараках, построить землянки. Колхозы должны были организовать поставку продуктов и фуража, врачебные участки — необходимыми медикаментами. ',
    'Завершение строительства: 21 января 1942 г. на имя наркома внутренних дел Л. П. Берия была послана телеграмма: «Задание ГКО по строительству Сурского оборонительного рубежа выполнено. Объем вынутой земли — 3 млн. кубических метров, отстроено 1600 огневых точек (дзотов и площадок), 1500 землянок и 80 км окопов с ходами сообщений».'
  ];

  List<String> memoryCurrently = [
    '•  22 июня 2002 года был установлен памятный знак «Строителям Сурского рубежа», недалеко от поселка Ясная Поляна в 100 метрах от моста через Суру.',
    '•	4 мая 2010 года, на границе Октябрьского и Карабашского сельских поселений Мариинско-Посадского района Чувашии состоялось торжественное открытие обелиска в честь Казанско-Сурского оборонительного рубежа.',
    '•	В октябре 2014 года заявили о начале строительства в Большеберезниковском районе Мордовии военно-исторического комплекса «Сурский рубеж».',
    '•	6 мая 2015 года в Ядринском районе Чувашии состоялась презентация нового туристского маршрута «Сурский оборонительный рубеж»: село Засурье — поселок Совхозный — деревня Стрелецкая — город Ядрин — село Ильина Гора. Экскурсионный маршрут знакомит туристов с местом прохождения Засурской линии обороны, сохранившегося со времен Великой Отечественной войны, осени 1941 года.',
    '•	9 мая 2015 года в селе Порецкое открыт памятный знак-обелиск строителям Сурского рубежа обороны (автор эскизного проекта — заслуженный художник Чувашии А. В. Ильин).',
    '•	В настоящее время участок Сурского рубежа восстановлен в Шумерле и фактически действует как музей под открытым небом. В 2019 году впервые в Чувашии прошла военно-историческая реконструкция строительства Сурского рубежа. Также восстанавливается участок линии обороны в Алатыре.'
  ];

  Map<String, String> keyDates = {
    '28 октября 1941 г. - 21 января 1942 г.': 'Годы постройки',
    'Октябрь 1941': 'Начало строительства Сурского оборонительного рубежа.',
    '22 октября 1941 года':
        'Бюро Пензенского городского комитета обороны во исполнение Постановления Государственного Комитета Обороны СССР приняло решение о мерах для постройки на территории региона оборонительного рубежа. На эти цели было мобилизовано более 100 тыс. человек. Строители должны были возвести укрепления по р. Суре, через пос. Лунино, с. Бессоновку, г. Пензу, д. Лемзяйку и с. Ключи. Параллельно с этим строилась ещё одна линия обороны: пос. Лунино — пос. Мокшан — с. Загоскино — Спасско-Александровка. Планировалось соорудить около 360 километров рвов, эскарпов, 1 100 огневых артиллерийских точек, построить около 9 тыс. землянок для бойцов, около 340 ДОТов и ДЗОТов. Для этого потребовалось более 300 тыс. кубометров леса; 1,5 миллиона штук кирпича; десятки вагонов стекла, кровельного железа и гвоздей.',
    '1 ноября 1941 - 17 января 1942 года':
        '«Сурский рубеж» в Пензенской области сооружался с 1 ноября 1941 по 17 января 1942 года.',
    '28 октября 1941 года':
        'Совет Народных Комиссаров Чувашской АССР и бюро Чувашского обкома ВКП(б) принимают решение: «Мобилизовать с 28 октября 1941 года для проведения работ по строительству на территории Чувашской АССР Сурского и Казанского оборонительных рубежей. Мобилизации подлежит население республики не моложе 17 лет, физически здоровых».',
    '28 октября 1941 года - 25 января 1942 года':
        'Рубежи обороны строились в Чувашии с 28 октября 1941 года по 25 января 1942 года и в случае взятия Москвы должны были задержать гитлеровские войска на подступах к Казани. Это была масштабная по объёму (протяжённость 380 км) и ударная по срокам (три месяца с момента мобилизации) всенародная стройка (задействована треть оставшегося в тылу трудоспособного населения). Это была своя война на линии оборонительного фронта для 110 тысяч человек, ежедневно заступавших на рубеж, для кого-то становящийся последним рубежом жизни. Всего на работу было направлено 171 450 человек. Среди них – женщины и подростки. Они рыли окопы, строили блиндажи и укрепления. С ноября 1941 по январь 1942 в морозы до - 40 градусов они вручную вынули около 5 миллионов кубометров грунта. После окончания строительных работ республика поддерживала рубежи обороны в полной боевой готовности до конца 1943 года.',
    '17 января 1942 года':
        'Объявлено о прекращении работ на Пензенском участке Сурского рубежа обороны. По мнению пензенского краеведа В. А. Мочалова, точной датой окончания строительства можно считать 22 января 1942 года. В этот день командование 51-го ПС (Управления полевого строительства) обратилось с письмом к руководству Пензы, в котором проинформировало, что рубеж «закончен в срок и на отлично»',
    '21 января 1942 года':
        'На имя наркома внутренних дел Л. П. Берия была послана телеграмма, подписанная начальником 12 Армейского управления Леонюком, председателем Совнаркома Сомовым, секретарем обкома Чарыковым: «Задание ГКО по строительству Сурского оборонительного рубежа выполнено. Объём вынутой земли — 3 млн кубических метров, отстроено 1600 огневых точек (дзотов и площадок), 1500 землянок и 80 км окопов с ходами сообщений».',
  };

  List<Story> stories = [
    Story(
        title: '',
        description: 'На строительстве Сурского оборонительного рубежа, 1941',
        photo:
            'https://firebasestorage.googleapis.com/v0/b/memory-verans.appspot.com/o/%D1%81%D1%83%D1%80%D1%81%D0%BA%D0%B8%D0%B9%20%D1%80%D1%83%D0%B1%D0%B5%D0%B6%2F%D0%A1%D1%83%D1%80%D1%81%D0%BA%D0%B8%D0%B9%20%D1%80%D1%83%D0%B1%D0%B5%D0%B61.jpg?alt=media&token=70a185b6-5d0e-41df-8791-afb083111426'),
    Story(
        title: '',
        description:
            'Сейчас от «Сурского рубежа» остался только едва заметный овраг.',
        photo:
            'https://firebasestorage.googleapis.com/v0/b/memory-verans.appspot.com/o/%D1%81%D1%83%D1%80%D1%81%D0%BA%D0%B8%D0%B9%20%D1%80%D1%83%D0%B1%D0%B5%D0%B6%2F%D0%A1%D1%83%D1%80%D1%81%D0%BA%D0%B8%D0%B9%20%D1%80%D1%83%D0%B1%D0%B5%D0%B62.jpg?alt=media&token=ca7b6d0a-d284-4f9c-b992-050db85694d7'),
    Story(
      title: '',
      description: '',
      photo:
          'https://firebasestorage.googleapis.com/v0/b/memory-verans.appspot.com/o/%D1%81%D1%83%D1%80%D1%81%D0%BA%D0%B8%D0%B9%20%D1%80%D1%83%D0%B1%D0%B5%D0%B6%2F%D0%A1%D1%83%D1%80%D1%81%D0%BA%D0%B8%D0%B9%20%D1%80%D1%83%D0%B1%D0%B5%D0%B63.jpg?alt=media&token=fdb12c61-b46e-4381-8108-324d8cd563d0',
    ),
    Story(
        description: '',
        title: '',
        photo:
            'https://firebasestorage.googleapis.com/v0/b/memory-verans.appspot.com/o/%D1%81%D1%83%D1%80%D1%81%D0%BA%D0%B8%D0%B9%20%D1%80%D1%83%D0%B1%D0%B5%D0%B6%2F%D0%A1%D1%83%D1%80%D1%81%D0%BA%D0%B8%D0%B9%20%D1%80%D1%83%D0%B1%D0%B5%D0%B64.jpg?alt=media&token=d75ef6b6-420b-4cc1-a8da-c21428e0aa4b'),
    Story(
        title: '',
        description: '',
        photo:
            'https://firebasestorage.googleapis.com/v0/b/memory-verans.appspot.com/o/%D1%81%D1%83%D1%80%D1%81%D0%BA%D0%B8%D0%B9%20%D1%80%D1%83%D0%B1%D0%B5%D0%B6%2F%D0%A1%D1%83%D1%80%D1%81%D0%BA%D0%B8%D0%B9%20%D1%80%D1%83%D0%B1%D0%B5%D0%B65.jpg?alt=media&token=eb19dc94-46e9-4f90-8fd3-1d6a86c4dbc8'),
    Story(
        description: '',
        title: '',
        photo:
            'https://firebasestorage.googleapis.com/v0/b/memory-verans.appspot.com/o/%D1%81%D1%83%D1%80%D1%81%D0%BA%D0%B8%D0%B9%20%D1%80%D1%83%D0%B1%D0%B5%D0%B6%2F%D0%A1%D1%83%D1%80%D1%81%D0%BA%D0%B8%D0%B9%20%D1%80%D1%83%D0%B1%D0%B5%D0%B66.jpg?alt=media&token=215dd0a5-38b8-4221-ac9f-3d8c770a61d9'),
    Story(
        title: '',
        description: '',
        photo:
            'https://firebasestorage.googleapis.com/v0/b/memory-verans.appspot.com/o/%D1%81%D1%83%D1%80%D1%81%D0%BA%D0%B8%D0%B9%20%D1%80%D1%83%D0%B1%D0%B5%D0%B6%2F%D0%A1%D1%83%D1%80%D1%81%D0%BA%D0%B8%D0%B9%20%D1%80%D1%83%D0%B1%D0%B5%D0%B67.jpg?alt=media&token=7ba0a369-35a2-418a-b235-cb7684f28b29'),
    Story(
        description: '',
        title: '',
        photo:
            'https://firebasestorage.googleapis.com/v0/b/memory-verans.appspot.com/o/%D1%81%D1%83%D1%80%D1%81%D0%BA%D0%B8%D0%B9%20%D1%80%D1%83%D0%B1%D0%B5%D0%B6%2F%D0%A1%D1%83%D1%80%D1%81%D0%BA%D0%B8%D0%B9%20%D1%80%D1%83%D0%B1%D0%B5%D0%B68.jpg?alt=media&token=75e6f4cc-5ade-4f13-b89e-480de9600fdc'),
    Story(
        title: '',
        description: '',
        photo:
            'https://firebasestorage.googleapis.com/v0/b/memory-verans.appspot.com/o/%D1%81%D1%83%D1%80%D1%81%D0%BA%D0%B8%D0%B9%20%D1%80%D1%83%D0%B1%D0%B5%D0%B6%2F%D0%A1%D1%83%D1%80%D1%81%D0%BA%D0%B8%D0%B9%20%D1%80%D1%83%D0%B1%D0%B5%D0%B69.jpg?alt=media&token=2f5f4cad-7343-432e-8a26-fdd5208e3874'),
  ];

  @override
  Widget build(BuildContext context) {
    return
      AppFrame(
        mainAppBar: MainAppBar(
          title: Text(
            'Сурский рубеж',
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        body: Container(
          child: CustomNestedView(
            header: itemTower(context),
            body: HistorySlider(stories: stories),
          ),
        ),
        bottomNavigation: BottomNavigation(selectedIndex: 3),
      );
  }

  Widget itemTower(BuildContext context) {
    return Container(
      child: Wrap(
        runSpacing: 25,
        children: [
          Flex(
            direction: Axis.vertical,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl:
                    'https://regnum.ru/uploads/pictures/news/2020/08/17/regnum_picture_15976559461530696_normal.png',
                imageBuilder: (context, imageProvider) => Container(
                  height: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => Container(
                  height: 250,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/images/memory_in_each_street.png'))),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              )
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Wrap(
              runSpacing: 10,
              children: [
                Text(
                  'Историческая справка',
                  style: Theme.of(context).textTheme.headline2,
                ),
                ...historicalReference.map((item) {
                  return ListTile(
                    title: Text(
                      item,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  );
                }).toList(),
                Text(
                  'Память в настоящее время',
                  style: Theme.of(context).textTheme.headline2,
                ),
                ...memoryCurrently.map((memory) {
                  return ListTile(
                    title: Text(
                      memory,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  );
                }).toList(),
                Text(
                  'Ключевые даты',
                  style: Theme.of(context).textTheme.headline2,
                ),
                ...keyDates.entries.map((e) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          child: Text(
                            e.key,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          padding: EdgeInsets.only(right: 10),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          e.value,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                    ],
                  );
                }).toList(),
                Text(
                  'География',
                  style: Theme.of(context).textTheme.headline2,
                ),
                ListTile(
                  title: Text(
                    'Сурский рубеж обороны — рубеж обороны, сооруженный по правобережью рек Сура, Уза, Няньга, Чардым на территории Марийской, Чувашской, Мордовской АССР, Горьковской, Пензенской, Саратовской областей и Ульяновской областей, предназначавшийся для задержания гитлеровских войск на подступах к Казани, Куйбышеву, Ульяновску и др..',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                ListTile(
                  title: Text(
                    'По территории Чувашской АССР Сурский рубеж проходил от села Засурское Ядринского района мимо деревни Пандиково Красночестайского района, села Сурский Майдан Алатырского районадо границы Чувашской АССР. Оборонительный рубеж «Казанский обвод» по территории Чувашии проходил от Звениговского Затона через село Октябрьское, деревни Шоркистры и Арабоси Урмарского района до границы Татарской АССР, у сел Янтиково и Можарки Янтиковского района. По территории Марийской АССР Сурский рубеж проходил в Горномарийском районе. Протяженность сооружений — 45 километров. По территории Пензенской области Сурский рубеж проходил с севера на юг по восточным берегам рек Суры, Узы, Няньги, Чардыма до границы с Саратовской областью в районе Петровска. В строительстве сооружения приняли участие более 100 тыс. жителей Пензенской области во главе с военнослужащими 6-й сапёрной армии. По инициативе местных органов этот рубеж было предложено усилить укреплениями по линии Лунино — Мокшан — Загоскино — Спасско-Александровка. Это дополнение было принято Государственным Комитетом Обороны СССР и включено в план оборонительных работ второй очереди.',
                    style: Theme.of(context).textTheme.subtitle1,
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