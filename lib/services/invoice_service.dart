import 'dart:convert';

import 'package:sales_force/shared/library.dart';
import 'package:sales_force/services/common.dart';
import 'package:sales_force/sql/dal.dart';
import 'package:sales_force/sql/select_queries.dart';
import 'package:sqflite/sqflite.dart';

import '../shared/config.dart';

class SPostInvoice extends ServiceCommon {
  @override
  String get name => 'Invoice Service';

  @override
  Future<void> perform() async {
    Config.log.i('INVOICE UPLOAD SERVICE RESPONDING');
    _uploadInvoices();
  }

  Database db;

  SPostInvoice(Database db) {
    this.db = db;
    initiate();
  }

  _uploadInvoices() async {
    try {
      String query = Select.selectInvoiceForPost +
          "where payment_user_id = '${DAL.currentUser.user_id}' and is_upload = 0";
      List<Map<String, dynamic>> invoices = await db.rawQuery(query);

      if (invoices != null)
        invoices.forEach((inv) async {
          Map<String, String> packet = {
            '${jsonEncode('invoice_payment')}': '[${jsonEncode(inv)}]'
          };
          bool status = false;
          if (packet != null) {
            status = await Library.uploadToServer(Config.putInvoiceAPILink,
                jsonString: packet.toString());
            await DAL.staticDal.setInvoiceUploadStatus(
                inv['android_payment_id'].toString(), status);
          }
        });
    } catch (e) {
      log.e('>>>ERROR ON INVOICE UPLOAD SERVICE\n$e');
    }
  }
}
