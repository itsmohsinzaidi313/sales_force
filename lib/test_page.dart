import 'package:flutter/material.dart';
import 'package:sales_force/pages/custom_drop_down.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HelloWorld'),
      ),
      body: Container(
        child: CustomDropdown(
          text: 'Hello World',
          key: GlobalKey(),
        ),
      ),
    );
  }
}
