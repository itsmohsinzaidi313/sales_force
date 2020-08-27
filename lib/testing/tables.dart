import 'package:sales_force/testing/columnTypes.dart';
import 'package:sales_force/testing/columns.dart';
import 'package:sales_force/testing/table.dart' as T;

class Tables {
  static const T.Table users = const T.Table(
      name: _users, columnNames: Columns.users, types: ColumnTypes.users);
  static const T.Table userTypes = const T.Table(
      name: _userTypes,
      columnNames: Columns.userTypes,
      types: ColumnTypes.userTypes);
  static const T.Table categories = const T.Table(
      name: _categories,
      columnNames: Columns.categories,
      types: ColumnTypes.categories);
  static const T.Table products = const T.Table(
      name: _products,
      columnNames: Columns.products,
      types: ColumnTypes.products);
  static const T.Table invoices = const T.Table(
      name: _invoices,
      columnNames: Columns.invoices,
      types: ColumnTypes.invoices);
  static const T.Table salesman = const T.Table(
      name: _salesman,
      columnNames: Columns.salesman,
      types: ColumnTypes.salesman);
  static const T.Table appSettings = T.Table(
      name: _appSettings,
      columnNames: Columns.appSettings,
      types: ColumnTypes.appSettings);
  static const T.Table productPrices = const T.Table(
      name: _productPrices,
      columnNames: Columns.productPrices,
      types: ColumnTypes.productPrices);
  static const T.Table customerGroups = const T.Table(
      name: _customerGroups,
      columnNames: Columns.customerGroups,
      types: ColumnTypes.customerGroups);
  static const T.Table customer = const T.Table(
      name: _customer,
      columnNames: Columns.customer,
      types: ColumnTypes.customer);
  static const T.Table orderMaster = const T.Table(
      name: _orderMaster,
      columnNames: Columns.orderMaster,
      types: ColumnTypes.orderMaster);
  static const T.Table orderDetail = const T.Table(
      name: _orderDetail,
      columnNames: Columns.orderDetail,
      types: ColumnTypes.orderDetail);
  // static const String USERS = 'users';
  // static const String USERS_TYPES = 'users_types';
  // static const String CATEGORIES = 'categories';
  // static const String PRODUCTS = 'products';
  // static const String INVOICES = 'invoices';
  // static const String SALESMAN = 'salesman';
  // static const String APP_SETTINGS = 'app_settings';
  // static const String PRODUCT_PRICES = 'product_prices';
  // static const String CUSTOMER_GROUPS = 'customer_groups';
  // static const String CUSTOMER = 'customer';
  // static const String ORDER_MASTER = 'order_master';
  // static const String ORDER_DETAIL = 'order_detail';

  static const String _users = 'users';
  static const String _userTypes = 'users_types';
  static const String _categories = 'categories';
  static const String _products = 'products';
  static const String _invoices = 'invoices';
  static const String _salesman = 'salesman';
  static const String _appSettings = 'app_settings';
  static const String _productPrices = 'product_prices';
  static const String _customerGroups = 'customer_groups';
  static const String _customer = 'customer';
  static const String _orderMaster = 'order_master';
  static const String _orderDetail = 'order_detail';
  static const List<String> tables = [
    _users,
    _userTypes,
    _categories,
    _products,
    _invoices,
    _salesman,
    _appSettings,
    _productPrices,
    _customerGroups,
    _customer,
    _orderMaster,
    _orderDetail
  ];
}
