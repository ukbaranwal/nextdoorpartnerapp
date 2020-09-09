import 'package:jiffy/jiffy.dart';

class DateConverter {
  static String convert(String timestamp) {
    if (timestamp == null) {
      return '';
    }
    DateTime date = DateTime.parse(timestamp).toLocal();
    return Jiffy(date, 'yyyy-MM-dd hh:mm:ss.ms').yMMMdjm;
  }
}
