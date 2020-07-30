import 'package:flutter/material.dart';
import 'package:sales_force/shared/app_theme.dart';
import 'package:sales_force/shared/library.dart';

class SqlView extends StatefulWidget {
  @override
  _SqlViewState createState() => _SqlViewState();
}

bool applyNewLine = false;
bool capsColumnNames = false;

class _SqlViewState extends State<SqlView> {
  final _textEditingController = TextEditingController();
  List<Map<String, dynamic>> result = [];
  bool check1 = false;
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
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: <Widget>[
              RaisedButton(
                child: Text('New Line'),
                onPressed: () {
                  setState(() {
                    applyNewLine = !applyNewLine;
                  });
                },
              ),
              RaisedButton(
                child: Text('Caps Columns'),
                onPressed: () {
                  setState(() {
                    capsColumnNames = !capsColumnNames;
                  });
                },
              )
            ],
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
          title: Text(styleColumns(result[index])),
        ),
      ),
    );
  }

  String styleColumns(Map<String, dynamic> map) {
    String string = '';
    String newLine = '';
    if (applyNewLine) newLine = '\n';
    map.forEach((key, value) {
      if (capsColumnNames) {
        string += '${key.toUpperCase()}: $value$newLine ';
      } else {
        string += '$key: $value$newLine ';
      }
    });
    return string;
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }
}
