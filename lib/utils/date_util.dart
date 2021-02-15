import 'package:intl/intl.dart';

class DateUtil {
  static final _displayFormatDateFormat = DateFormat('dd/MM/yyyy');

  static String getDisplayFormatDate(DateTime dateTime) {
    return _displayFormatDateFormat.format(dateTime);
  }
}
