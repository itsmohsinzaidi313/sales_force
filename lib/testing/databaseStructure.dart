import 'package:sales_force/testing/table.dart';
import 'package:sqflite/sqflite.dart';
import 'columnTypes.dart';
import 'column.dart';

class DatabaseStructure {
  Database db;
  final Table USERS = new Table(
      name: Table.USERS, columns: Column.USERS, types: ColumnTypes.USERS);
  final Table USERSTYPES = new Table(
      name: Table.USERS_TYPES,
      columns: Column.USERSTYPES,
      types: ColumnTypes.USERSTYPES);
  final Table CATEGORIES = new Table(
      name: Table.CATEGORIES,
      columns: Column.CATEGORIES,
      types: ColumnTypes.CATEGORIES);
  final Table PRODUCTS = new Table(
      name: Table.PRODUCTS,
      columns: Column.PRODUCTS,
      types: ColumnTypes.PRODUCTS);
  final Table INVOICES = new Table(
      name: Table.INVOICES,
      columns: Column.INVOICES,
      types: ColumnTypes.INVOICES);
  final Table SALESMAN = new Table(
      name: Table.SALESMAN,
      columns: Column.SALESMAN,
      types: ColumnTypes.SALESMAN);
  final Table APPSETTINGS = new Table(
      name: Table.APP_SETTINGS,
      columns: Column.APP_SETTINGS,
      types: ColumnTypes.APP_SETTINGS);
  final Table PRODUCTPRICES = new Table(
      name: Table.PRODUCT_PRICES,
      columns: Column.PRODUCTPRICES,
      types: ColumnTypes.PRODUCTPRICES);
  final Table CUSTOMERGROUPS = new Table(
      name: Table.CUSTOMER_GROUPS,
      columns: Column.CUSTOMER_GROUPS,
      types: ColumnTypes.CUSTOMER_GROUPS);
  final Table CUSTOMER = new Table(
      name: Table.CUSTOMER,
      columns: Column.CUSTOMER,
      types: ColumnTypes.CUSTOMER);
  final Table ORDER_MASTER = new Table(
      name: Table.ORDER_MASTER,
      columns: Column.ORDER_MASTER,
      types: ColumnTypes.ORDER_MASTER);
  final Table ORDER_DETAIL = new Table(
      name: Table.ORDER_DETAIL,
      columns: Column.ORDER_DETAIL,
      types: ColumnTypes.ORDER_DETAIL);

  DatabaseStructure({this.db}) {
    initDatabaseStructure();
  }

  initDatabaseStructure() {}
}
