import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sales_force/models/customer.dart';
import 'view_sale_detail_page.dart';
import 'package:sales_force/sql/dal.dart';
import 'package:sales_force/shared/app_theme.dart';

class ViewSales extends StatefulWidget {
  final Customer customer;
  final List<Map<String, dynamic>> record;

  ViewSales({this.customer, this.record});

  @override
  _ViewSalesState createState() =>
      _ViewSalesState(customer: customer, record: record);
}

class _ViewSalesState extends State<ViewSales> {
  Customer customer;
  List<Map<String, dynamic>> record;

  _ViewSalesState({this.customer, this.record});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text('View Sales')),
      body: Container(
        color: AppTheme.backgroundColor,
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //         image: AssetImage(AppTheme.backgroundImage),
        //         repeat: ImageRepeat.repeat)),
        child: ListView(
          children: getSalesRecordWidget(),
        ),
      ),
    );
  }

  List<Widget> getSalesRecordWidget() {
    List<Widget> widgets = [];

    record.forEach((e) {
      Icon icon;
      if (e['order_status'] == '1')
        icon = Icon(
          Icons.check,
          color: Colors.green,
        );
      else
        icon = Icon(
          Icons.close,
          color: Colors.red,
        );

      widgets.add(GestureDetector(
        onTap: () {
          Future<dynamic> future = DAL.staticDal
              .getDetailSalesRecord(masterId: e['order_android_id'].toString());
          future.then((onValue) {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new ViewSaleDetail(
                          detailRecord: onValue,
                        )));
          });
        },
        child: Card(
          child: Container(
            height: 150,
            child: Column(
              children: <Widget>[
//                Positioned(
//                  top: 0.0,
//                  left: 0.0,
//                  child: ListTile(title: Text('Date:',
//                    style: AppTheme.textStyle(fontSize: 24)),
//                  subtitle: Text('${e['createdon']}',
//                      style: AppTheme.textStyle(fontSize: 18)),),),
//                Positioned(
//                  bottom: 0.0,
//                  left: 0.0,
//                  child: ListTile(title: Text('Receivable:',
//                      style: AppTheme.textStyle(fontSize: 24)), subtitle: Text('${e['order_total']}',
//                      style: AppTheme.textStyle(fontSize: 18))),
//                ),
                ListTile(
                  title: Text('Date:', style: AppTheme.textStyle(fontSize: 24)),
                  subtitle: Text('${e['createdon']}',
                      style: AppTheme.textStyle(fontSize: 18)),
                  trailing: Icon(Icons.info, color: Colors.grey),
                ),
                ListTile(
                  title: Text('Receivable:',
                      style: AppTheme.textStyle(fontSize: 24)),
                  subtitle: Text('${e['order_total']}',
                      style: AppTheme.textStyle(fontSize: 18)),
                  trailing: icon,
//                Row(children: <Widget>[
//                  Expanded(
//                      child: ),
//
//                ]),
//              ListTile(title: Text('Before Discount:',
//                  style: AppTheme.textStyle(fontSize: 24)), subtitle: Text(
//                '${e['order_amount']}',
//                style: AppTheme.textStyle(fontSize: 18),
//              ),),
//                Row(children: <Widget>[
//                  Expanded(
//                      child: Text('Before Discount:',
//                          style: AppTheme.textStyle(fontSize: 24))),
//                  Text(
//                    '${e['order_amount']}',
//                    style: AppTheme.textStyle(fontSize: 24),
//                  )
//                ]),
//                ListTile(title: Text('Discount:',
//                          style: AppTheme.textStyle(fontSize: 24)), subtitle: Text('${e['order_discount']}',
//                      style: AppTheme.textStyle(fontSize: 18)),),
//                Row(children: <Widget>[
//                  Expanded(
//                      child: Text('Discount:',
//                          style: AppTheme.textStyle(fontSize: 24))),
//                  Text('${e['order_discount']}',
//                      style: AppTheme.textStyle(fontSize: 24))
//                ]),

//                Row(children: <Widget>[
//                  Expanded(
//                      child: Text('Receivable:',
//                          style: AppTheme.textStyle(fontSize: 24))),
//                  Text('${e['order_total']}',
//                      style: AppTheme.textStyle(fontSize: 24))
//                ]),
//                Row(children: <Widget>[
//                  Expanded(
//                      child: Text('Order Status:',
//                          style: AppTheme.textStyle(fontSize: 24))),
//                  Text('${e['order_status']}',
//                      style: AppTheme.textStyle(fontSize: 24))
//                ]),
                )
              ],
            ),
          ),
        ),
      ));
    });
    if (widgets.length == 0)
      widgets.add(Card(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: AppTheme.text(
              text: 'No Data Found.',
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ));
    return widgets;
  }
}
