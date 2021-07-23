import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:veterans/domain/word_wrapper.dart';
import 'package:veterans/model/story.dart';
import 'package:veterans/model/veterans/veteran.dart';

import '../html_parser.dart';

class VeteranPdfPage extends pw.Document {
  BuildContext context;

  VeteranPdfPage({this.context});

  final pdf = pw.Document();

  Uint8List pdfFile;
  List<PdfColor> listColor;

  pw.ThemeData themeData;
  pw.TextStyle headline1;
  pw.TextStyle headline2;
  pw.TextStyle headline3;
  pw.TextStyle headline4;
  pw.TextStyle headline5;
  pw.TextStyle headline6;
  pw.TextStyle overline;
  pw.TextStyle bodyText1;
  pw.TextStyle bodyText2;
  pw.TextStyle subtitle1;
  pw.TextStyle subtitle2;
  var PrimaryColor;
  var AccentColor;
  var LineColor;
  var SecondaryColor;
  var UnselectedWidgetColor;
  var SliderInactiveStepColor;
  var pageWidthInLetters = 55;

  _initThemeStyle() async {
    PrimaryColor = PdfColor.fromHex('#708160');
    AccentColor = PdfColor.fromHex('#48533E');
    LineColor = PdfColor.fromHex('#D8C593');
    SecondaryColor = PdfColor.fromHex('#F44336');
    UnselectedWidgetColor = PdfColor.fromHex('#98AA86');
    SliderInactiveStepColor = PdfColor.fromHex('#04DE71');

    var latoRegularTtf = await DefaultAssetBundle.of(context)
        .load("assets/fonts/lato-regular.ttf");
    var latoBoldTtf =
        await DefaultAssetBundle.of(context).load("assets/fonts/lato-bold.ttf");
    var latoBoldItalicTtf = await DefaultAssetBundle.of(context)
        .load("assets/fonts/lato-bold-italic.ttf");
    var latoItalicTtf = await DefaultAssetBundle.of(context)
        .load("assets/fonts/lato-italic.ttf");

    var latoRegularFont = pw.Font.ttf(latoRegularTtf);
    var latoBoldFont = pw.Font.ttf(latoBoldTtf);
    var latoBoldItalicFont = pw.Font.ttf(latoBoldItalicTtf);
    var latoItalicFont = pw.Font.ttf(latoItalicTtf);

    themeData = pw.ThemeData.withFont(
      base: latoRegularFont,
      bold: latoBoldFont,
      italic: latoItalicFont,
      boldItalic: latoBoldItalicFont,
    );

    headline1 = pw.TextStyle(
        fontSize: 20, color: PrimaryColor, fontWeight: pw.FontWeight.normal);
    headline2 = pw.TextStyle(
        fontSize: 20,
        color: SecondaryColor,
        fontWeight: pw.FontWeight.bold,
        fontStyle: pw.FontStyle.italic);
    headline3 = pw.TextStyle(
        fontSize: 20,
        color: PdfColors.white,
        fontWeight: pw.FontWeight.bold,
        fontStyle: pw.FontStyle.italic);
    headline4 = pw.TextStyle(
        fontSize: 18, color: PrimaryColor, fontWeight: pw.FontWeight.bold);
    headline5 = pw.TextStyle(
        fontSize: 18, color: SecondaryColor, fontWeight: pw.FontWeight.bold);
    headline6 = pw.TextStyle(
        fontSize: 14, color: PrimaryColor, fontWeight: pw.FontWeight.bold);
    overline = pw.TextStyle(
        fontSize: 14, color: PdfColors.white, fontWeight: pw.FontWeight.normal);
    bodyText1 = pw.TextStyle(
        fontSize: 18, color: PdfColors.white, fontWeight: pw.FontWeight.normal);
    bodyText2 = pw.TextStyle(
        fontSize: 18, color: PrimaryColor, fontWeight: pw.FontWeight.normal);
    subtitle1 = pw.TextStyle(
        fontSize: 14, color: PrimaryColor, fontWeight: pw.FontWeight.normal);
    subtitle2 = pw.TextStyle(
        fontSize: 14, fontWeight: pw.FontWeight.bold, color: SecondaryColor);
  }

  List<pw.Widget> photos = <pw.Widget>[];
  List<pw.Widget> stories = <pw.Widget>[];
  List<pw.Widget> itemsPage;

  Future<Uint8List> build(Veteran veteran) async {
    await _initThemeStyle();
    await _initItemsPage(veteran);

    if (pdfFile == null) {
      pdf.addPage(pw.MultiPage(
        theme: themeData,
        margin: pw.EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        build: (pw.Context context) {
          return itemsPage;
        },
      ));
      pdfFile = pdf.save();
    }
    return pdfFile;
  }

