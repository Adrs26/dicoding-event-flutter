import 'package:intl/intl.dart';

class Formatter {
  static String dateFormat(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);
    final formattedDate = DateFormat('d MMMM yyyy', 'id_ID').format(dateTime);
    final formattedTime = DateFormat('HH.mm', 'id_ID').format(dateTime);
    return '$formattedDate - Pukul $formattedTime';
  }
}