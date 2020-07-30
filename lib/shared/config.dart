import 'package:logger/logger.dart';
import 'package:sales_force/sql/dal.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class Config {
  static int DATABASE_BASE_VERSION;
  static const int DATABASE_VERSION = 29;
  static const String DATABASE_NAME = 'SaleForce.db';
  static Database DATABASE;
  static String DATABASES_PATH;
  static String DATABASE_PATH;

  static const String serverAddress = '72.52.142.19';
  static const String apiPrefix = 'http://72.52.142.19/ddf-pvt-ltd/webservice/';
  static const String installAPILink = apiPrefix + 'api.php?action=install';
  static String putInvoiceAPILink = apiPrefix +
      'api.php?action=put&module=invoice_payment&user=${DAL.currentUser.user_id}';

  static String putOrderVisitAPILink =
      apiPrefix + 'api.php?action=put&module=visit_order&user=${DAL.currentUser.user_id}';
  static String putTrackingAPILink =
      apiPrefix + 'api.php?action=put&module=tracking&user=${DAL.currentUser.user_id}';
  static String syncAPILink = apiPrefix + 'api.php?action=sync&createdon=';
  static const int serviceCycleDelay = 10; //seconds

  static double deviceDisplayWidth;
  static double deviceDisplayHeight;

  static final Logger log = new Logger(printer: PrettyPrinter(
      colors: true,
      errorMethodCount: 1,
      printEmojis: true,
      printTime: false,
      lineLength: 80,
      methodCount: 0
  ));
}
