import 'package:logger/logger.dart';
import 'file:///C:/Users/imoss/OneDrive/Documents/Projects/Flutter/sales_force/lib/shared/library.dart';
import 'package:sales_force/objects/category.dart';
import 'package:sales_force/objects/category_permissions.dart';
import 'package:sales_force/objects/customer.dart';
import 'package:sales_force/objects/product.dart';
import 'package:sales_force/objects/product_foc.dart';
import 'package:sales_force/objects/product_prices.dart';
import 'package:sales_force/objects/user.dart';
import 'package:sales_force/sql/insert_queries.dart';
import 'package:sqflite/sqflite.dart';
import '../shared/config.dart';

class Update {
  static Logger _log = Config.log;
  static updateLoggedIn(bool loginStatus, Database db) async {
    int x = await db.rawUpdate('update app_settings set is_loggedin = ?',
        [1]).catchError((e) => _log.e(e));
    if (x > 0)
      return true;
    else
      return false;
  }

  static updateSyncDate(String syncDate, Database db) async {
    int x = await db.rawUpdate('update app_settings set sync_date = ?',
        [Library.getDateTime()]).catchError((e) => _log.e(e));
    if (x > 0)
      return true;
    else
      return false;
  }

  static updateSyncApiStatus(String id, Database db) async {
    int x = await db.rawUpdate(
        'update sync_apis set is_used = 1 where server_id = ?',
        [id]).catchError((e) => _log.e(e));
    print('>>>API UPDATED $x');
    return x;
  }

  static void updateCategoryAndPermissions(Database db, Category category,
      List<CategoryPermissions> categoryPermissions) {
    db
        .rawUpdate(
            "update categories set product_category_id = ?, user_id = ?, product_category_title = ?, product_category_image = ?, createdon = ?, modifiedon = ? where product_category_id = '${category.product_category_id}'",
            category.getList())
        .catchError((e) => _log.e(e));

    if (categoryPermissions != null) {
      db.execute(
          "delete from category_permissions where category_id = '${category.product_category_id}'");
      categoryPermissions.forEach((e) {
        db.rawQuery(Insert.insertCategoryPermissions,
            [e.categoryId, e.userId]).catchError((e) => _log.e(e));
      });
    }
  }

  static void updateProduct(
      Database db, Product product, List<ProductPrices> productPrices) {
    db.rawUpdate(
        "update products set product_category_id = ?, product_type_id = ?, user_id = ?, product_title = ?, product_pack_price = ?, product_packs_per_carton = ?, product_carton_price = ?, product_price_per_liter = ?, discount_type = ?, discount = ?, isActive = ?, createdon = ?, modifiedon = ?, product_image = ? where product_id = '${product.product_id}'",
        [
          product.product_category_id,
          product.product_type_id,
          product.user_id,
          product.product_title,
          product.product_pack_price,
          product.product_pack_per_carton,
          product.product_carton_price,
          product.product_price_per_liter,
          product.discount_type,
          product.discount,
          product.isActive,
          product.createdon,
          product.modifiedon,
          product.product_image
        ]).catchError((e) => _log.e(e));
    db.execute(
        "delete from product_prices where product_id = '${product.product_id}'");
    productPrices.forEach((e) {
      db.rawInsert(Insert.insertProductPrices, [
        e.product_id,
        e.customer_group_id,
        e.cash_price,
        e.credit_price
      ]).catchError((e) => _log.e(e));
    });
  }

  static void updateUsers(Database db, User user) {
    _log.w('updateUsers: ${user.getList()}');

    db
        .rawUpdate(
            "update users set user_id = ?, user_type_id = ?, distributor_id = ?, user_first_name = ?, user_last_name = ?, user_email_address = ?, user_password = ?, user_phone_number = ?, user_mobile = ?, user_status = ?, createdon = ?, modifiedon = ?, discount_percent = ? where user_id = '${user.user_id}'",
            user.getList())
        .catchError((e) => _log.e(e));
  }

  static void updateCustomer(Database db, Customer customer) {
    db
        .rawUpdate(
            "update customer set customer_id = ?, customer_group_id = ?, user_id = ?, country_id = ?, city_id = ?, state_id = ?, area_id = ?, customer_first_name = ?, customer_last_name = ?, customer_email = ?, customer_phone = ?, customer_mobile = ?, customer_shop_name = ?, customer_address1 = ?, status = ?, discount_type = ?, discount = ?, credit_limit = ? where customer_id = '${customer.customerId}'",
            customer.getList())
        .catchError((e) => _log.e(e));
  }

  static void updateProductFoc(Database db, List<ProductFoc> listProductFoc) {
    listProductFoc.forEach((element) {
      db.delete('product_foc',
          where: 'product_id = ?', whereArgs: [element.productId]);
      db.rawInsert(Insert.insertProductFoc,
          [element.productId, element.start, element.end, element.quantity]);
    });
  }
}
