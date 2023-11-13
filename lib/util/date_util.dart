
import 'package:intl/intl.dart';

class DateTimeUtil {
  static final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');
  static final DateFormat _dateTimeFormat = DateFormat('hh:mm dd-MM-yyyy');

  static final DateFormat _dateFormat2 = DateFormat('dd/MM');

  static String format(DateTime dateTime) {
    return _dateFormat.format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    return _dateTimeFormat.format(dateTime);
  }

  static String formatDate(DateTime dateTime) {
    return _dateFormat2.format(dateTime);
  }
}