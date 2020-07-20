import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sales_force/applicationTheme.dart';
import 'package:sales_force/config.dart';
import 'package:sales_force/library.dart';
import 'package:sales_force/objects/visit.dart';
import 'package:sales_force/pages/pickCustomer.dart';
import 'package:sales_force/pages/settings_page.dart';
import 'package:sales_force/pages/viewVisits.dart';
import 'package:sales_force/services/serviceControl.dart';
import 'package:sales_force/sql/dal.dart';
import 'package:sales_force/sql/selectQueries.dart';

class Dashboard extends StatefulWidget {
  static String email;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  ProgressDialog progressDialog;

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () {
                  if (DAL.serviceCtrl != null) {
                    DAL.serviceCtrl.invoiceService.stop();
                    DAL.serviceCtrl.locationService.stop();
                    DAL.serviceCtrl.orderService.stop();
                    DAL.serviceCtrl.visitService.stop();
                    DAL.serviceCtrl.syncService.stop();
                    DAL.serviceCtrl = null;
                  }
                  SystemNavigator.pop();
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    double buttonLabelFontSize = 14.0;
    progressDialog = AppTheme.showProgressDialog(context);
    initServices();
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: Colors.grey[600],
          appBar: AppBar(
            title: Text('SALE FORCE'),
            actions: <Widget>[
              PopupMenuButton<String>(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(20.0))),
                  icon: Icon(Icons.more_vert),
                  onSelected: choice,
                  itemBuilder: (BuildContext context) {
                    return choices.map((String choice) {
                      return PopupMenuItem(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  })
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/salesPattern1.jpg'),
                    repeat: ImageRepeat.repeat)),
            child: GridView.count(
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              children: <Widget>[
                RaisedButton(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: Colors.white,
                  onPressed: () async {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new PickCustomer(
                                  loadFor: 'newSale',
                                )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Image(
                            image: AssetImage('images/newSale2.png'),
                          ),
                        ),
                        AutoSizeText(
                          'NEW SALE',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: buttonLabelFontSize),
                        ),
                      ],
                    ),
                  ),
                ),
                RaisedButton(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) =>
                                new PickCustomer(loadFor: 'viewSale')));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Image(
                            image: AssetImage('images/viewSale.png'),
                          ),
                        ),
                        Text(
                          'VIEW SALE',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: buttonLabelFontSize),
                        ),
                      ],
                    ),
                  ),
                ),
                RaisedButton(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pushNamed(context, '/invoices');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Image(
                            image: AssetImage('images/viewInvoices.png'),
                          ),
                        ),
                        AutoSizeText(
                          'INVOICES',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: buttonLabelFontSize),
                        ),
                      ],
                    ),
                  ),
                ),
                RaisedButton(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: Colors.white,
                  onPressed: () {
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
                                createdOn: DateTime.parse(e['createdon']),
                                isUploaded: value));
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
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Image(
                            image: AssetImage('images/viewLocation.png'),
                          ),
                        ),
                        AutoSizeText(
                          'VIEW VISIT',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: buttonLabelFontSize),
                        ),
                      ],
                    ),
                  ),
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) =>
                                new PickCustomer(loadFor: 'registerVisit')));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Image(
                            image: AssetImage('images/visits.png'),
                          ),
                        ),
                        AutoSizeText(
                          'NEW VISIT',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: buttonLabelFontSize),
                        ),
                      ],
                    ),
                  ),
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: Colors.white,
                  onPressed: () {
                    progressDialog.show();
                    Library.updateData();
                    Timer(Duration(seconds: 5), () => progressDialog.hide());
                    Future.delayed(Duration(seconds: 15)).whenComplete(
                        () => Library.login(DAL.currentUser.email));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Image(
                            image: AssetImage('images/sync.png'),
                          ),
                        ),
                        AutoSizeText(
                          'SYNC',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: buttonLabelFontSize),
                        ),
                      ],
                    ),
                  ),
                ),
//                RaisedButton(
//                  onPressed: () {
//                    Library.getDatabase().then((value) => value
//                        .rawQuery("select * from product_prices where customer_group_id = '5' and product_id = '1'", [])
//                        .then((value) => (value.forEach((element) {
//                              print(element);
//                            }))));
////                  print('Height ${Config.deviceDisplayHeight}');
////                  print('Width ${Config.deviceDisplayWidth}');
//                  },
//                  child: AppTheme.text(text: 'Query'),
//                ),
              ],
            ),
          ),
        ));
  }

  initServices() async {
    if (DAL.serviceCtrl == null) DAL.serviceCtrl = new ServiceControl();
    DAL.serviceCtrl.invoiceService.start();
    DAL.serviceCtrl.locationService.start();
    DAL.serviceCtrl.orderService.start();
    DAL.serviceCtrl.visitService.start();
    DAL.serviceCtrl.syncService.start();
  }

  static const String settings = 'Settings';
  static const String logout = 'Logout';
  static const String update = 'Update';
  static const List<String> choices = <String>[logout, settings, update];

  choice(String choice) {
    if (choice == logout) {
      if (DAL.serviceCtrl != null) {
        DAL.serviceCtrl.invoiceService.stop();
        DAL.serviceCtrl.locationService.stop();
        DAL.serviceCtrl.orderService.stop();
        DAL.serviceCtrl.visitService.stop();
        DAL.serviceCtrl.syncService.stop();
        DAL.serviceCtrl = null;
      }
      Library.logout(DAL.currentUser.user_id);
      Navigator.pushReplacementNamed(context, '/');
    } else if (choice == settings) {
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (BuildContext context) => new SettingsView()));
    } else if (choice == update) {
      progressDialog.show();
      Library.updateData();
      Timer(Duration(seconds: 5), () => progressDialog.hide());
      Future.delayed(Duration(seconds: 15))
          .whenComplete(() => Library.login(DAL.currentUser.email));
    }
  }
}
