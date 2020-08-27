import 'package:sales_force/shared/library.dart';
import 'package:sales_force/testing/tables.dart';
import 'package:sqflite/sqlite_api.dart';

class Table {
  final String name;
  final List<String> columnNames;
  final List<String> types;

  const Table({this.name, this.columnNames, this.types});

  void create(Database db) async {
    db.execute(getCreateTableQuery());
  }

  void drop(Database db) {
    db.execute(getDropTableQuery());
  }

  void delete(Database db) {
    db.delete(name);
  }

  getTablesList() {
    return Tables.tables;
  }

  String getCreateTableQuery() {
    String query = 'CREATE TABLE $name (';
    for (int i = 0; i < columnNames.length; i++) {
      query += '${columnNames[i]}, ${types[i]}';
    }
    query += ');';
    return query;
  }

  String getDropTableQuery() {
    return 'DROP TABLE ${this.name}';
  }
}
