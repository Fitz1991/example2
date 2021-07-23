import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:xml/xml_events.dart' as xmle;

class _Tag {
  String name;
  String styles;

  _Tag(this.name, this.styles);
}

class Parser {
  var _stack = [];
  var _events;

  BuildContext context;
  StyleGenUtils styleGenUtils;

  Parser(BuildContext _context, String data, {Function linksCallback}) {
    context = _context;
    styleGenUtils = StyleGenUtils(context: context);
    _events = xmle.parseEvents(data);
  }

  Future<pw.TextSpan> _getTextSpan(text, style) async {
    var rules = style.split(";").where((item) => !item.trim().isEmpty);
//    final pw.ThemeData parent = pw.Theme.of(pwContext);
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

    pw.TextStyle textStyle = pw.TextStyle(
        color: PdfColor.fromHex("#708160"),
        fontBold: latoBoldFont,
        fontNormal: latoRegularFont,
        fontItalic: latoItalicFont,
        fontBoldItalic: latoBoldItalicFont,
        fontSize: 18,
    );
    await Future.forEach(rules, (rule) async {
      if (rule.indexOf(":") == -1) return;
      final parts = rule.split(":");
      String name = parts[0].trim();
      String value = parts[1].trim();
      switch (name) {
        case "pdf-color":
          textStyle = styleGenUtils.addFontColor(textStyle, value);
          break;

        case "background":
          textStyle = styleGenUtils.addBgColor(textStyle, value);
          break;

        case "font-weight":
          textStyle = styleGenUtils.addFontWeight(textStyle, value);
          break;

        case "font-style":
          textStyle = styleGenUtils.addFontStyle(textStyle, value);
          break;

        case "font-size":
          textStyle = styleGenUtils.addFontSize(textStyle, value);
          break;

        case "text-decoration":
          textStyle = styleGenUtils.addTextDecoration(textStyle, value);
          break;

        case "font-family":
          textStyle = await styleGenUtils.addFontFamily(textStyle, value);
          break;
        default:
          {
            textStyle = await styleGenUtils.addFontFamily(
                textStyle, "lato-regular.ttf");
            break;
          }
          break;
      }
    });
    return pw.TextSpan(style: textStyle, text: text);
  }

  Future<pw.TextSpan> _handleText(String text) async {
    text = TextGenUtils.strip(text);
    if (text.isEmpty) return pw.TextSpan(text: "");
    var style = "";
    _stack.forEach((tag) {
      style += tag.styles + ";";
    });
    pw.TextSpan textSpan;
    textSpan = await _getTextSpan(text, style);
    return textSpan;
  }

  Future<List<pw.TextSpan>> parse() async {
    List spans = <pw.TextSpan>[];
    await Future.forEach(_events, (event) async {
      if (event is xmle.XmlStartElementEvent) {
        if (!event.isSelfClosing) {
          var styles = "";
          if (event.name == 'b' || event.name == 'strong') {
            styles = "font-weight: bold;";
          } else if (event.name == 'i' || event.name == 'em') {
            styles = "font-style: italic;";
          } else if (event.name == 'u') {
            styles = "text-decoration: underline;";
          } else if (event.name == 'strike' ||
              event.name == 'del' ||
              event.name == 's') {
            styles = "text-decoration: line-through;";
          } else if (event.name == 'a') {
            styles = "visit_link:__#TO_GET#__;" +
                "text-decoration: underline;" +
                " color: #0000ff";
          }

          event.attributes.forEach((attribute) {
            if (attribute.name == "style")
              styles = styles + ";" + attribute.value;
            else if (attribute.name == "href") {
              styles = styles.replaceFirst(r"__#TO_GET#__",
                  attribute.value.replaceAll(r":", "__#COLON#__"));
            }
          });

          _stack.add(_Tag(event.name, styles));
        } else {
          if (event.name == "br") {
            spans.add(pw.TextSpan(text: "\n"));
          }
        }
      }

      if (event is xmle.XmlEndElementEvent) {
        // если переход на строку
        var top = _stack.removeLast();
        if (top.name != event.name) {
          print("Malformed HTML");
          return;
        }
        if (event.name == "p") {
          spans.add(pw.TextSpan(text: "\n"));
        }
      }

      if (event is xmle.XmlTextEvent) {
        // есл// и текст
        final currentSpan = await _handleText(event.text);
        if (currentSpan.text.isNotEmpty) {
          spans.add(currentSpan);
        }
      }
    });

    // for the last p tag
    if(spans.length != 0){
      if (spans[spans.length - 1].text == '\n') {
        spans.removeLast();
      }
    }
    return spans;
  }
}

