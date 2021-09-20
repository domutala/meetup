import 'package:intl/intl.dart';

int calcAge(String date) {
  final birthday = DateTime.parse(date);
  final date2 = DateTime.now();
  final difference = date2.difference(birthday);
  return (difference.inDays / 360).floor();
}

String foratDate({required String date, String format = 'dd MMM yyyy'}) {
  return DateFormat(format).format(DateTime.parse(date));
}
