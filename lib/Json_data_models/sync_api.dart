import 'dart:convert';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:sales_force/models/data_lists.dart';
import 'package:sales_force/models/sync_packet.dart';
import 'package:sales_force/shared/library.dart';
import 'package:sales_force/sql/dal.dart';
import 'package:sales_force/sql/import_data.dart';
import 'package:sales_force/shared/config.dart';

class ApiSync {
  Logger log = Config.log;

  ApiSync() {
    init();
  }

  void init() async {
    try {
      DateTime dateTime = DateTime.now();
      dateTime = new DateTime(dateTime.year, dateTime.month, dateTime.day - 1);
      String url =
          '${Config.syncAPILink}${DateFormat('yyyy-MM-dd,HH:mm:ss').format(dateTime)}';
      //String url = '${Config.syncAPILink}${DateFormat('yyyy-MM-dd,HH:mm:ss').format(dateTime)}';
      bool hasServerAccess = await Library.hasServerAccess();
      if (hasServerAccess) {
        get(url).then((response) {
          if (response.statusCode == 200) {
            Map<String, dynamic> data = jsonDecode(response.body);
            // String status = data['status'];
            // String message = data['message'];
            //log.v('SERVER REPLY\nSTATUS: $status\nMESSAGE: $message');
            getList(data['data']);
            ImportToDB('SYNCAPI');
          }
        }).catchError((onError) => log.e('ERROR ON API SYNC', [onError]));
      }
    } catch (e) {
      log.e('ERROR ON API SYNC', [e]);
    }
  }

  void getList(List<dynamic> i) {
    try {
      DataLists.listSyncPackets = [];
      i.forEach((e) {
        DataLists.listSyncPackets.add(new SyncPacket(
            serverId: e['sync_id'],
            module: e['sync_module'],
            operation: e['sync_operation'],
            url:
                '${Config.apiPrefix}${e['sync_service']}&user=${DAL.currentUser.user_id}',
            createdOn: e['createdon']));
      });
    } catch (e) {
      log.e('ERROR ON ApiSync getList', [e]);
    }
  }
}
