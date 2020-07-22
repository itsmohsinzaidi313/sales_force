import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sales_force/shared/app_theme.dart';
import 'package:sales_force/shared/library.dart';

class SqlView extends StatefulWidget {
  @override
  _SqlViewState createState() => _SqlViewState();
}

class _SqlViewState extends State<SqlView> {
  final _textEditingController = TextEditingController();
  String _query = "";
  List<Map<String, dynamic>> result = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTheme.appBar(title: 'SQL VIEW'),
      body: Column(
        children: <Widget>[
          ListTile(
            title: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(labelText: 'Query'),
              onSubmitted: (value) => _query = value,
            ),
            leading: IconButton(
              icon: Icon(
                Icons.check,
                color: Colors.red,
              ),
              onPressed: () {
                Library.getDatabase().then((db) {
                  db
                      .rawQuery(_textEditingController.text)
                      .then((value) => setState(() {
                            result.clear();
                            result = value;
                          }))
                      .catchError((onError) => setState(() {
                            result = [];
                            result.add({'Error': onError});
                          }));
                });
              },
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  result = [];
                });
              },
            ),
            subtitle: Text('Rows: ${result.length}'),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: result.length,
                itemBuilder: (BuildContext context, int index) =>
                    getWidget(context, index)),
          ),
        ],
      ),
    );
  }

  Widget getWidget(BuildContext context, int index) {
    return Container(
      child: Card(
        child: ListTile(
          leading: Text(
            '${index + 1}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          title: Text(result[index].toString()),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }
}
