import 'package:intl/intl.dart';

class Visit {
  DateTime createdOn;
  bool isUploaded;

  Visit({this.createdOn, this.isUploaded});

  Visit.withString(String createdOn, String isUploaded) {
    this.createdOn = DateTime.parse(createdOn);
    this.isUploaded = int.parse(isUploaded) == 1 ? true : false;
  }

  getStringDate() {
    return DateFormat("yyyy-MM-dd hh:mm:ss a").format(this.createdOn).toString();
  }
}