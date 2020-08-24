import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:sales_force/shared/config.dart';
import 'package:sales_force/shared/library.dart';
import 'package:sales_force/services/common.dart';
import 'package:sales_force/sql/dal.dart';

class SPostLocation extends ServiceCommon {
  SPostLocation() {
    initiate();
  }
  @override
  String get name => 'Location Service';

  @override
  Future<void> perform() async {
    cycleComplete = false;
    log.i('LOCATION SERVICE RESPONDING');
    uploadLocation();
  }

  uploadLocation() async {
    Position position1 = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .timeout(
            Duration(
              seconds: 15,
            ),
            onTimeout: () => null);
    // Position position2 = await Geolocator()
    //     .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
    //     .timeout(
    //         Duration(
    //           seconds: 10,
    //         ),
    //         onTimeout: () => null);
    if (position1 != null) {
      List<Map<String, String>> list = [];
      list.add({'user_id': '${DAL.currentUser.user_id}'});

      Map<String, String> x1 = new Map();
      x1['long'] = '${position1.longitude}';
      x1['time'] = '${Library.getDateTime()}';
      x1['lat'] = '${position1.latitude}';

      // Map<String, String> x2 = new Map();
      // x2['long'] = '${position2.longitude}';
      // x2['time'] = '${Library.getDateTime()}';
      // x2['lat'] = '${position2.latitude}';

      Map<String, String> x3 = new Map();
      String a = jsonEncode('user_id');
      String b = jsonEncode('GpsCoordinate');
      x3['$a'] = '${jsonEncode(DAL.currentUser.user_id)}';
      x3['$b'] = '${[jsonEncode(x1)]}';
      await Library.uploadToServer(Config.putTrackingAPILink,
          jsonString: x3.toString());
    } else {
      log.w('FAULT ON uploadLocation CANNOT GET DEVICE LOCATION');
    }
    cycleComplete = true;
  }
}
