import 'dart:convert';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:sales_force/Json_data_models/sync_api.dart';
import 'package:sales_force/shared/library.dart';
import 'package:sales_force/models/category.dart';
import 'package:sales_force/models/category_permissions.dart';
import 'package:sales_force/models/customer.dart';
import 'package:sales_force/models/invoice.dart';
import 'package:sales_force/models/product.dart';
import 'package:sales_force/models/product_prices.dart';
import 'package:sales_force/models/sync_packet.dart';
import 'package:sales_force/models/user.dart';
import 'package:sales_force/services/common.dart';
import 'package:sales_force/sql/custom_queries.dart';
import 'package:sales_force/sql/dal.dart';
import 'package:sales_force/sql/insert_queries.dart';
import 'package:sales_force/sql/select_queries.dart';
import 'package:sales_force/sql/update_queries.dart';
import 'package:sqflite/sqflite.dart';

import '../shared/config.dart';

class SSyncService extends ServiceCommon {
  Database db;
  Logger _log = Config.log;

  SSyncService(Database database) {
    initiate();
    this.db = database;
  }

  @override
  String get name => 'Sync Service';

  @override
  Future<void> perform() async {
    log.i('SYNC SERVICE RESPONDING');
//    db
//        .rawQuery("select * from sync_apis")
//        .then((onValue) => print(onValue))
//        .catchError((onError) => print(onError));
    if (await Library.hasServerAccess()) {
      await syncData();
    }
  }

  syncData() async {
    try {
      ApiSync();
      List<SyncPacket> list = await getApis();
      list.forEach((e) async {
        Response response =
            await get(e.url).timeout(Duration(seconds: 5), onTimeout: () {
          _log.w('CONNECTION TIMEOUT\nSYNC FAILED');
          return null;
        });
        if (response != null) {
          Map<String, dynamic> data = jsonDecode(response.body);
          bool status = data['status'].toString().toUpperCase() == 'FAILED'
              ? false
              : true;
          //String message = data['message'];
          if (status) {
            data = data['data'];
            // INVOICES
            if (e.module == 'invoice') {
              Invoice invoice = new Invoice.withMap(data['invoices']);
              if (e.operation == 'insert') {
                insertInvoice(db, invoice, e.serverId);
              }
            }
            // CUSTOMERS
            else if (e.module == 'customer') {
              Customer customer = new Customer.withMap(data['customers']);
              if (e.operation == 'create') {
                insertCustomer(db, customer, e.serverId);
              }
              if (e.operation == 'update')
                updateCustomer(db, customer, e.serverId);
            }
            // USERS
            else if (e.module == 'user') {
              User user = new User.withMap(data['users']);
              if (e.operation == 'insert') insertUser(db, user, e.serverId);
              if (e.operation == 'update') updateUser(db, user, e.serverId);
            }
            // CATEGORIES
            else if (e.module == 'category') {
              Category category = new Category.withMap(data['categories']);
              if (e.operation == 'insert') {
                insertCategory(db, category, category.getCategoryPermissions(),
                    e.serverId);
              } else if (e.operation == 'update') {
                updateCategory(db, category, category.getCategoryPermissions(),
                    e.serverId);
              }
            }
            // PRODUCTS
            else if (e.module == 'product') {
              Product product = new Product.withMap(data['products']);
              if (e.operation == 'insert') {
                insertProduct(
                    db, product, product.getCustomerGroupPrices(), e.serverId);
              } else if (e.operation == 'update')
                updateProduct(
                    db, product, product.getCustomerGroupPrices(), e.serverId);
            }
          }
        } else {
          _log.w('NULL RESPONSE RECEIVED\nSYNC FAILED');
        }
      });
    } catch (e) {
      log.e('ERROR ON SYNC SERVICE syncData', [e]);
    }
  }

  getApis() async {
    List<SyncPacket> list = [];

    List<dynamic> dbData =
        await db.rawQuery("${Select.selectSyncApis} where is_used = 0");
    if (dbData != null)
      dbData.forEach((e) => list.add(new SyncPacket(
          serverId: e['server_id'].toString(),
          module: e['module'].toString(),
          operation: e['operation'].toString(),
          createdOn: e['createdon'].toString(),
          url: e['url'])));
    return list;
  }

