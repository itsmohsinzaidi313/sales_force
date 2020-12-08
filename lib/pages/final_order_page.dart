import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sales_force/models/cart.dart';
import 'package:sales_force/shared/app_theme.dart';
import 'package:sales_force/shared/library.dart';
import 'package:sales_force/sql/dal.dart';

class FinalOrder extends StatefulWidget {
  final Cart cart;

  FinalOrder({this.cart});

  @override
  _FinalOrderState createState() => _FinalOrderState(cart: this.cart);
}

class _FinalOrderState extends State<FinalOrder> {
  final double titleFontSize = 18;
  final double rowSpacing = 8.0;
  final Cart cart;
  _FinalOrderState({this.cart}) {
    this.cart.spoDiscount = '0';
  }
  final TextEditingController _textEditingController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    ProgressDialog progressDialog =
        AppTheme.showProgressDialog(context, isDismissible: false);
    return Scaffold(
      appBar: AppBar(title: Text('Confirm Order')),
      body: Column(
        children: <Widget>[
          Expanded(
              child: Column(children: [
            AppTheme.card(
              child: Column(
                children: <Widget>[
                  Row(children: <Widget>[
                    Expanded(
                        child: AppTheme.text(
                            text: 'Customer: ', fontSize: titleFontSize)),
                    AppTheme.text(
                        text:
                            '${widget.cart.customer.getName().toString().toUpperCase()}',
                        fontSize: titleFontSize)
                  ]),
                  SizedBox(height: rowSpacing),
                  Row(children: <Widget>[
                    Expanded(
                        child: AppTheme.text(
                            text: 'Order Amount', fontSize: titleFontSize)),
                    AppTheme.text(
                        text: 'Rs: ${widget.cart.getAmountBeforeDiscount()}',
                        fontSize: titleFontSize)
                  ]),
                  SizedBox(height: rowSpacing),
                  Row(children: <Widget>[
                    Expanded(
                        child: AppTheme.text(
                            text: 'Customer Discount: ',
                            fontSize: titleFontSize)),
                    AppTheme.text(
                        text: '${widget.cart.getDiscount()}',
                        fontSize: titleFontSize)
                  ]),
                  SizedBox(height: rowSpacing),
                  Row(children: <Widget>[
                    Expanded(
                        child: AppTheme.text(
                            text: 'Discounted Amount: ',
                            fontSize: titleFontSize)),
                    AppTheme.text(
                        text: 'Rs: ${widget.cart.getDiscountedAmount()}',
                        fontSize: titleFontSize)
                  ]),
                  SizedBox(height: rowSpacing),
                  Row(children: <Widget>[
                    Expanded(
                        child: AppTheme.text(
                            text: 'Receivable: ',
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold)),
                    AppTheme.text(
                        text: 'Rs:${widget.cart.getAmountAfterDiscount()}',
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold)
                  ]),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.cart.products.length,
                  itemBuilder: (BuildContext context, int index) =>
                      getWidget(context, index)),
            ),
          ])),
          Column(
            children: [
              Center(
                child: AppTheme.roundRaisedButton(
                    text: 'Add Discount',
                    onPressed: () => showUserDiscountDialog()),
              ),
              Center(
                  child: AppTheme.roundRaisedButton(
                      text: 'Take Order',
                      onPressed: () {
                        progressDialog.show();
                        DAL.staticDal.addOrder(widget.cart).then((value) {
                          progressDialog.hide();
                          if (value) {
                            AppTheme.showAlertDialogOK(context,
                                title: 'Success',
                                message: 'Order Saved',
                                onOK: () =>
                                    Library.resetViewToDashBoard(context));
                          } else {
                            AppTheme.showAlertDialogOK(context,
                                title: 'Failed',
                                message:
                                    'Order request failed.\nPlease enable your location if disabled.',
                                onOK: () => Navigator.of(context).pop());
                          }
                        });
                      }))
            ],
          ),
        ],
      ),
    );
  }

  Widget getWidget(BuildContext context, int index) {
    return Column(
      children: [
        ListTile(
          title: AppTheme.text(text: widget.cart.products[index].product_title),
          subtitle: AppTheme.text(
              text:
                  'Quantity: ${widget.cart.products[index].quantity}\nFOC Quantity: ${widget.cart.products[index].focQuantity ?? '0'}'),
          isThreeLine: true,
        ),
        Divider(),
      ],
    );
  }

  void showUserDiscountDialog() {
    double discountAllowed = DAL.currentUser.discountPercent == null
        ? 0.0
        : double.parse(DAL.currentUser.discountPercent);
    _textEditingController.text = '';
    AppTheme.showAlertDialog(context,
        title: 'Add Dicount',
        content: Wrap(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[Text('Discount Limit: $discountAllowed%')],
                ),
                Row(
                  children: <Widget>[
                    Text('Discount %:'),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        controller: _textEditingController,
                        keyboardType: TextInputType.number,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
        buttons: [
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              try {
                double discountApplied = _textEditingController.text == null
                    ? 0.0
                    : double.parse(_textEditingController.text);
                discountAllowed = DAL.currentUser.discountPercent == null
                    ? 0.0
                    : double.parse(DAL.currentUser.discountPercent);
                if (discountApplied <= discountAllowed) {
                  widget.cart.spoDiscount = discountApplied.toString();
                  Navigator.of(context).pop();
                  setState(() {});
                } else
                  AppTheme.showAlertDialogOK(context,
                      title: 'Attention',
                      message: 'Discount Limit Exceded.',
                      onOK: () => Navigator.of(context).pop());
              } catch (e) {
                AppTheme.showAlertDialogOK(context,
                    title: 'Attention',
                    message: 'Please check discount value.',
                    onOK: () => Navigator.of(context).pop());
              }
            },
          ),
          FlatButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ]);
  }
}