  Future<List<pw.Widget>> _initItemsPage(Veteran veteran) async {
    List<PdfImage> imagesVeteran = await createTemporaryImage(veteran.images);
    for (int i = 0; i < imagesVeteran.length; i++) {
      photos.add(pw.Container(
        height: 350,
        decoration: pw.BoxDecoration(
            borderRadius: 25,
            image: pw.DecorationImage(
                image: imagesVeteran[i], fit: pw.BoxFit.cover)),
      ));
    }

    itemsPage = [
      pw.Wrap(
          alignment: pw.WrapAlignment.center,
          crossAxisAlignment: pw.WrapCrossAlignment.center,
          children: [
            pw.Container(
              alignment: pw.Alignment.center,
              child: pw.Text(
                  '${veteran.surname} ${veteran.firstName} ${veteran.secondName}',
                  style: headline1,
                  textAlign: pw.TextAlign.center),
            )
          ]),
      pw.SizedBox(height: 25),
      pw.Wrap(
        runSpacing: 15,
        alignment: pw.WrapAlignment.center,
        crossAxisAlignment: pw.WrapCrossAlignment.center,
        children: photos,
      ),
      pw.SizedBox(height: 25),
      pw.Wrap(
        children: [
          pw.Container(
            alignment: pw.Alignment.center,
            child: pw.Text(
                "${veteran.surname} ${veteran.firstName} ${veteran.secondName}",
                style: headline2,
                textAlign: pw.TextAlign.center),
          )
        ],
      ),
      pw.SizedBox(height: 10),
      pw.Wrap(runSpacing: 15, children: [
        pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text('Родился: ', style: headline4),
              pw.Text(
                  '${veteran.placeOfBirth.fullAddress()}',
                  style: bodyText2)
            ]),
        deathDate(veteran),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text(
              'Годы службы: ',
              style: headline4,
            ),
            pw.Text(
                '${veteran.yearsInArmy.start.year} - ${veteran.yearsInArmy.end.year} ',
                style: bodyText2),
          ],
        ),
        pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text('Воинское звание: ', style: headline4),
              pw.Expanded(
                child: pw.Text('${veteran.militaryRank}', style: bodyText2)
              )
            ]),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Награды: ',
              style: headline4,
            ),
            pw.Expanded(
              child: pw.Text('${veteran.honors.join(', ')}', style: bodyText2)
            ),
          ],
        ),
        burialPlace(veteran),
      ]),
    ];

    await Future.forEach(veteran.story, (story) async {
      pw.Widget photoSrory = await getPhotoStory(story);
      itemsPage.add(pw.SizedBox(height: 20));
      itemsPage.add(photoSrory);
      pw.Widget title = getTitle(story);
      itemsPage.add(title);
      List<pw.Widget> desc = await getDesc(story);
      desc.forEach((textWidget) {
        itemsPage.add(textWidget);
      });
      itemsPage.add(pw.SizedBox(
        height: 25,
      ));
    });
  }

  pw.Widget deathDate(Veteran veteran) {
    if (veteran.deathDate != null) {
      return pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Text(
            'Умер: ',
            style: headline4,
          ),
          pw.Text(
              '${veteran.deathDate.day}.${veteran.deathDate.month}.${veteran.deathDate.year}',
              style: bodyText2),
        ],
      );
    } else {
      return pw.SizedBox.shrink();
    }
  }

  burialPlace(Veteran veteran) {
    if (veteran.burialPlace != null) {
      return pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.RichText(text: pw.TextSpan()),
          pw.Text('${veteran.burialPlace}', style: bodyText2),
        ],
      );
    } else {
      return pw.SizedBox.shrink();
    }
  }

  Future<List<PdfImage>> createTemporaryImage(List<String> urlsImages) async {
    List<PdfImage> pdfImages = [];

    for (var url in urlsImages) {
      try {
        http.Response response = await http.get(Uri.parse(url));
        final image = PdfImage.file(
          pdf.document,
          bytes: response.bodyBytes,
        );
        pdfImages.add(image);
      } catch (e) {
        throw e;
      }
    }
    return pdfImages;
  }

  getPhotoStory(Story story) async {
    try {
      if (story.photo.isEmpty)
        return pw.SizedBox.shrink();
      else {
        var photoStory = await createTemporaryImage([story.photo]);
        return pw.Wrap(children: [
          pw.Padding(
            padding: pw.EdgeInsets.only(bottom: 10),
            child: pw.Container(
              height: 350,
              decoration: pw.BoxDecoration(
                borderRadius: 15,
                image: pw.DecorationImage(
                    image: photoStory[0], fit: pw.BoxFit.cover),
              ),
            ),
          )
        ]);
      }
    } catch (e) {
      throw e;
    }
  }

  getTitle(Story story) {
    try {
      return pw.Padding(
        padding: pw.EdgeInsets.only(bottom: 10),
        child: pw.Text(
          '${story.title}',
          textAlign: pw.TextAlign.left,
          style: headline2,
          maxLines: 1,
        ),
      );
    } catch (e) {
      throw e;
    }
  }

  Future<List<pw.Widget>> getDesc(Story story) async {
    List<pw.RichText> desc = List<pw.RichText>();
    Parser p = Parser(context, story.description);
    var parsed = await p.parse();
    var wrapped = wrapText(parsed, pageWidthInLetters);
    wrapped.forEach((element) {
      desc.add(pw.RichText(text: element));
    });
    return desc;
  }

  List<pw.TextSpan> wrapText(List<pw.TextSpan> spans, int wrapLength) {
    List<pw.TextSpan> spanList = List();
    LineSplitter ls = new LineSplitter();
    spans.forEach((element) {
      if (element.text != '' && element.text != '\n' && element.text != ' ' && element.text != '  ') {
        var wrapText = Wordwrapper.wordwrap(element.text, wrapLength);
        List<String> splitLines = ls.convert(wrapText);
        splitLines.forEach((splitLine) {
          spanList.add(pw.TextSpan(
              text: splitLine,
              style: element.style,
              baseline: element.baseline,
              annotation: element.annotation,
              children: element.children));
        });
      } else{
        spanList.add(element);
      }
    });
    return spanList;
  }
}
