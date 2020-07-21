import 'package:flutter/material.dart';
import 'package:sales_force/pages/dashboard_page.dart';
import 'package:sales_force/pages/invoices_page.dart';
import 'package:sales_force/pages/login_page.dart';
import 'package:sales_force/pages/pick_customer_page.dart';

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