class CSSColors {
  static Map<String, int> values = {
    "aliceblue": 0xFFF0F8FF,
    "antiquewhite": 0xFFFAEBD7,
    "aqua": 0xFF00FFFF,
    "aquamarine": 0xFF7FFFD4,
    "azure": 0xFFF0FFFF,
    "beige": 0xFFF5F5DC,
    "bisque": 0xFFFFE4C4,
    "black": 0xFF000000,
    "blanchedalmond": 0xFFFFEBCD,
    "blue": 0xFF0000FF,
    "blueviolet": 0xFF8A2BE2,
    "brown": 0xFFA52A2A,
    "burlywood": 0xFFDEB887,
    "cadetblue": 0xFF5F9EA0,
    "chartreuse": 0xFF7FFF00,
    "chocolate": 0xFFD2691E,
    "coral": 0xFFFF7F50,
    "cornflowerblue": 0xFF6495ED,
    "cornsilk": 0xFFFFF8DC,
    "crimson": 0xFFDC143C,
    "cyan": 0xFF00FFFF,
    "darkblue": 0xFF00008B,
    "darkcyan": 0xFF008B8B,
    "darkgoldenrod": 0xFFB8860B,
    "darkgray": 0xFFA9A9A9,
    "darkgreen": 0xFF006400,
    "darkgrey": 0xFFA9A9A9,
    "darkkhaki": 0xFFBDB76B,
    "darkmagenta": 0xFF8B008B,
    "darkolivegreen": 0xFF556B2F,
    "darkorange": 0xFFFF8C00,
    "darkorchid": 0xFF9932CC,
    "darkred": 0xFF8B0000,
    "darksalmon": 0xFFE9967A,
    "darkseagreen": 0xFF8FBC8F,
    "darkslateblue": 0xFF483D8B,
    "darkslategray": 0xFF2F4F4F,
    "darkslategrey": 0xFF2F4F4F,
    "darkturquoise": 0xFF00CED1,
    "darkviolet": 0xFF9400D3,
    "deeppink": 0xFFFF1493,
    "deepskyblue": 0xFF00BFFF,
    "dimgray": 0xFF696969,
    "dimgrey": 0xFF696969,
    "dodgerblue": 0xFF1E90FF,
    "firebrick": 0xFFB22222,
    "floralwhite": 0xFFFFFAF0,
    "forestgreen": 0xFF228B22,
    "fuchsia": 0xFFFF00FF,
    "gainsboro": 0xFFDCDCDC,
    "ghostwhite": 0xFFF8F8FF,
    "gold": 0xFFFFD700,
    "goldenrod": 0xFFDAA520,
    "gray": 0xFF808080,
    "green": 0xFF008000,
    "greenyellow": 0xFFADFF2F,
    "grey": 0xFF808080,
    "honeydew": 0xFFF0FFF0,
    "hotpink": 0xFFFF69B4,
    "indianred": 0xFFCD5C5C,
    "indigo": 0xFF4B0082,
    "ivory": 0xFFFFFFF0,
    "khaki": 0xFFF0E68C,
    "lavender": 0xFFE6E6FA,
    "lavenderblush": 0xFFFFF0F5,
    "lawngreen": 0xFF7CFC00,
    "lemonchiffon": 0xFFFFFACD,
    "lightblue": 0xFFADD8E6,
    "lightcoral": 0xFFF08080,
    "lightcyan": 0xFFE0FFFF,
    "lightgoldenrodyellow": 0xFFFAFAD2,
    "lightgray": 0xFFD3D3D3,
    "lightgreen": 0xFF90EE90,
    "lightgrey": 0xFFD3D3D3,
    "lightpink": 0xFFFFB6C1,
    "lightsalmon": 0xFFFFA07A,
    "lightseagreen": 0xFF20B2AA,
    "lightskyblue": 0xFF87CEFA,
    "lightslategray": 0xFF778899,
    "lightslategrey": 0xFF778899,
    "lightsteelblue": 0xFFB0C4DE,
    "lightyellow": 0xFFFFFFE0,
    "lime": 0xFF00FF00,
    "limegreen": 0xFF32CD32,
    "linen": 0xFFFAF0E6,
    "magenta": 0xFFFF00FF,
    "maroon": 0xFF800000,
    "mediumaquamarine": 0xFF66CDAA,
    "mediumblue": 0xFF0000CD,
    "mediumorchid": 0xFFBA55D3,
    "mediumpurple": 0xFF9370DB,
    "mediumseagreen": 0xFF3CB371,
    "mediumslateblue": 0xFF7B68EE,
    "mediumspringgreen": 0xFF00FA9A,
    "mediumturquoise": 0xFF48D1CC,
    "mediumvioletred": 0xFFC71585,
    "midnightBlue": 0xFF191970,
    "mintcream": 0xFFF5FFFA,
    "mistyrose": 0xFFFFE4E1,
    "moccasin": 0xFFFFE4B5,
    "navajowhite": 0xFFFFDEAD,
    "navy": 0xFF000080,
    "oldlace": 0xFFFDF5E6,
    "olive": 0xFF808000,
    "olivedrab": 0xFF6B8E23,
    "orange": 0xFFFFA500,
    "orangered": 0xFFFF4500,
    "orchid": 0xFFDA70D6,
    "palegoldenrod": 0xFFEEE8AA,
    "palegreen": 0xFF98FB98,
    "paleturquoise": 0xFFAFEEEE,
    "palevioletred": 0xFFDB7093,
    "papayawhip": 0xFFFFEFD5,
    "peachpuff": 0xFFFFDAB9,
    "peru": 0xFFCD853F,
    "pink": 0xFFFFC0CB,
    "plum": 0xFFDDA0DD,
    "powderblue": 0xFFB0E0E6,
    "purple": 0xFF800080,
    "rebeccapurple": 0xFF663399,
    "red": 0xFFFF0000,
    "rosybrown": 0xFFBC8F8F,
    "royalblue": 0xFF4169E1,
    "saddlebrown": 0xFF8B4513,
    "salmon": 0xFFFA8072,
    "sandybrown": 0xFFF4A460,
    "seagreen": 0xFF2E8B57,
    "seashell": 0xFFFFF5EE,
    "sienna": 0xFFA0522D,
    "silver": 0xFFC0C0C0,
    "skyblue": 0xFF87CEEB,
    "slateblue": 0xFF6A5ACD,
    "slategray": 0xFF708090,
    "slategrey": 0xFF708090,
    "snow": 0xFFFFFAFA,
    "springgreen": 0xFF00FF7F,
    "steelblue": 0xFF4682B4,
    "tan": 0xFFD2B48C,
    "teal": 0xFF008080,
    "thistle": 0xFFD8BFD8,
    "tomato": 0xFFFF6347,
    "turquoise": 0xFF40E0D0,
    "violet": 0xFFEE82EE,
    "wheat": 0xFFF5DEB3,
    "white": 0xFFFFFFFF,
    "whitesmoke": 0xFFF5F5F5,
    "yellow": 0xFFFFFF00,
    "yellowgreen": 0xFF9ACD32
  };
}

