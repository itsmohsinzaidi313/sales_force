import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:sales_force/shared/config.dart';
import 'package:sales_force/sql/dal.dart';
import 'package:sales_force/sql/import_data.dart';
import 'package:sales_force/sql/tables.dart';
import 'package:sqflite/sqflite.dart';

class Install {
  static Logger _log = Config.log;

  Install() {
    try {
      _log.v('INSTALL STARTED');
      _log.i('INITIALIZING DATABASE');
      initDatabase();
    } catch (e) {
      _log.e('ERROR ON Install');
    }
  }

  initDatabase() async {
    String databaseName = Config.DATABASE_NAME;
    String path;
    getDatabasesPath().then((databasePath) {
      //databasePath = value;
      path = join(databasePath, databaseName);
      Config.DATABASE_PATH = path;
      Future<Database> future = openDatabase(path);
      future.then((db) async {
        int newVersion = Config.DATABASE_VERSION;
        int oldVersion = await db.getVersion();
        _log.i('DATABASE VERSION: v' + oldVersion.toString());

        openDatabase(path,
            version: newVersion,
            onCreate: onCreate(db, newVersion),
            onUpgrade: onUpgrade(db, oldVersion, newVersion),
            onDowngrade: onDowngrade(db, oldVersion, newVersion));
      });
    });
  }

  onCreate(Database db, int version) {
    try {
      Future<dynamic> y = databaseExists(Config.DATABASE_PATH);
      y.then((x) {
        if (x == false) {
          _log.v('ENTRY onCREATE');
          _log.i('DATABASE CREATED: v$version');
          db.setVersion(1);
          createTablesV1(db);
          ImportToDB('INSTALLAPI');
          _log.v('EXIT onCreate');
        }
      });
    } catch (e) {
      _log.e('ERROR ON onCreate', [e]);
    }
  }

  onUpgrade(Database db, int oldVersion, int newVersion) {
    try {
      if (oldVersion < newVersion) {
        _log.v('ENTRY onUpgrade');
        db.setVersion(newVersion);
        _log.i('DATABASE UPGRADED TO: v$newVersion');
        dropAllTables(db);
        createTablesV1(db);
        ImportToDB('INSTALLAPI');
        _log.v('EXIT onUpgrade');
      }
    } catch (e) {
      _log.e('ERROR ON onUpgrade', [e]);
    }
  }

  onDowngrade(Database db, int oldVersion, int newVersion) {
    try {
      if (oldVersion > newVersion) {
        _log.v('ENTRY onDowngrade');
        db.setVersion(newVersion);
        _log.i('DATABASE DOWNGRADED TO: v$newVersion');
        //deleteAllTables(db);
        dropAllTables(db);
        createTablesV1(db);
        ImportToDB('INSTALLAPI');
        _log.v('EXIT onDowngrade');
      }
    } catch (e) {
      _log.e('ERROR ON onDowngrade', [e]);
    }
  }

  createTablesV1(Database db) async {
    try {
      _log.v('ENTRY createTablesV1');
      db.execute(TablesV1.PAID_INVOICES);
      db.execute(TablesV1.CUSTOMER);
      db.execute(TablesV1.USERS);
      db.execute(TablesV1.USERSTYPES);
      db.execute(TablesV1.CATEGORIES);
      db.execute(TablesV1.PRODUCTS);
      db.execute(TablesV1.INVOICES);
      db.execute(TablesV1.SALESMAN);
      db.execute(TablesV1.APP_SETTINGS);
      db.execute(TablesV1.PRODUCTPRICES);
      db.execute(TablesV1.CUSTOMERGROUPS);
      db.execute(TablesV1.ORDER_MASTER);
      db.execute(TablesV1.ORDER_DETAIL);
      db.execute(TablesV1.VISITS);
      db.execute(TablesV1.CATEGORY_PERMISSIONS);
      db.execute(TablesV1.SYNC_APIS);
      db.execute(TablesV1.PRODUCT_FOC);
      _log.v('EXIT createTablesV1');
    } catch (e) {
      _log.e('ERROR ON createTablesV1', [e]);
    }
  }

