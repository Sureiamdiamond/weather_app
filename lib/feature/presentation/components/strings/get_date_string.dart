import 'package:intl/intl.dart';

String getDate(String localtime) {
  String dateName = DateFormat('MMM d').format(DateFormat("yyyy-MM-DD").parse(localtime));
  return dateName;
}