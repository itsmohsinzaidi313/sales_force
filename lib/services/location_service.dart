import 'dart:async';
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'file:///C:/Users/imoss/OneDrive/Documents/Projects/Flutter/sales_force/lib/shared/config.dart';
import 'file:///C:/Users/imoss/OneDrive/Documents/Projects/Flutter/sales_force/lib/shared/library.dart';
import 'package:sales_force/services/common.dart';
import 'package:sales_force/sql/dal.dart';

class SPostLocation extends ServiceCommon {
  SPostLocation() {
    pauseDuration(seconds: 10);
    initiate();
  }
  @override
  String get name => 'Location Service';

  @override
  Future<void> perform() async {
    log.i('LOCATION SERVICE RESPONDING');
    uploadLocation();
  }

  uploadLocation() async {
      Position position1 = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      Position position2 = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Map<String, String>> list = [];
      list.add({'user_id': '${DAL.currentUser.user_id}'});

      Map<String, String> x1 = new Map();
      x1['long'] = '${position1.longitude}';
      x1['time'] = '${Library.getDateTime()}';
      x1['lat'] = '${position1.latitude}';

      Map<String, String> x2 = new Map();
      x2['long'] = '${position2.longitude}';
      x2['time'] = '${Library.getDateTime()}';
      x2['lat'] = '${position2.latitude}';

      Map<String, String> x3 = new Map();
      String a = jsonEncode('user_id');
      String b = jsonEncode('GpsCoordinate');
      x3['$a'] = '${jsonEncode(DAL.currentUser.user_id)}';
      x3['$b'] = '${[jsonEncode(x1), jsonEncode(x2)]}';

      await Library.uploadToServer(Config.putTrackingAPILink,
          jsonString: x3.toString());
  }
}
