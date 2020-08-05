import 'package:sales_force/shared/library.dart';
import 'package:sales_force/testing/column.dart';
import 'package:sales_force/testing/columnTypes.dart';
import 'package:sales_force/testing/table.dart';

class DBINIT {
  static const List<Table> tablesList = [];
  static const List<String> _tableLists = [
    Table.USERS,
    Table.USERS_TYPES,
    Table.CATEGORIES,
    Table.PRODUCTS,
    Table.INVOICES,
    Table.SALESMAN,
    Table.APP_SETTINGS,
    Table.PRODUCT_PRICES,
    Table.CUSTOMER_GROUPS,
    Table.CUSTOMER,
    Table.ORDER_MASTER,
    Table.ORDER_DETAIL,
  ];

  static const List<List<String>> _columnsList = [
    Column.USERS,
    Column.USERSTYPES,
    Column.CATEGORIES,
    Column.PRODUCTS,
    Column.PRODUCTPRICES,
    Column.INVOICES,
    Column.SALESMAN,
    Column.APP_SETTINGS,
    Column.CUSTOMER_GROUPS,
    Column.CUSTOMER,
    Column.ORDER_MASTER,
    Column.ORDER_DETAIL,
  ];

  static const List<List<String>> _listColumnTypes = [
    ColumnTypes.USERS,
    ColumnTypes.USERSTYPES,
    ColumnTypes.CATEGORIES,
    ColumnTypes.PRODUCTS,
    ColumnTypes.PRODUCTPRICES,
    ColumnTypes.INVOICES,
    ColumnTypes.SALESMAN,
    ColumnTypes.APP_SETTINGS,
    ColumnTypes.CUSTOMER_GROUPS,
    ColumnTypes.CUSTOMER,
    ColumnTypes.ORDER_MASTER,
    ColumnTypes.ORDER_DETAIL,
  ];

  DBINIT() {
    for (int i = 0; i < _tableLists.length; i++) {
      tablesList.add(
        new Table(
            name: _tableLists[i],
            columns: _columnsList[i],
            types: _listColumnTypes[i]),
      );
    }
    Library.getDatabase()
        .then((value) => value.execute(tablesList[0].getCreateTableQuery()));
  }
}
