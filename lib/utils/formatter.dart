import 'package:html/parser.dart';
import 'package:intl/intl.dart';

class Formatter {
  static String dateFormat(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);
    final formattedDate = DateFormat('d MMMM yyyy', 'id_ID').format(dateTime);
    final formattedTime = DateFormat('HH.mm', 'id_ID').format(dateTime);
    return '$formattedDate - Pukul $formattedTime';
  }

  static String parseHtmlToText(String htmlText) {
    final document = parse(htmlText);
    String text = document.body?.text ?? '';

    text = text
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll('. ', '.\n\n');

    return text.trim();
  }
}