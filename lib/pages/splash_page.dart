import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sales_force/pages/login_page.dart';
import 'package:sales_force/shared/app_theme.dart';
import 'package:sales_force/shared/config.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  navigateToLogin() {
    Navigator.of(context)
        .pushReplacement(new MaterialPageRoute(builder: (context) => Login()));
  }

  Timer loadLoginView() {
    return Timer(Duration(seconds: Config.splashTimeOut), navigateToLogin);
  }

  @override
  void initState() {
    super.initState();
    loadLoginView();
  }

  @override
  Widget build(BuildContext context) {
    double number = Config.deviceDisplayHeight(context) *
        Config.deviceDisplayWidth(context) *
        0.000004;
    print('Area: $number');
    return Container(
      color: AppTheme.ddfColor,
      child: Stack(
        children: [
          Positioned(
            child: Center(
                heightFactor: 3.5, child: Image.asset('images/icon2.jpg')),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'images/devaj_logo_small.png',
              scale: number,
            ),
          ),
          Positioned(
            // top: Config.deviceDisplayHeight(context) * 0.5,
            left: Config.deviceDisplayWidth(context) * 0.46,
            bottom: Config.deviceDisplayHeight(context) * 0.3,
            child: Center(
              child: SpinKitCircle(
                color: Colors.purple,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
