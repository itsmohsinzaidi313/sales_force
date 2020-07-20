class Table {
  static const String USERS = 'users';
  static const String USERS_TYPES = 'users_types';
  static const String CATEGORIES = 'categories';
  static const String PRODUCTS = 'products';
  static const String INVOICES = 'invoices';
  static const String SALESMAN = 'salesman';
  static const String APP_SETTINGS = 'app_settings';
  static const String PRODUCT_PRICES = 'product_prices';
  static const String CUSTOMER_GROUPS = 'customer_groups';
  static const String CUSTOMER = 'customer';
  static const String ORDER_MASTER = 'order_master';
  static const String ORDER_DETAIL = 'order_detail';

  String name;
  List<String> columnNames;
  List<String> types;
  List<dynamic> columns;

  Table({this.name, this.columns, this.types}) {
    columns = [];
    for (int i = 0; i < columnNames.length; i++) {
      columns.add({columnNames[i]: types[i]});
    }
  }
  getTablesList() {
    return [
      USERS,
      USERS_TYPES,
      CATEGORIES,
      PRODUCTS,
      PRODUCT_PRICES,
      INVOICES,
      SALESMAN,
      APP_SETTINGS,
      PRODUCT_PRICES,
      CUSTOMER_GROUPS,
      CUSTOMER,
      ORDER_MASTER,
      ORDER_DETAIL
    ];
  }

  String getCreateTableQuery() {
    String query = 'CREATE TABLE $name (';
    for (Map value in columns) {
      query += '${value[0][0]}, ${value[0][1]}';
    }
    query += ')';
    return query;
  }

  String getDropTableQuery() {
    return 'DROP TABLE ${this.name}';
  }
}
