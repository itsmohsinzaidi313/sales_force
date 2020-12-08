import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sales_force/models/user.dart';
import 'package:sales_force/pages/settings_page.dart';
import 'package:sales_force/pages_backend/dashboard_page_backend.dart';
import 'package:sales_force/shared/app_theme.dart';
import 'package:sales_force/shared/config.dart';
import 'package:sales_force/shared/library.dart';
import 'package:sales_force/sql/dal.dart';

class Dashboard extends StatefulWidget {
  final User _user;
  Dashboard(this._user);

  @override
  _DashboardState createState() => _DashboardState(this._user);
}

class _DashboardState extends State<Dashboard> {
  final User _user;
  _DashboardState(this._user);
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
    progressDialog = AppTheme.showProgressDialog(context);
//    initServices();
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          // backgroundColor: Colors.grey[600],
          appBar: AppBar(
            title: Text('MAIN MENU'),
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
            color: AppTheme.backgroundColor,
            // decoration: BoxDecoration(
            //     image: DecorationImage(
            //         image: AssetImage(AppTheme.backgroundImage),
            //         repeat: ImageRepeat.repeat)),
            child: GridView.count(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.08,
                  right: MediaQuery.of(context).size.width * 0.08,
                  top: 20,
                  bottom: 20),
              crossAxisCount: 2,
              crossAxisSpacing: MediaQuery.of(context).size.width * 0.05,
              mainAxisSpacing: MediaQuery.of(context).size.height * 0.05,
              children: getDashboardButtons2(),
            ),
          ),
        ));
  }

  List<Widget> getDashboardButtons() {
    DashboardBackend _backend = new DashboardBackend();
    try {
      double buttonLabelFontSize = 14.0;
      List<Widget> list = [
        RaisedButton(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: Colors.white,
          onPressed: () => _backend.newSaleButtonOnPressed(context),
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
                      color: Colors.black, fontSize: buttonLabelFontSize),
                ),
              ],
            ),
          ),
        ),
        RaisedButton(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: Colors.white,
          onPressed: () => _backend.viewSaleButtonOnPressed(context),
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
                      color: Colors.black, fontSize: buttonLabelFontSize),
                ),
              ],
            ),
          ),
        ),
        RaisedButton(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: Colors.white,
          onPressed: () => _backend.viewInvoices(context),
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
                      color: Colors.black, fontSize: buttonLabelFontSize),
                ),
              ],
            ),
          ),
        ),
        RaisedButton(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: Colors.white,
          onPressed: () => _backend.viewVisitsButtonOnPressed(context),
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
                      color: Colors.black, fontSize: buttonLabelFontSize),
                ),
              ],
            ),
          ),
        ),
        RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: Colors.white,
          onPressed: () => _backend.newVisitButtonOnPressed(context),
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
                      color: Colors.black, fontSize: buttonLabelFontSize),
                ),
              ],
            ),
          ),
        ),
        RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: Colors.white,
          onPressed: () => _backend.syncButtonOnPressed(progressDialog),
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
                      color: Colors.black, fontSize: buttonLabelFontSize),
                ),
              ],
            ),
          ),
        ),
        RaisedButton(
          color: Colors.white,
          onPressed: () => _backend.viewSqlPage(context),
          child: AppTheme.text(text: 'SQL'),
        ),
      ];

      if (this._user.user_type_id == '3') {
        // list.removeLast();
        return list;
      } else if (this._user.user_type_id == '4') {
        list.removeRange(2, 6);
        return list;
      }
      return list;
    } catch (e) {
      Config.log.e('ERROR IN BUTTONS', [e]);
      return [];
    }
  }

  List<Widget> getDashboardButtons2() {
    DashboardBackend _backend = new DashboardBackend();
    try {
      // Color newSaleButtonColor = Color.fromRGBO(251, 91, 57, 1.0);
      // Color viewSaleButtonColor = Color.fromRGBO(251, 91, 57, 1.0);
      // Color newVisitButtonColor = Color.fromRGBO(251, 91, 57, 1.0);
      // Color viewVisitButtonColor = Color.fromRGBO(251, 91, 57, 1.0);
      // Color invoiceButtonColor = Color.fromRGBO(251, 91, 57, 1.0);
      // Color syncButtonColor = Color.fromRGBO(251, 91, 57, 1.0);
      // Color sqlButtonColor = Color.fromRGBO(251, 91, 57, 1.0);
      Color redColor = Color.fromRGBO(251, 91, 57, 0.7);
      Color blueColor = Color.fromRGBO(145, 202, 245, 0.6);
      Color newSaleButtonColor = redColor;
      Color viewSaleButtonColor = Colors.white;
      Color newVisitButtonColor = redColor;
      Color viewVisitButtonColor = redColor;
      Color invoiceButtonColor = Colors.white;
      Color syncButtonColor = Colors.white;
      Color sqlButtonColor = Colors.black;

      double fontSize = 18;
      double iconSize = MediaQuery.of(context).size.width * 0.14;
      Color buttonColor = blueColor;
      // Color buttonColor = Colors.blue;
      List<Widget> list = [
        AppTheme.roundIconButton(
            text: 'NEW SALE',
            textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                // fontSize: fontSize,
                color: Colors.white),
            icon: Icon(
              Icons.add_shopping_cart,
              color: Colors.white,
            ),
            iconSize: iconSize,
            buttonColor: redColor,
            onPressed: () => _backend.newSaleButtonOnPressed(context)),
        AppTheme.roundIconButton(
            text: 'VIEW SALE',
            textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                // fontSize: fontSize,
                color: Colors.white),
            icon: Icon(
              Icons.view_headline,
              color: Colors.white,
            ),
            iconSize: iconSize,
            buttonColor: blueColor,
            onPressed: () => _backend.viewSaleButtonOnPressed(context)),
        AppTheme.roundIconButton(
            text: 'INVOICES',
            textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                // fontSize: fontSize,
                color: Colors.white),
            icon: Icon(
              Icons.assignment,
              color: Colors.white,
            ),
            iconSize: iconSize,
            buttonColor: blueColor,
            onPressed: () => _backend.viewInvoices(context)),
        AppTheme.roundIconButton(
            text: 'VIEW VISITS',
            textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                // fontSize: fontSize,
                color: Colors.white),
            icon: Icon(
              Icons.not_listed_location,
              color: Colors.white,
            ),
            iconSize: iconSize,
            buttonColor: redColor,
            onPressed: () => _backend.viewVisitsButtonOnPressed(context)),
        AppTheme.roundIconButton(
            text: 'NEW VISITS',
            textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                // fontSize: fontSize,
                color: Colors.white),
            icon: Icon(
              Icons.add_location,
              color: Colors.white,
            ),
            iconSize: iconSize,
            buttonColor: redColor,
            onPressed: () => _backend.newVisitButtonOnPressed(context)),
        AppTheme.roundIconButton(
            text: 'SYNC DATA',
            textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                // fontSize: fontSize,
                color: Colors.white),
            icon: Icon(
              Icons.sync,
              color: Colors.white,
            ),
            iconSize: iconSize,
            buttonColor: blueColor,
            onPressed: () => _backend.syncButtonOnPressed(progressDialog)),
        AppTheme.roundIconButton(
            text: 'SQLITE',
            textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                // fontSize: fontSize,
                color: Colors.white),
            icon: Icon(
              Icons.storage,
              color: Colors.white,
            ),
            iconSize: iconSize,
            buttonColor: redColor,
            onPressed: () => _backend.viewSqlPage(context)),
      ];

      if (this._user.user_type_id == '3') {
        list.removeLast();
        return list;
      } else if (this._user.user_type_id == '4') {
        list.removeRange(2, 6);
        list.removeLast();
        return list;
      }
      return list;
    } catch (e) {
      Config.log.e('ERROR IN BUTTONS', [e]);
      return [];
    }
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
