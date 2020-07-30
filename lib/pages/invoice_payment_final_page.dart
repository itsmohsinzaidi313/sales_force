import 'package:flutter/material.dart';
import 'package:sales_force/shared/app_theme.dart';
import 'package:sales_force/models/json_elements.dart';
import 'package:sales_force/sql/dal.dart';

import '../shared/library.dart';

//region CASHPAYMENT
class CashPaymentFinal extends StatefulWidget {
  //region VARIABLES AND CONSTRUCTOR
  final JSONInvoice invoice;

  CashPaymentFinal({this.invoice});

  //endregion

  @override
  _CashPaymentFinalState createState() =>
      _CashPaymentFinalState(invoice: invoice);
}

class _CashPaymentFinalState extends State<CashPaymentFinal> {
  //region VARIABLES AND CONSTRUCTOR
  final JSONInvoice invoice;

  _CashPaymentFinalState({this.invoice});

  setTextStyle() {
    return TextStyle(fontSize: 26, fontWeight: FontWeight.normal);
  }

  static const String firstText = 'customer name:';
  static const String secondText = 'invoice number:';
  static const String thirdText = 'balance amount:';
  static const String forthText = 'discount:';
  static const String fifthText = 'total amount:';
  static const String sixthText = 'paid amount:';
  static const String seventhText = 'invoice date:';
  static const String eighthText = 'received amount:';

