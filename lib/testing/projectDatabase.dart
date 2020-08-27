import 'package:sales_force/shared/config.dart';
import 'package:sales_force/testing/table.dart' as T;
import 'package:sales_force/testing/tables.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class ProjectDatabase {
  static String databaseName = Config.DATABASE_NAME;
  static int databaseVersion;
  int dbVersion = Config.DATABASE_VERSION;
  static Database _database;
  Future<Database> get database async {
    if (_database != null) {
      databaseVersion = await _database.getVersion();
      return _database;
    } else {
      return _initDatabase();
    }
  }

  Future<Database> _initDatabase() async {
    String databaseLocation = await getDatabasesPath();
    String path = join(databaseLocation, Config.DATABASE_NAME);
    _database = await openDatabase(path);
    databaseVersion = await _database.getVersion();
    return _database;
  }

  static bool isNull = true;
  static const List<T.Table> tablesList = [
    Tables.users,
    Tables.userTypes,
    Tables.categories,
    Tables.products,
    Tables.invoices,
    Tables.salesman,
    Tables.appSettings,
    Tables.productPrices,
    Tables.customerGroups,
    Tables.customer,
    Tables.orderMaster,
    Tables.orderDetail
  ];

  void create(Database db) {
    tablesList.forEach((table) => table.create(db));
  }

  void truncate(Database db) {
    tablesList.forEach((table) => table.delete(db));
  }

  void onCreate(Database db, int version) {}
  void onUpgrade(Database db, int oldVersion, int newVersion) {
    if (oldVersion < newVersion) {
      tablesList.forEach((table) => table.create(db));
    }
  }

  void onDowngrade(Database db, int oldVersion, int newVersion) {
    if (oldVersion > newVersion) {
      tablesList.forEach((table) => table.create(db));
    }
  }
}
