import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:sales_force/services/common.dart';
import 'package:sales_force/shared/config.dart';
import 'package:sales_force/shared/library.dart';
import 'package:sales_force/sql/dal.dart';
import 'package:sales_force/sql/select_queries.dart';
import 'package:sqflite/sqflite.dart';

class SPostOrder extends ServiceCommon {
  Database db;
  Logger _log = Config.log;
  SPostOrder(Database db) {
    this.db = db;
    initiate();
  }

  @override
  String get name => 'Orders Service';

  @override
  perform() async {
    log.i('ORDER UPLOAD SERVICE RESPONDING');
    uploadOrders();
  }

  uploadOrders() async {
    try {
      String query = Select.selectOrderMaster +
          "where user_id = '${DAL.currentUser.user_id}' and order_status = '0'";
      List<Map<String, dynamic>> master = await db.rawQuery(query);

      if (master != null)
        master.forEach((e) async {
          query = Select.selectOrderDetail +
              "where master_id = ${e['order_android_id']}";
          Map<String, dynamic> map = Map();
          List<Map<String, dynamic>> detail = await db.rawQuery(query);
          e.forEach((k, v) {
            map[jsonEncode(k)] = jsonEncode(v);
          });
          map[jsonEncode('order_product')] = jsonEncode(detail);
          query =
              '${Select.selectOrderLocation} where isorder = 1 and order_id = ${e['order_android_id']}';
          List<Map<String, dynamic>> locationMap = await db.rawQuery(query);
          map = {
            '${jsonEncode('visit_data')}': jsonEncode(locationMap),
            jsonEncode('order'): [map]
          };
          bool status = await Library.uploadToServer(
              Config.putOrderVisitAPILink,
              jsonString: map.toString());
          DAL.staticDal.setOrderUploadStatus(e['order_android_id'], status);
          DAL.staticDal.setVisitUploadStatus(
              e['order_taken_android_id'].toString(), status);
        });
    } catch (e) {
      _log.e('>>>ERROR ON ORDER UPLOAD SERVICE\n$e');
    }
  }
}
