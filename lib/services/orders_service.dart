import 'dart:convert';

import 'file:///C:/Users/imoss/OneDrive/Documents/Projects/Flutter/sales_force/lib/shared/config.dart';
import 'file:///C:/Users/imoss/OneDrive/Documents/Projects/Flutter/sales_force/lib/shared/library.dart';
import 'package:sales_force/services/common.dart';
import 'package:sales_force/sql/dal.dart';
import 'package:sales_force/sql/select_queries.dart';
import 'package:sqflite/sqflite.dart';

class SPostOrder extends ServiceCommon {
  Database db;

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
          map = {jsonEncode('order'):[map]};
          bool status = await Library.uploadToServer(Config.putOrderVisitAPILink, jsonString: map.toString());
          DAL.staticDal.setOrderUploadStatus(e['order_android_id'], status);
        });
    } catch (e) {
      print('>>>ERROR ON ORDER UPLOAD SERVICE\n$e');
    }
  }
}
//"order": [{
//"order_android_id": "5e39459f40526",
//"user_id": 1,
//"customer_id": 2,
//"order_amount": 2200,
//"order_discount": 100,
//"order_total": 2100,
//"order_status": 0,
//"order_delivery_date": "2020-02-10",
//"createdon": "2020-02-04 11:21:19",
//"order_product": [{
//"order_id": "5e39459f40526",
//"product_category_id": 1,
//"product_id": 1,
//"order_product_total_packs": 1,
//"order_product_price_per_pack": 1100,
//"order_product_discount_per_pack": 0,
//"order_product_discounted_pack_price": 1100,
//"order_product_total_discount": 0,
//"order_product_total_price": 1100,
//"createdon": "2020-02-04 11:21:19"
//}]}]
