import 'dart:convert';

import 'package:sales_force/services/common.dart';
import 'package:sales_force/sql/dal.dart';
import 'package:sales_force/sql/select_queries.dart';
import 'package:sqflite/sqflite.dart';

import '../shared/config.dart';
import '../shared/library.dart';

class SPostVisit extends ServiceCommon {
  Database db;

  SPostVisit(Database database) {
    initiate();
    db = database;
  }

  @override
  String get name => 'Visit Service';

  @override
  Future<void> perform() async {
    log.i('VISIT SERVICE RESPONDING');
    uploadVisit();
  }

  uploadVisit() async {
    String query = "select distinct pair_id from visits where is_upload = 0";
    List<Map<String, dynamic>> pairIds = await db.rawQuery(query);
    pairIds.forEach((e) async {

      query = "${Select.selectVisitJson} where pair_id = ${e['pair_id']}";
      List<Map<String, dynamic>> data = await db.rawQuery(query);
      if (data != null) {
        Map<String, String> fJson = new Map();
        fJson['${jsonEncode('visit_data')}'] = jsonEncode(data);
        bool status = await Library.uploadToServer(Config.putOrderVisitAPILink,
            jsonString: fJson.toString());
        DAL.staticDal.setVisitUploadStatus(e['pair_id'].toString(), status);
      }
    });
  }
}
