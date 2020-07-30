import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:sales_force/shared/config.dart';
import 'package:sales_force/services/invoice_service.dart';
import 'package:sales_force/services/location_service.dart';
import 'package:sales_force/services/orders_service.dart';
import 'package:sales_force/services/sync_service.dart';
import 'package:sales_force/services/visit_service.dart';
import 'package:sqflite/sqflite.dart';

class ServiceControl {
  SPostOrder orderService;
  SPostInvoice invoiceService;
  SPostLocation locationService;
  SPostVisit visitService;
  SSyncService syncService;
  Logger _log = Config.log;
  ServiceControl() {
    this.locationService = new SPostLocation();
    databaseDependent();
  }

  databaseDependent() async {
    try {
      Database database = await _getDatabase();
      this.invoiceService = new SPostInvoice(database);
      this.orderService = new SPostOrder(database);
      this.visitService = new SPostVisit(database);
      this.syncService = new SSyncService(database);
    } catch (e) {
      _log.e('ERROR ON DATABASE DEPENDENT SERVICES', [e]);
    }
  }

  bool serviceStatus(String name) {
    bool status;
    if (name == locationService.name)
      status = locationService.status();
    else if (name == orderService.name)
      status = orderService.status();
    else if (name == visitService.name)
      status = visitService.status();
    else if (name == syncService.name)
      status = syncService.status();
    else if (name == invoiceService.name) status = invoiceService.status();
    return status;
  }

  updateServiceStatus(String name, bool status) {
    if (name == locationService.name)
      locationService.setStatus(status);
    else if (name == orderService.name)
      orderService.setStatus(status);
    else if (name == visitService.name)
      visitService.setStatus(status);
    else if (name == syncService.name)
      syncService.setStatus(status);
    else if (name == invoiceService.name) invoiceService.setStatus(status);
  }

  getList() {
    return [
      syncService,
      visitService,
      invoiceService,
      orderService,
      locationService,
    ];
  }

  startAllServices() {
    locationService.start();
    orderService.start();
    invoiceService.start();
    visitService.start();
    syncService.start();
  }

  stopAllService() {
    locationService.stop();
    orderService.stop();
    invoiceService.stop();
    visitService.stop();
    syncService.stop();
  }

  _getDatabase() async {
    String dbStorage = await getDatabasesPath();
    String path = join(dbStorage, Config.DATABASE_NAME);
    Database db = await openDatabase(path, singleInstance: false);
    return db;
  }
}
