import 'package:flutter/material.dart';
import 'package:sales_force/pages/dashboard.dart';
import 'package:sales_force/pages/invoices.dart';
import 'package:sales_force/pages/loginPage.dart';
import 'package:sales_force/pages/pickCustomer.dart';

void main() {
  return runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Login(),
      '/dashboard': (context) => Dashboard(),
      '/invoices': (context) => Invoices(),
      '/customersList': (context) => PickCustomer(),
    },
  ));
}