  insertInvoice(Database db, Invoice invoice, String serverId) async {
    try {
      if (invoice != null) {
//        List<Map<String, dynamic>> map =
//            await db.rawQuery(Insert.insertInvoiceIfNotExists(invoice));
        if (!await CustomQueries.invoiceExists(db, invoice)) {
          db.rawInsert(Insert.insertInvoices, invoice.getList());
          DAL.withDb(db: db).getInvoices();
        }
        Update.updateSyncApiStatus(serverId, db);
        // DAL.staticInvoices.add(invoice);
        _log.i('NEW INVOICE ADDED');
      }
    } catch (e) {
      log.e('NEW INVOICE INSERT FAILED', e);
    }
  }

  void insertCustomer(Database db, Customer customer, String serverId) async {
    if (customer != null) {
//      List<Map<String, dynamic>> map =
//          await db.rawQuery(Insert.insertCustomerIfNotExists(customer));
      if (!await CustomQueries.customerExists(db, customer)) {
        db
            .rawQuery(Insert.insertCustomer, customer.getList())
            .catchError((e) => _log.e(e));
        DAL.withDb(db: db).getCustomer();
        _log.i('NEW CUSTOMER ADDED');
      }
      Update.updateSyncApiStatus(serverId, db);
//      DAL.staticCustomers.removeAt(DAL.staticCustomers.indexOf(customer));
//      DAL.staticCustomers.add(customer);
//      log.i('NEW CUSTOMER ADDED');
    }
  }

  Future<void> insertUser(Database db, User user, String serverId) async {
//    db.rawQuery(Insert.insertUserIfNotExists(user));
    if (!await CustomQueries.userExists(db, user)) {
      db.rawQuery(Insert.insertUsers, user.getList());
      DAL
          .withDb(
            db: db,
          )
          .getUsers();
      _log.i('NEW USER ADDED');
    }
    Update.updateSyncApiStatus(serverId, db);
//    DAL.staticUsers.add(user);
  }

  void updateCategory(Database db, Category category,
      List<CategoryPermissions> categoryPermissions, String serverId) {
    if (category != null) {
      Update.updateCategoryAndPermissions(db, category, categoryPermissions);
      Update.updateSyncApiStatus(serverId, db);
      DAL.withDb(db: db).getCategories();
      _log.i('CATEGORY UPDATED');
    }
  }

  Future<void> insertProduct(Database db, Product product,
      List<ProductPrices> listProductPrices, String serverId) async {
    if (!await CustomQueries.productExists(db, product)) {
      db.rawInsert(Insert.insertProducts, product.getList());
      listProductPrices.forEach((element) {
        db.rawInsert(Insert.insertProductPrices, element.getList());
      });
      DAL.withDb(db: db).getProducts();
      DAL.withDb(db: db).getProductPrices();
      _log.i('PRODUCT INSERTED');
    }
    Update.updateSyncApiStatus(serverId, db);
  }

  void updateProduct(Database db, Product product,
      List<ProductPrices> productPrices, String serverId) {
    Update.updateProduct(db, product, productPrices);
    Update.updateSyncApiStatus(serverId, db);
    DAL.withDb(db: db).getProducts();
    DAL.withDb(db: db).getProductPrices();
    _log.i('PRODUCT UPDATED');
  }

  void insertCategory(Database db, Category category,
      List<CategoryPermissions> categoryPermissions, String serverId) async {
    //product_category_id, user_id, product_category_title, product_category_image, createdon, modifiedon
    if (!await CustomQueries.categoryExists(db, category)) {
      db.rawInsert(Insert.insertCategories, category.getList());
      categoryPermissions.forEach((e) => db.rawInsert(
          Insert.insertCategoryPermissions,
          [e.getCategoryId(), e.getUserId()]));
      DAL.withDb(db: db).getCategories();
      _log.i('CATEGORY INSERTED');
    }
    Update.updateSyncApiStatus(serverId, db);
    //DAL.staticCategories.add(category);
//    db.rawQuery("select  from categories where product_category_id in (select category_id from category_permissions where user_id = '${DAL.currentUser.user_id}')");
  }

  void updateUser(Database db, User user, String serverId) {
    Update.updateUsers(db, user);
    if (DAL.currentUser.user_id == user.user_id) DAL.currentUser = user;
    Update.updateSyncApiStatus(serverId, db);
    DAL.withDb(db: db).getUsers();
    _log.i('USER UPDATED');
  }

  void updateCustomer(Database db, Customer customer, String serverId) {
    Update.updateCustomer(db, customer);
    Update.updateSyncApiStatus(serverId, db);
    DAL.withDb(db: db).getCustomer();
    _log.i('CUSTOMER UPDATED');
  }
}