class TextGenUtils {
  /// Removes extra whitespace
  static String strip(String text) {
    var hasSpaceAfter = false;
    var hasSpaceBefore = false;
    if (text.startsWith(" ")) {
      hasSpaceBefore = true;
    }
    if (text.endsWith(" ")) {
      hasSpaceAfter = true;
    }
    text = text.trim();
    if (hasSpaceBefore) text = " " + text;
    if (hasSpaceAfter) text = text + " ";
    return text;
  }

  /// Returns the link of an anchor tag
  static String getLink(String value) {
    return value.replaceAll(r"__#COLON#__", ":");
  }
}

/// Has utility methods to convert CSS to [TextStyle] objects
class StyleGenUtils {
  BuildContext context;

  StyleGenUtils({this.context});

  /// Creates a [TextStyle] to handle CSS font-weight
  pw.TextStyle addFontWeight(pw.TextStyle textStyle, String value) {
    final List<String> _supportedNumValues = [
      "100",
      "200",
      "300",
      "400",
      "500",
      "600",
      "700",
      "800",
      "900"
    ];
    if (_supportedNumValues.contains(value)) {
      return textStyle.copyWith(
          fontWeight: pw.FontWeight.values[_supportedNumValues.indexOf(value)]);
    }
    switch (value) {
      case "normal":
        textStyle = textStyle.copyWith(fontWeight: pw.FontWeight.normal);
        break;
      case "bold":
        textStyle = textStyle.copyWith(fontWeight: pw.FontWeight.bold);
        break;
      default:
        textStyle = textStyle;
    }
    return textStyle;
  }

