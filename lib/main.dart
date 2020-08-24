import 'package:flutter/material.dart';
import 'package:sales_force/pages/dashboard_page.dart';
import 'package:sales_force/pages/final_order_page.dart';
import 'package:sales_force/pages/invoices_page.dart';
import 'package:sales_force/pages/login_page.dart';
import 'package:sales_force/pages/pick_customer_page.dart';
import 'package:sales_force/pages/splash_page.dart';
import 'package:sales_force/test_page.dart';

void main() {
  return runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => SplashView(),
      '/login': (context) => Login(),
      '/dashboard': (context) => Dashboard(null),
      '/invoices': (context) => Invoices(),
      '/customersList': (context) => PickCustomer(),
      '/finalOrder': (context) => FinalOrder(),
      '/testPage': (context) => TestPage(),
    },
  ));
}
