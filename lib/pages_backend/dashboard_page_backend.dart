import 'dart:async';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sales_force/models/visit.dart';
import 'package:sales_force/pages/pick_customer_page.dart';
import 'package:sales_force/pages/sql_view_page.dart';
import 'package:sales_force/pages/view_visits_page.dart';
import 'package:sales_force/shared/library.dart';
import 'package:sales_force/sql/dal.dart';
import 'package:sales_force/sql/select_queries.dart';

class DashboardBackend {
  dynamic newSaleButtonOnPressed(BuildContext context) => Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) => new PickCustomer(
                loadFor: 'newSale',
              )));

  dynamic viewSaleButtonOnPressed(BuildContext context) => Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) => new PickCustomer(loadFor: 'viewSale')));

  dynamic viewVisitsButtonOnPressed(BuildContext context) {
    Library.getDatabase().then((db) async {
      db
          .rawQuery(
              "${Select.selectVisits} where user_id = ${DAL.currentUser.user_id} order by createdon desc")
          .then((list) {
        int paidId = 0;
        List<Visit> visits = [];
        list.forEach((e) {
          if (paidId != e['pair_id']) {
            bool value = e['is_upload'] == 1 ? true : false;
            visits.add(new Visit(
                createdOn: DateTime.parse(e['createdon']), isUploaded: value));
            paidId = e['pair_id'];
          } else
            paidId = e['pair_id'];
        });
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new ViewVisits(
                      visits: visits,
                    )));
      });
    });
  }

  dynamic newVisitButtonOnPressed(BuildContext context) => Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) => new PickCustomer(loadFor: 'registerVisit')));

  dynamic syncButtonOnPressed(ProgressDialog progressDialog) {
    progressDialog.show();
    Library.updateData();
    Timer(Duration(seconds: 5), () => progressDialog.hide());
    Future.delayed(Duration(seconds: 15))
        .whenComplete(() => Library.login(DAL.currentUser.email));
  }

  dynamic viewInvoices(BuildContext context) =>
      Navigator.pushNamed(context, '/invoices');

  dynamic viewSqlPage(BuildContext context) => Navigator.of(context).push(
      new MaterialPageRoute(builder: (BuildContext context) => new SqlView()));
}