  int _convertColor(String value) {
    var colorHex = 0xff000000;
    if (value.startsWith("#")) {
      if (value.length == 7)
        colorHex = int.parse(value.replaceAll(r"#", "0xff"));
      else if (value.length == 9)
        colorHex = int.parse(value.replaceAll(r"#", "0x"));
      else if (value.length == 4) {
        value = value.replaceFirst(r"#", "");
        value = value.split("").map((c) => "$c$c").join();
        colorHex = int.parse("0xff$value");
      }
    } else {
      value = value.toLowerCase();
      if (CSSColors.values[value] != null) {
        return CSSColors.values[value];
      }
    }
    return colorHex;
  }

  /// Creates a [TextStyle] to handle CSS color
  pw.TextStyle addFontColor(pw.TextStyle textStyle, String value) {
    return textStyle.copyWith(color: PdfColor.fromInt(_convertColor(value)));
  }

  /// Creates a [TextStyle] to handle CSS background
  pw.TextStyle addBgColor(pw.TextStyle textStyle, String value) {
    PdfColor color = PdfColor.fromInt(_convertColor(value));
    return textStyle.copyWith(background: pw.BoxDecoration(color: color));
  }

  pw.TextStyle addFontStyle(pw.TextStyle textStyle, String value) {
    if (value == "italic") {
      textStyle = textStyle.copyWith(fontStyle: pw.FontStyle.italic);
    } else if (value == "normal") {
      textStyle = textStyle.copyWith(fontStyle: pw.FontStyle.normal);
    }
    return textStyle;
  }

  Future<pw.TextStyle> addFontFamily(
      pw.TextStyle textStyle, String value) async {
    pw.Font pwFont;
    var latoRegularTtf = await DefaultAssetBundle.of(context)
        .load("assets/fonts/lato-regular.ttf");
    var latoRegularFont = pw.Font.ttf(latoRegularTtf);
    var font =
        await DefaultAssetBundle.of(context).load("assets/fonts/${value}");
    if (font != null) {
      pwFont = pw.Font.ttf(font);
    } else
      pwFont = latoRegularFont;
    return textStyle.copyWith(font: pwFont);
  }

  pw.TextStyle addFontSize(pw.TextStyle textStyle, String value) {
    double number = 14.0;
    if (value.endsWith("px")) {
      number = double.parse(value.replaceAll("px", "").trim());
    } else if (value.endsWith("em")) {
      number *= double.parse(value.replaceAll("em", "").trim());
    }
    return textStyle.copyWith(fontSize: number);
  }

  pw.TextStyle addTextDecoration(pw.TextStyle textStyle, String value) {
    if (value.indexOf("underline") != -1) {
      textStyle = textStyle.copyWith(decoration: pw.TextDecoration.underline);
    }
    if (value.indexOf("overline") != -1) {
      textStyle = textStyle.copyWith(decoration: pw.TextDecoration.overline);
    }
    if (value.indexOf("none") != -1) {
      return textStyle.copyWith(decoration: pw.TextDecoration.none);
    }
    if (value.indexOf("line-through") != -1) {
      textStyle = textStyle.copyWith(decoration: pw.TextDecoration.lineThrough);
    }
    if (value.indexOf("double") != -1) {
      textStyle =
          textStyle.copyWith(decorationStyle: pw.TextDecorationStyle.double);
    } else if (value.indexOf("solid") != -1) {
      textStyle =
          textStyle.copyWith(decorationStyle: pw.TextDecorationStyle.solid);
    }
    return textStyle;
  }
}
