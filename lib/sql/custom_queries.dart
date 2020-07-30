import 'package:logger/logger.dart';
import 'package:sales_force/shared/config.dart';
import 'package:sales_force/models/category.dart';
import 'package:sales_force/models/customer.dart';
import 'package:sales_force/models/invoice.dart';
import 'package:sales_force/models/product.dart';
import 'package:sales_force/models/user.dart';
import 'package:sqflite/sqflite.dart';

class CustomQueries {
  static Logger _log = Config.log;

  static Future<bool> userExists(Database db, User user) async {
    bool flag = false;
    try {
      int count = 0;
      List<Map<String, dynamic>> listMap = await db.rawQuery(
          "SELECT count(id) as count from users where user_id = '${user.user_id}'");
      count = listMap[0]['count'];
      if (count > 0) flag = true;
      return flag;
    } catch (e) {
      _log.e(e);
      return flag;
    }
  }

  static Future<bool> customerExists(Database db, Customer customer) async {
    bool flag = false;
    try {
      int count = 0;
      List<Map<String, dynamic>> listMap = await db.rawQuery(
          "SELECT count(id) as count from customer where customer_id = '${customer.customerId}'");
      count = listMap[0]['count'];
      if (count > 0) flag = true;
      return flag;
    } catch (e) {
      _log.e(e);
      return flag;
    }
  }

  static Future<bool> invoiceExists(Database db, Invoice invoice) async {
    bool flag = false;
    try {
      int count = 0;
      List<Map<String, dynamic>> listMap = await db.rawQuery(
          "SELECT count(id) as count from invoices where invoice_number = '${invoice.invoice_number}'");
      count = listMap[0]['count'];
      if (count > 0) flag = true;
      return flag;
    } catch (e) {
      _log.e(e);
      return flag;
    }
  }

  static Future<bool> productExists(Database db, Product product) async {
    bool flag = false;
    try {
      int count = 0;
      List<Map<String, dynamic>> listMap = await db.rawQuery(
          "SELECT count(id) as count from products where product_id = '${product.product_id}'");
      count = listMap[0]['count'];
      if (count > 0) flag = true;
      return flag;
    } catch (e) {
      _log.e(e);
      return flag;
    }
  }

  static Future<bool> categoryExists(Database db, Category category) async {
    bool flag = false;
    try {
      int count = 0;
      List<Map<String, dynamic>> listMap = await db.rawQuery(
          "SELECT count(id) as count from Categories where product_category_id = '${category.product_category_id}'");
      count = listMap[0]['count'];
      if (count > 0) flag = true;
      return flag;
    } catch (e) {
      _log.e(e);
      return flag;
    }
  }

  static Future<bool> categoryPermissionsExists(
      Database db, String categoryId, String userId) async {
    bool flag = false;
    try {
      int count = 0;
      List<Map<String, dynamic>> listMap = await db.rawQuery(
          "SELECT count(id) as count from category_permissions where category_id = '$categoryId' and user_id = '$userId'");
      count = listMap[0]['count'];
      if (count > 0) flag = true;
      return flag;
    } catch (e) {
      _log.e(e);
      return flag;
    }
  }
}
