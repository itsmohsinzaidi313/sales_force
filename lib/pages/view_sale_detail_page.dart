import 'package:flutter/material.dart';
import 'package:sales_force/models/product.dart';
import 'package:sales_force/shared/app_theme.dart';

class ViewSaleDetail extends StatefulWidget {
  final List<Product> detailRecord;

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
        color: AppTheme.backgroundColor,
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //         image: AssetImage(AppTheme.backgroundImage),
        //         repeat: ImageRepeat.repeat)),,
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