  dropAllTables(Database db) {
    try {
      _log.v('ENTRY dropAllTables');
      db.execute(TablesV1.DROP_USERS);
      db.execute(TablesV1.DROP_USERSTYPES);
      db.execute(TablesV1.DROP_CATEGORIES);
      db.execute(TablesV1.DROP_PRODUCTS);
      db.execute(TablesV1.DROP_INVOICES);
      db.execute(TablesV1.DROP_SALESMAN);
      db.execute(TablesV1.DROP_PRODUCTPRICES);
      db.execute(TablesV1.DROP_CUSTOMERGROUPS);
      db.execute(TablesV1.DROP_CUSTOMER);
      db.execute(TablesV1.DROP_APPSETTINGS);
      db.execute(TablesV1.DROP_ORDER_MASTER);
      db.execute(TablesV1.DROP_ORDER_DETAIL);
      db.execute(TablesV1.DROP_PAID_INVOICES);
      db.execute(TablesV1.DROP_VISITS);
      db.execute(TablesV1.DROP_CATEGORY_PERMISSIONS);
      db.execute(TablesV1.DROP_SYNC_APIS);
      db.execute(TablesV1.DROP_PRODUCT_FOC);
      _log.v('EXIT dropAllTables');
    } catch (e) {
      _log.e('ERROR ON dropAllTables', [e]);
    }
  }

  static deleteAllTables(Database db) async {
    try {
      _log.v('ENTRY deleteAllTables');
      db.delete('users');
      db.delete('categories');
      db.delete('products');
      db.delete('users_types');
      db.delete('invoices');
      db.delete('salesman');
      db.delete('customer');
      db.delete('customer_groups');
      db.delete('appsettings');
      db.delete('product_prices');
      db.delete('order_master');
      db.delete('order_detail');
      db.delete('visits');
      db.delete('category_permissions');
      db.delete('sync_links');
      db.delete('product_foc');
      _log.v('EXIT deleteAllTables');
    } catch (e) {
      _log.e('ERROR ON deleteAllTables', [e]);
    }
  }
}

class Reinstall {
  Database db;
  Logger _log = Config.log;

  Reinstall() {
    _log.v('REINSTALL STARTED');
    _log.v('INITIALIZING DATABASE');
    initDatabase();
  }

  initDatabase() async {
    try {
      String databaseName = Config.DATABASE_NAME;
      String path;
      getDatabasesPath().then((databasePath) {
        //databasePath = value;
        path = join(databasePath, databaseName);
        Config.DATABASE_PATH = path;
        Future<Database> future = openDatabase(path);
        future.then((db) async {
          int newVersion = Config.DATABASE_VERSION;
          int oldVersion = await db.getVersion();
          _log.i('DATABASE VERSION: v' + oldVersion.toString());

          openDatabase(path,
              version: newVersion, onCreate: onCreate(db, newVersion));
        });
      });
    } catch (e) {
      _log.wtf('ERROR ON REINSTALL', [e]);
    }
  }

  onCreate(Database db, int newVersion) {
    db.getVersion().then((oldVersion) {
      if (oldVersion == newVersion) {
        db.delete('users');
        _log.v('USERS DELETED');
        db.delete('customer');
        _log.v('CUSTOMERS DELETED');
        db.delete('users_types');
        _log.v('USERS TYPES DELETED');
        db.delete('categories');
        _log.v('CATEGORIES DELETED');
        db.delete('category_permissions');
        _log.v('CATEGORY PERMISSIONS DELETED');
        db.delete('products');
        _log.v('PRODUCTS DELETED');
        db.delete('invoices');
        _log.v('INVOICES DELETED');
        db.delete('customer_groups');
        _log.v('CUSTOMER GROUPS DELETED');
        db.delete('product_prices');
        _log.v('PRODUCT PRICES DELETED');
        db.delete('sync_apis');
        _log.v('SYNC APIS DELETED');
        db.delete('product_foc');
        _log.v('PRODUCT FOC DELETED');
        ImportToDB('INSTALLAPI');
        DAL.staticDal = new DAL(email: DAL.currentUser.email);
      }
    });
  }
}
