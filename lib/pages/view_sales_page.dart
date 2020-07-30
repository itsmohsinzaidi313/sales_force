import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sales_force/models/customer.dart';
import 'package:sales_force/models/product.dart';
import 'package:sales_force/sql/dal.dart';
import 'package:sales_force/shared/app_theme.dart';

class ViewSales extends StatefulWidget {
  Customer customer;
  List<Map<String, dynamic>> record;

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
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/salesPattern1.jpg'),
                repeat: ImageRepeat.repeat)),
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

class ViewSaleDetail extends StatefulWidget {
  List<Product> detailRecord;

  ViewSaleDetail({this.detailRecord});

  @override
  _ViewSaleDetailState createState() =>
      _ViewSaleDetailState(detailRecord: detailRecord);
}

class _ViewSaleDetailState extends State<ViewSaleDetail> {
  List<Product> detailRecord;
  double cardElementTextSize = 24;

  _ViewSaleDetailState({this.detailRecord});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTheme.appBar(title: 'Sale Detail'),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/salesPattern1.jpg'),
                repeat: ImageRepeat.repeat)),
        child: displayListView(detailRecord),
      ),
    );
  }

  //region LIST VIEW CODE
  List<Widget> getProductsWidget() {
    List<Widget> widgets = [];
    if (detailRecord != null) {
      for (Product value in detailRecord) {
        widgets.add(Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
//                Row(children: <Widget>[Expanded(child: AppTheme.text()), AppTheme.text()]),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: AppTheme.text(
                            text: 'Title', fontSize: cardElementTextSize)),
                    AppTheme.text(
                        text: '${value.product_title}',
                        fontSize: cardElementTextSize),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: AppTheme.text(
                            text: 'Price:', fontSize: cardElementTextSize)),
                    AppTheme.text(
                        text: '${value.product_pack_price}',
                        fontSize: cardElementTextSize),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: AppTheme.text(
                            text: 'Quantity:', fontSize: cardElementTextSize)),
                    AppTheme.text(
                        text: '${value.purchasedQuantity}',
                        fontSize: cardElementTextSize),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: AppTheme.text(
                            text: 'FOC Quantity:',
                            fontSize: cardElementTextSize)),
                    AppTheme.text(
                        text: '${value.focQuantity}',
                        fontSize: cardElementTextSize),
                  ],
                ),
                Row(children: <Widget>[
                  Expanded(
                      child: AppTheme.text(
                          text: 'Total', fontSize: cardElementTextSize)),
                  AppTheme.text(
                      text:
                          '${double.parse(value.product_pack_price) * double.parse(value.purchasedQuantity)}',
                      fontSize: cardElementTextSize)
                ]),
              ],
            ),
          ),
        ));
      }
    } else {
      widgets.add(Card(
        child: Center(child: Text('No Data')),
      ));
    }
    return widgets;
  }

  ListView displayListView(List<Product> products) {
    return ListView(
      children: getProductsWidget(),
    );
  }

  //endregion

  //region GRID VIEW CODE
  GridView displayGridView(List<Product> products) {
    return GridView.count(
      crossAxisCount: 2,
      children: getGridViewWidgets(products),
    );
  }

  List<Widget> getGridViewWidgets(List<Product> products) {
    List<Widget> list = [];
    products.forEach((element) {
      list.add(Card(
        margin: EdgeInsets.all(8.0),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Expanded(
                  child: Image.network(element.getNetworkImage(),
                      fit: BoxFit.scaleDown)),
              SizedBox(height: 8.0),
              AppTheme.text(
                  text: element.product_title, fontWeight: FontWeight.bold),
              AppTheme.text(
                  text: element.product_pack_price,
                  fontWeight: FontWeight.bold),
              AppTheme.text(
                  text: element.purchasedQuantity, fontWeight: FontWeight.bold),
            ],
          ),
        ),
      ));
    });
    if (list.length == 0)
      list.add(Container(
        child: Column(children: <Widget>[
          Center(
            child: AppTheme.text(text: 'No items to display.'),
          )
        ]),
      ));
    return list;
  }
//endregion
}
