import 'package:flutter/material.dart';
import 'package:sales_force/objects/cart.dart';
import 'package:sales_force/shared/app_theme.dart';
import 'package:sales_force/shared/library.dart';
import 'package:sales_force/sql/dal.dart';

class FinalOrder extends StatelessWidget {
  final Cart cart;
  final double titleFontSize = 18;
  final double rowSpacing = 8.0;

  FinalOrder({this.cart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Confirm Order')),
      body: Column(
        children: <Widget>[
          AppTheme.card(
              child: Column(children: <Widget>[
            Row(children: <Widget>[
              Expanded(
                  child: AppTheme.text(
                      text: 'Customer:', fontSize: titleFontSize)),
              AppTheme.text(
                  text: '${cart.customer.getName().toString().toUpperCase()}',
                  fontSize: titleFontSize)
            ]),
            SizedBox(height: rowSpacing),
            Row(children: <Widget>[
              Expanded(
                  child: AppTheme.text(
                      text: 'Order Amount', fontSize: titleFontSize)),
              AppTheme.text(
                  text: 'Rs:${cart.getAmountBeforeDiscount()}',
                  fontSize: titleFontSize)
            ]),
            SizedBox(height: rowSpacing),
            Row(children: <Widget>[
              Expanded(
                  child: AppTheme.text(
                      text: 'Discount:', fontSize: titleFontSize)),
              AppTheme.text(
                  text: '${cart.getDiscount()}', fontSize: titleFontSize)
            ]),
            SizedBox(height: rowSpacing),
            Row(children: <Widget>[
              Expanded(
                  child: AppTheme.text(
                      text: 'Discounted Amount:', fontSize: titleFontSize)),
              AppTheme.text(
                  text: 'Rs:${cart.getDiscountedAmount()}',
                  fontSize: titleFontSize)
            ]),
            SizedBox(height: rowSpacing),
            Row(children: <Widget>[
              Expanded(
                  child: AppTheme.text(
                      text: 'Receivable:',
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold)),
              AppTheme.text(
                  text: 'Rs:${cart.getAmountAfterDiscount()}',
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold)
            ]),
            SizedBox(height: rowSpacing),
            Expanded(
                flex: 0,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: cart.products.length,
                    itemBuilder: (BuildContext context, int index) =>
                        getWidget(context, index)))
          ])),
          Center(
              child: AppTheme.roundRaisedButton(
                  text: 'Take Order',
                  onPressed: () {
                    DAL.staticDal.addOrder(cart);
                    AppTheme.showAlertDialog(context,
                        title: 'Success',
                        content: Text('Order Saved'),
                        onPressed: () => Library.resetViewToDashBoard(context));
                  }))
        ],
      ),
    );
  }

  Widget getWidget(BuildContext context, int index) {
    return ListTile(
      title: AppTheme.text(text: cart.products[index].product_title),
      subtitle: AppTheme.text(
          text:
              'Quantity: ${cart.products[index].quantity}\nFOC Quantity: ${cart.products[index].focQuantity}'),
      isThreeLine: true,
    );
  }
}