  static const double topPadding = 5.0;
  static const double bottomPadding = 10.0;
  static const double leftPadding = 5.0;
  static const double rightPadding = 5.0;
  static const double dividerThickness = 2;
  //endregion

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Cash Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      leftPadding, topPadding, rightPadding, bottomPadding),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(secondText.toUpperCase(),
                            style: setTextStyle()),
                      ),
                      Text(invoice.invoiceNumber, style: setTextStyle()),
                    ],
                  ),
                ), // INVOICE NUMBER
                Divider(
                  thickness: dividerThickness,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      leftPadding, topPadding, rightPadding, bottomPadding),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(seventhText.toUpperCase(),
                            style: setTextStyle()),
                      ),
                      Text(invoice.dateAdded, style: setTextStyle()),
                    ],
                  ),
                ), // INVOICE DATE
                Divider(
                  thickness: dividerThickness,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      leftPadding, topPadding, rightPadding, bottomPadding),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(firstText.toUpperCase(),
                            style: setTextStyle()),
                      ),
                      Text(invoice.customerName, style: setTextStyle()),
                    ],
                  ),
                ), // CUSTOMER NAME
                Divider(
                  thickness: dividerThickness,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      leftPadding, topPadding, rightPadding, bottomPadding),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(fifthText.toUpperCase(),
                            style: setTextStyle()),
                      ),
                      Text(invoice.totalAmount, style: setTextStyle()),
                    ],
                  ),
                ), // TOTAL AMOUNT
                Divider(
                  thickness: dividerThickness,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      leftPadding, topPadding, rightPadding, bottomPadding),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(forthText.toUpperCase(),
                            style: setTextStyle()),
                      ),
                      Text(invoice.discount, style: setTextStyle()),
                    ],
                  ),
                ), // DISCOUNT
                Divider(
                  thickness: dividerThickness,
                ), // T
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      leftPadding, topPadding, rightPadding, bottomPadding),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(sixthText.toUpperCase(),
                            style: setTextStyle()),
                      ),
                      Text(invoice.paidAmount, style: setTextStyle()),
                    ],
                  ),
                ), // PAID AMOUNT
                Divider(
                  thickness: dividerThickness,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      leftPadding, topPadding, rightPadding, bottomPadding),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(thirdText.toUpperCase(),
                            style: setTextStyle()),
                      ),
                      Text(
                          (double.parse(invoice.totalAmount) -
                                  double.parse(invoice.paidAmount))
                              .toString(),
                          style: setTextStyle()),
                    ],
                  ),
                ), // BALANCE AMOUNT
                Divider(
                  thickness: dividerThickness,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      leftPadding, topPadding, rightPadding, bottomPadding),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(eighthText.toUpperCase(),
                            style: setTextStyle()),
                      ),
                      Text(
                        invoice.amountReceived,
                        style: setTextStyle(),
                      )
                    ],
                  ),
                ), // AMOUNT RECEIVED
                Divider(
                  thickness: dividerThickness,
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: AppTheme.roundRaisedButton(
                    text: 'PAY',
                    onPressed: () {
                      if (double.parse(this.invoice.amountReceived) >
                          double.parse(this.invoice.totalAmount)) {
                        AppTheme.showAlertDialogOK(context,
                            title: 'Attention',
                            message: 'Submitted amount is invalid.',
                            onOK: () => Navigator.pop(context));
                      } else {
                        this.invoice.paymentMode = 'Cash';
                        DAL.staticDal.storeInvoice(this.invoice);
                        AppTheme.showAlertDialogOK(context,
                            title: 'Success',
                            message: 'Invoice Saved',
                            onOK: () => Library.resetViewToDashBoard(context));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
//endregion

//region CHEQUE PAYMENT
class ChequePaymentFinal extends StatefulWidget {
  //region VARIABLES AND CONSTRUCTOR
  final JSONInvoice invoice;

  ChequePaymentFinal({this.invoice});

//endregion

  @override
  _ChequePaymentFinalState createState() =>
      _ChequePaymentFinalState(invoice: this.invoice);
}

class _ChequePaymentFinalState extends State<ChequePaymentFinal> {
  //region VARIABLES AND CONSTRUCTOR
  final JSONInvoice invoice;

  _ChequePaymentFinalState({this.invoice});

  setTextStyle() {
    return TextStyle(fontSize: 26, fontWeight: FontWeight.normal);
  }

  static const String firstText = 'customer name:';
  static const String secondText = 'invoice number:';
  static const String thirdText = 'amount:';
  static const String forthText = 'discount:';
  static const String fifthText = 'total amount:';
  static const String sixthText = 'paid amount:';
  static const String seventhText = 'invoice date:';
  static const String eighthText = 'cheque number:';
  static const String ninthText = 'bank:';
  static const String tenthText = 'cheque clearing date:';
  static const String eleventhText = 'received amount:';

  static const double topPadding = 0.0;
  static const double bottomPadding = 10.0;
  static const double leftPadding = 0.0;
  static const double rightPadding = 0.0;
  static const double dividerThickness = 2;

  //endregion

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Cheque Payment'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    leftPadding, topPadding, rightPadding, bottomPadding),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child:
                          Text(secondText.toUpperCase(), style: setTextStyle()),
                    ),
                    Text(invoice.invoiceNumber, style: setTextStyle()),
                  ],
                ),
              ), // INVOICE NUMBER
              Divider(
                thickness: dividerThickness,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    leftPadding, topPadding, rightPadding, bottomPadding),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(seventhText.toUpperCase(),
                          style: setTextStyle()),
                    ),
                    Text(invoice.dateAdded, style: setTextStyle()),
                  ],
                ),
              ), // INVOICE DATE
              Divider(
                thickness: dividerThickness,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    leftPadding, topPadding, rightPadding, bottomPadding),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child:
                          Text(firstText.toUpperCase(), style: setTextStyle()),
                    ),
                    Text(invoice.customerName, style: setTextStyle()),
                  ],
                ),
              ), // CUSTOMER NAME
              Divider(
                thickness: dividerThickness,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    leftPadding, topPadding, rightPadding, bottomPadding),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child:
                          Text(fifthText.toUpperCase(), style: setTextStyle()),
                    ),
                    Text(invoice.totalAmount, style: setTextStyle()),
                  ],
                ),
              ), // TOTAL AMOUNT
              Divider(
                thickness: dividerThickness,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    leftPadding, topPadding, rightPadding, bottomPadding),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child:
                          Text(forthText.toUpperCase(), style: setTextStyle()),
                    ),
                    Text(invoice.discount, style: setTextStyle()),
                  ],
                ),
              ), // DISCOUNT
              Divider(
                thickness: dividerThickness,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    leftPadding, topPadding, rightPadding, bottomPadding),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child:
                          Text(sixthText.toUpperCase(), style: setTextStyle()),
                    ),
                    Text(invoice.paidAmount, style: setTextStyle()),
                  ],
                ),
              ), // PAID AMOUNT
              Divider(
                thickness: dividerThickness,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    leftPadding, topPadding, rightPadding, bottomPadding),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child:
                          Text(thirdText.toUpperCase(), style: setTextStyle()),
                    ),
                    Text(
                        (double.parse(invoice.totalAmount) -
                                double.parse(invoice.paidAmount))
                            .toString(),
                        style: setTextStyle()),
                  ],
                ),
              ), // BALANCE
              Divider(
                thickness: dividerThickness,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    leftPadding, topPadding, rightPadding, bottomPadding),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child:
                          Text(ninthText.toUpperCase(), style: setTextStyle()),
                    ),
                    Text(invoice.paymentBankName, style: setTextStyle())
                  ],
                ),
              ), // BANK NAME
              Divider(
                thickness: dividerThickness,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    leftPadding, topPadding, rightPadding, bottomPadding),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child:
                          Text(eighthText.toUpperCase(), style: setTextStyle()),
                    ),
                    Text(invoice.paymentChequeNo, style: setTextStyle())
                  ],
                ),
              ), // CHEQUE NUMBER
              Divider(
                thickness: dividerThickness,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    leftPadding, topPadding, rightPadding, bottomPadding),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child:
                          Text(tenthText.toUpperCase(), style: setTextStyle()),
                    ),
                    Text(invoice.paymentClearingDate, style: setTextStyle())
                  ],
                ),
              ), // CHEQUE CLEARING DATE
              Divider(
                thickness: dividerThickness,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    leftPadding, topPadding, rightPadding, bottomPadding),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(eleventhText.toUpperCase(),
                          style: setTextStyle()),
                    ),
                    Text(invoice.amountReceived, style: setTextStyle()),
                  ],
                ),
              ), // RECEIVED AMOUNT
              Divider(
                thickness: dividerThickness,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    leftPadding, topPadding, rightPadding, bottomPadding),
                child: RaisedButton(
                  child: Text('PAY', style: setTextStyle()),
                  onPressed: () {
                    if (double.parse(this.invoice.paidAmount) >
                        double.parse(this.invoice.totalAmount)) {
                      AppTheme.showAlertDialogOK(context,
                          title: 'Attention',
                          message: 'Submitted amount is invalid.',
                          onOK: () => Navigator.pop(context));
                    } else {
                      this.invoice.paymentMode = 'Cheque';
                      DAL.staticDal.storeInvoice(this.invoice);
                      AppTheme.showAlertDialogOK(context,
                          title: 'Success',
                          message: 'Invoice Saved',
                          onOK: () => Library.resetViewToDashBoard(context));
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
//endregion
