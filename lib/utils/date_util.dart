import 'package:intl/intl.dart';

class DateUtil {
  static final _displayFormatDateFormat = DateFormat('dd/MM/yyyy');
  static final _displayFormayDayFormat = DateFormat('dd MMMM , yyyy | EEEE');
  static final _displayFormayHourFormat = DateFormat('hh:mm a');

  static String getDisplayFormatDate(DateTime dateTime) {
    return _displayFormatDateFormat.format(dateTime);
  }

  static String getDisplayFormatDay(DateTime dateTime) {
    return _displayFormayDayFormat.format(dateTime);
  }

  static String getDisplayFormatHour(DateTime dateTime) {
    return _displayFormayHourFormat.format(dateTime);
  }
}
