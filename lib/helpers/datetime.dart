import 'package:intl/intl.dart';

String getCurrentDate(){
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('d/M/y').format(now);
  return formattedDate;
}