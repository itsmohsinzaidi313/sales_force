import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:logger/logger.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sales_force/models/user.dart';
import 'package:sales_force/shared/app_theme.dart';
import 'package:sales_force/shared/library.dart';
import 'package:sales_force/pages/dashboard_page.dart';
import 'package:sales_force/services/service_control.dart';
import 'package:sales_force/sql/dal.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sales_force/shared/config.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  String email, password;
  ProgressDialog progressDialog;
  Logger _log = Config.log;
  User user;

  @override
  void initState() {
    super.initState();
    Library.hasDatabase().then((dbExists) {
      if (dbExists)
        Library.getLoggedInUser().then((user) {
          setState(() {
            // DAL.currentUser = user;
            this.user = user;
          });
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (DAL.serviceCtrl == null) DAL.serviceCtrl = new ServiceControl();
    progressDialog = AppTheme.showProgressDialog(context, isDismissible: false);
    getDatabasesPath().then((onValue) => Config.DATABASES_PATH = onValue);

    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            PopupMenuButton<String>(
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(20.0))),
                icon: Icon(Icons.more_vert),
                onSelected: choiceAction,
                itemBuilder: (BuildContext context) {
                  return choices.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                })
          ],
          elevation: 10.0,
          title: Text('Login'),
        ),
        body: Container(
          color: AppTheme.backgroundColor,
          // decoration: BoxDecoration(
          //     image: DecorationImage(
          //         image: AssetImage(AppTheme.backgroundImage),
          //         repeat: ImageRepeat.repeat)),
          child: ListView(
            children: <Widget>[
              Container(
                  child: Column(
                children: <Widget>[
                  loginViewController(),
                ],
              ))
            ],
          ),
        ));
  }

  Widget loginViewController() {
    Image logo = Image.asset('images/icon2.jpg');
    if (this.user != null) {
      return Center(
        heightFactor: MediaQuery.of(context).size.height * 0.0018,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Card(
            elevation: 10.0,
            child: Padding(
              padding: EdgeInsets.only(top: 50),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.03),
                    child: logo,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Center(
                        child: AppTheme.text(
                            text: '${this.user.email}',
                            fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Center(
                        child: AppTheme.roundRaisedButton(
                            text: 'Sign in',
                            onPressed: () {
                              progressDialog.show();
                              Library.loadUserData(this.user.email);
                              Library.login(this.user.email);
                              progressDialog.hide();
                              Navigator.of(context).pushAndRemoveUntil(
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        new Dashboard(this.user)),
                                (Route<dynamic> route) => false,
                              );
                            })),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    } else
      return Center(
        heightFactor: MediaQuery.of(context).size.height * 0.0018,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 40),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.02),
                      child: logo,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Email',
                          icon: Icon(
                            Icons.mail,
                            color: Colors.grey[600],
                          )),
                      validator: (value) =>
                          value.isEmpty ? 'Enter email' : null,
                      onSaved: (value) => email = value.trim(),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Password',
                          icon: Icon(
                            Icons.lock,
                            color: Colors.grey[600],
                          )),
                      validator: (value) =>
                          value.isEmpty ? 'Enter password' : null,
                      onSaved: (value) => password = value.trim(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        color: Colors.blue,
                        child: Text(
                          'Sign in',
                          style: TextStyle(color: Colors.white, fontSize: 25.0),
                        ),
                        onPressed: loginProcedure,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  }

  loginProcedure() {
    Library.hasDatabase().then((dbExists) {
      if (dbExists) {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          String username = email;
          String key = password;
          progressDialog.show();

          Library.validateUser(username, key).then((value) {
            progressDialog.hide();
            if (value) {
              DAL.staticDal = new DAL(email: username);
              // Navigator.pushReplacementNamed(context, '/dashboard');
              Library.getUser(username)
                  .then((value) => Navigator.of(context).pushAndRemoveUntil(
                        new MaterialPageRoute(
                            builder: (context) => new Dashboard(value)),
                        (Route<dynamic> route) => false,
                      ));
            } else {
              AppTheme.showAlertDialogOK(context,
                  title: 'Attention',
                  message: 'Invalid email\\password.\nPlease try again.',
                  onOK: () => Navigator.pop(context));
            }
          }).catchError((onError) {
            progressDialog.hide();
            _log.e('ERROR ON LOGIN loginProcedure', [onError]);
          });
        }
      } else {
        AppTheme.showDialogBox(context,
            title: 'Attention',
            message: 'Please download data first.',
            buttons: <FlatButton>[
              FlatButton(
                  child: AppTheme.text(text: 'OK', color: Colors.blue),
                  onPressed: () => Navigator.pop(context)),
              FlatButton(
                  child: AppTheme.text(text: 'Download', color: Colors.blue),
                  onPressed: () {
                    download();
                    Timer(Duration(seconds: 10), () => Navigator.pop(context));
                  })
            ]);
      }
    });
  }

  static const List<String> choices = [
    Download, /*Update*/
  ];
  static const String Download = 'Download';

//  static const String Update = 'Update';

  void choiceAction(String choice) {
    if (choice == Download) {
      Library.hasServerAccess().then((value) {
        if (value) {
          download();
        } else {
          AppTheme.showAlertDialogOK(context,
              title: 'Attention',
              message: 'Please connect to internet',
              onOK: () => Navigator.pop(context));
        }
      }).catchError((onError) {
        if (onError is SocketException)
          AppTheme.showAlertDialogOK(context,
              title: 'Attention',
              message: 'Please connect to internet',
              onOK: () => Navigator.pop(context));
        else
          AppTheme.showAlertDialogOK(context,
              title: 'Attention',
              message: 'An error has occured.\n${onError.toString()}',
              onOK: () => Navigator.pop(context));
      });
    }
    /*else if (choice == Update) {
      Library.hasServerAccess().then((value) {
        if (value) {
          progressDialog.show();
          Library.updateData();
          Timer(Duration(seconds: 10), () => progressDialog.hide());
        } else {
          AppTheme.showAlertDialogOK(context,
              title: 'Attention',
              message: 'Please connect to internet',
              onOK: () => Navigator.pop(context));
        }
      });
    }*/
  }

  download() {
    progressDialog.show();
    Library.firstRun();
    Timer(Duration(seconds: 10), () => progressDialog.hide());
  }
}
