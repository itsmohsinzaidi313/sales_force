import 'package:logger/logger.dart';
import 'package:sales_force/objects/data_lists.dart';
import 'package:sales_force/sql/insert_queries.dart';
import 'package:sqflite/sqflite.dart';

import 'file:///C:/Users/imoss/OneDrive/Documents/Projects/Flutter/sales_force/lib/shared/config.dart';
import 'file:///C:/Users/imoss/OneDrive/Documents/Projects/Flutter/sales_force/lib/shared/library.dart';

class ImportToDB {
  Database db;
  Logger _log = Config.log;

  ImportToDB(String flag) {
    initDatabase(flag);
  }

  initDatabase(String flag) async {
    Config.DATABASE_PATH = await Library.getDatabasePath();
    db = await openDatabase(Config.DATABASE_PATH);
    switch (flag.toUpperCase()) {
      case 'INSTALLAPI':
        initInstall();
        break;
      case 'SYNCAPI':
        importSyncApi();
        break;
      default:
        _log.e('CHECK FLAG IN initDatabase');
        break;
    }
  }

  initInstall() async {
    _log.v('ENTRY initInstall');
    importUsers();
    importCategories();
    importProducts();
    importUserTypes();
    importInvoices();
    importCustomerGroups();
    importProductPrices();
    importCustomers();
    importCategoryPermissions();
    importProductFoc();
    _log.v('EXIT initInstall');
  }

  void importCategoryPermissions() {
    try {
      _log.v('ENTRY ON importCategoryPermissions');
      DataLists.listCategoryPermissions.forEach((e) {
//        database.transaction((txn){
//          txn.rawInsert(Insert.insertCategoryPermissions, [e.getCategoryId(), e.getUserId()]);
//        return null;
//        });
        db.rawInsert(Insert.insertCategoryPermissions,
            [e.getCategoryId(), e.getUserId()]);
      });
      _log.v('EXIT ON importCategoryPermissions');
    } catch (e) {
      _log.e('ERROR ON importCategoryPermissions\n$e');
    }
  }

  void importUsers() {
    try {
      _log.v('ENTRY importUsers');
      DataLists.listUsers.forEach((e) {
//        database.transaction((txn) {
//          txn.rawInsert(Insert.insertUsers, e.getList());
//          return null;
//        });
        db.rawInsert(Insert.insertUsers, e.getList());
      });
      _log.v('EXIT importUsers');
    } catch (e) {
      _log.e('ERROR ON importUsers\n$e');
    }
  }

  void importCategories() {
    try {
      _log.v('ENTRY importCategories');
      DataLists.listCategories.forEach((e) {
//        database.transaction(
//            (txn) => txn.rawInsert(Insert.insertCategories, e.getList()));
        db.rawInsert(Insert.insertCategories, e.getList());
      });
      _log.v('EXIT importCategories');
    } catch (e) {
      _log.e('ERROR ON importCategories');
    }
  }

  void importProducts() {
    try {
      _log.v('ENTRY importProducts');
      DataLists.listProduct.forEach((e) {
//        database.transaction(
//            (txn) => txn.rawInsert(Insert.insertProducts, e.getList()));
        db.rawInsert(Insert.insertProducts, e.getList());
      });
      _log.v('EXIT importProducts');
    } catch (e) {
      _log.e('ERROR ON importProducts');
    }
  }

  void importUserTypes() {
    try {
      _log.v('ENTRY ON importUserTypes');
      DataLists.listUserTypes.forEach((e) {
//        database.transaction(
//            (txn) => txn.rawInsert(Insert.insertUsersTypes, e.getList()));
        db.rawInsert(Insert.insertUsersTypes, e.getList());
      });
      _log.v('EXIT ON importUserTypes');
    } catch (e) {
      _log.e('ERROR ON importUserTypes');
    }
  }

  void importInvoices() {
    try {
      _log.v('ENTRY ON importInvoices');
      DataLists.listInvoice.forEach((e) {
//        database.transaction(
//            (txn) => txn.rawInsert(Insert.insertInvoices, e.getList()));
        db.rawInsert(Insert.insertInvoices, e.getList());
      });
      _log.v('EXIT ON importInvoices');
    } catch (e) {
      _log.e('ERROR ON importInvoices');
    }
  }

  void importCustomerGroups() {
    try {
      _log.v('ENTRY ON importCustomerGroups');
      DataLists.listCustomerGroups.forEach((e) {
//        database.transaction(
//            (txn) => txn.rawInsert(Insert.insertCustomerGroups, e.getList()));
        db.rawInsert(Insert.insertCustomerGroups, e.getList());
      });
      _log.v('EXIT ON importCustomerGroups');
    } catch (e) {
      _log.e('ERROR ON importCustomerGroups');
    }
  }

  void importProductPrices() {
    try {
      _log.v('ENTRY ON importProductPrices');
      DataLists.listProductPrices.forEach((e) {
//        database.transaction(
//            (txn) => txn.rawInsert(Insert.insertProductPrices, e.getList()));
        db.rawInsert(Insert.insertProductPrices, e.getList());
      });
      _log.v('EXIT ON importProductPrices');
    } catch (e) {
      _log.e('ERROR ON importProductPrices');
    }
  }

  void importCustomers() {
    try {
      _log.v('ENTRY ON importCustomers');
      DataLists.listCustomer.forEach((e) {
//        database.transaction(
//                (txn) => txn.rawInsert(Insert.insertCustomer, e.getList()));
        db.rawInsert(Insert.insertCustomer, e.getList());
      });
      _log.v('EXIT ON importCustomers');
    } catch (e) {
      _log.e('ERROR ON importCustomers');
    }
  }

  void importSyncApi() {
    try {
      if (DataLists.listSyncPackets != null &&
          DataLists.listSyncPackets.isNotEmpty)
        DataLists.listSyncPackets.forEach((e) async {
          String query =
              "insert into sync_apis(server_id, module, operation, url, createdon, is_used) select server_id, module, operation, url, createdon, is_used from (select '${e.serverId}' as server_id, '${e.module}' as module, '${e.operation}' as operation, '${e.url}' as url, '${e.createdOn}' as createdon, '${e.isUsed}' as is_used) t where not exists(select 1 from sync_apis where sync_apis.server_id = t.server_id);";
          db.rawQuery(query);
        });
    } catch (e) {
      _log.e('ERROR ON importSyncApi', [e]);
    }
  }

  void importProductFoc() {
    try {
      if(DataLists.listProductFoc != null &&
      DataLists.listProductFoc.isNotEmpty)
        DataLists.listProductFoc.forEach((element) {
          String query = Insert.insertProductFoc;
          db.rawInsert(query, [element.productId, element.start, element.end, element.quantity]);
        });
    } catch (e) {
      _log.e('ERROR ON importProductFoc', [e]);
    }
  }
}
