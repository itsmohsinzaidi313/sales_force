import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sales_force/models/json_elements.dart';
import 'package:sales_force/pages/invoice_payment_final_page.dart';
import 'package:sales_force/shared/app_theme.dart';
import 'package:sales_force/shared/library.dart';

//region INVOICE LIST VIEW
class InvoicePayment extends StatefulWidget {
  //region VARIABLES AND CONSTRUCTOR
  final JSONInvoice invoice;

  InvoicePayment({this.invoice});

  //endregion

  @override
  _InvoicePaymentState createState() =>
      _InvoicePaymentState(invoice: this.invoice);
}

class _InvoicePaymentState extends State<InvoicePayment> {
  //region VARIABLES AND CONSTRUCTOR
  final JSONInvoice invoice;

  _InvoicePaymentState({this.invoice});

  final chequeFormKey = GlobalKey<FormState>();
  final cashFormKey = GlobalKey<FormState>();

  String bank;
  String chequeNo;
  String chequeDate;
  String amountReceived;

  double formFieldWidth = 500;

  static const String firstText = 'customer name:';
  static const String secondText = 'invoice number:';
  static const String thirdText = 'received amount:';
  static const String forthText = 'discount:';
  static const String fifthText = 'total amount:';
  static const String sixthText = 'paid amount:';
  static const String seventhText = 'invoice date:';

  static const double topPadding = 10.0;
  static const double bottomPadding = 20.0;
  static const double leftPadding = 10.0;
  static const double rightPadding = 10.0;

  //endregion
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Invoice Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
            leftPadding, topPadding, rightPadding, bottomPadding),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, bottomPadding),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: AppTheme.text(
                      text: firstText.toUpperCase(),
                    ),
                  ),
                  AppTheme.text(
                    text: invoice.customerName,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, bottomPadding),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: AppTheme.text(
                      text: secondText.toUpperCase(),
                    ),
                  ),
                  AppTheme.text(
                    text: invoice.invoiceNumber,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, bottomPadding),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: AppTheme.text(
                      text: thirdText.toUpperCase(),
                    ),
                  ),
                  AppTheme.text(
                    text: invoice.amountReceived,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, bottomPadding),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: AppTheme.text(
                      text: forthText.toUpperCase(),
                    ),
                  ),
                  AppTheme.text(
                    text: invoice.discount,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, bottomPadding),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: AppTheme.text(
                      text: fifthText.toUpperCase(),
                    ),
                  ),
                  AppTheme.text(
                    text: invoice.totalAmount,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, bottomPadding),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: AppTheme.text(
                      text: sixthText.toUpperCase(),
                    ),
                  ),
                  AppTheme.text(
                    text: invoice.paidAmount,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, bottomPadding),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: AppTheme.text(
                      text: seventhText.toUpperCase(),
                    ),
                  ),
                  AppTheme.text(
                    text: invoice.date,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, bottomPadding),
              child: Column(
                children: <Widget>[
                  AppTheme.roundRaisedButton(
                      text: 'Cash Payment',
                      onPressed: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new CashPayment(
                                      invoice: invoice,
                                    )));
                      }),
                  AppTheme.roundRaisedButton(
                      text: 'Cheque Payment',
                      onPressed: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new ChequePayment(
                                      invoice: invoice,
                                    )));
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //region VALIDATIONS

  String cashPaymentValidation(String value) {
    String validationMessage;
    if (value == '') {
      validationMessage = 'Cannot be empty';
    } else {
      if (double.parse(value) == 0.0) {
        validationMessage = 'Enter Amount';
      }
    }
    return validationMessage;
  }

  //region CHEQUE PAYMENT VALIDATIONS

  chequeNumberValidation(String value) {
    String validationMessage;
    validationMessage = value == '' ? 'Cannot Be Empty' : null;
    return validationMessage;
  }

  chequeDateValidation(String value) {
    String validationMessage;
    validationMessage = value == '' ? 'Cannot Be Empty' : null;
    return validationMessage;
  }

  bankNameValidation(String value) {
    String validationMessage;
    validationMessage = value == '' ? 'Cannot Be Empty' : null;
    return validationMessage;
  }

//endregion
//endregion
}
//endregion

//region CASH PAYMENT FORM

class CashPayment extends StatefulWidget {
  JSONInvoice invoice;

  CashPayment({this.invoice});

  @override
  _CashPaymentState createState() => _CashPaymentState(invoice: invoice);
}

class _CashPaymentState extends State<CashPayment> {
  final cashFormKey = GlobalKey<FormState>();
  String amountReceived;
  JSONInvoice invoice;

  _CashPaymentState({this.invoice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppTheme.appBar(title: 'Invoice Cash Payment'),
        body: SingleChildScrollView(
          child: Center(
            heightFactor: 2,
            child: SizedBox(
              height: 255,
              width: 255,
              child: Card(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Container(
                          color: Colors.blue[300],
                          padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                          child: Center(
                              child: AppTheme.text(
                                  text: 'Enter Amount',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        )),
                      ],
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 35),
                      padding: EdgeInsets.all(8.0),
                      child: showCashPayment(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  showCashPayment() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: cashFormKey,
        child: Column(
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Amount: ${this.invoice.totalAmount}'),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Amount',
                    ),
                    onSaved: (value) => amountReceived = value,
                    validator: (value) {
                      return cashPaymentValidation(value);
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: AppTheme.roundRaisedButton(
                text: 'Submit',
                onPressed: () {
                  if (cashFormKey.currentState.validate()) {
                    cashFormKey.currentState.save();
                    this.invoice.amountReceived = amountReceived;
                    this.invoice.dateAdded = Library.getDateTime();
                    double total = double.parse(this.invoice.amountReceived) +
                        double.parse(this.invoice.paidAmount);
                    if (total > double.parse(this.invoice.totalAmount) ||
                        double.parse(this.invoice.amountReceived) <= 0) {
                      AppTheme.showAlertDialogOK(context,
                          title: "Attention",
                          message: "Submitted amount is invalid.",
                          onOK: () => Navigator.pop(context));
                    } else {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new CashPaymentFinal(
                                    invoice: this.invoice,
                                  )));
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String cashPaymentValidation(String value) {
    String validationMessage;
    if (value == '') {
      validationMessage = 'Cannot be empty';
    } else {
      if (double.parse(value) == 0.0) {
        validationMessage = 'Enter Amount';
      }
    }
    return validationMessage;
  }
}

//endregion

//region CHEQUE PAYMENT Form
class ChequePayment extends StatefulWidget {
  JSONInvoice invoice;

  ChequePayment({this.invoice});

  @override
  _ChequePaymentState createState() => _ChequePaymentState(invoice: invoice);
}

class _ChequePaymentState extends State<ChequePayment> {
  JSONInvoice invoice;

  _ChequePaymentState({this.invoice});

  final chequeFormKey = GlobalKey<FormState>();

  String bank;
  String chequeNo;
  String chequeDate = "Select Date";
  String amountReceived;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppTheme.appBar(title: 'Invoice Cheque Payment'),
        body: SingleChildScrollView(
          child: Center(
            heightFactor: 1.5,
            child: SizedBox(
              height: 400,
              width: 400,
              child: Card(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Container(
                          color: Colors.blue[300],
                          padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                          child: Center(
                              child: AppTheme.text(
                                  text: 'Enter Amount',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        )),
                      ],
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 35),
                      padding: EdgeInsets.all(8.0),
                      child: showChequePayment(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  showChequePayment() {
    return Column(
      verticalDirection: VerticalDirection.down,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Form(
            key: chequeFormKey,
            child: Column(
              children: <Widget>[
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(hintText: 'Cheque Number'),
                    onSaved: (value) => chequeNo = value,
                    validator: (value) {
                      return chequeNumberValidation(value);
                    },
                  ),
                ),
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(hintText: 'Bank Name'),
                    onSaved: (value) => bank = value,
                    validator: (value) {
                      return bankNameValidation(value);
                    },
                  ),
                ),
                Container(
                    child: Row(
                  children: <Widget>[
                    Expanded(child: AppTheme.text(text: chequeDate)),
                    AppTheme.imageButton('images/calendar.png', 10,
                        onPressed: () => AppTheme.datePicker(context)
                            .then((value) => setState(() {
                                  chequeDate =
                                      DateFormat('yyyy-MM-dd').format(value);
                                }))),
                  ],
                )),
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(hintText: 'Amount'),
                    onSaved: (value) => amountReceived = value,
                    validator: (value) {
                      return paymentValidation(value);
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: AppTheme.roundRaisedButton(
                    text: 'Submit',
                    onPressed: () {
                      if (chequeFormKey.currentState.validate()) {
                        chequeFormKey.currentState.save();
                        invoice.paymentChequeNo = chequeNo;
                        invoice.paymentBankName = bank;
                        invoice.paymentClearingDate = chequeDate;
                        invoice.amountReceived = amountReceived;
                        invoice.dateAdded = Library.getDateTime();
                        double total =
                            double.parse(this.invoice.amountReceived) +
                                double.parse(this.invoice.paidAmount);
                        if (total > double.parse(this.invoice.totalAmount) ||
                            double.parse(this.invoice.amountReceived) <= 0) {
                          AppTheme.showAlertDialogOK(context,
                              title: "Attention",
                              message: "Submitted amount is invalid.",
                              onOK: () => Navigator.pop(context));
                        } else {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new ChequePaymentFinal(
                                      invoice: this.invoice)));
                        }
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  //region VALIDATIONS

  String paymentValidation(String value) {
    String validationMessage;
    if (value == '') {
      validationMessage = 'Cannot be empty';
    } else {
      if (double.parse(value) == 0.0) {
        validationMessage = 'Enter Amount';
      }
    }
    return validationMessage;
  }

  //region CHEQUE PAYMENT VALIDATIONS

  chequeNumberValidation(String value) {
    String validationMessage;
    validationMessage = value == '' ? 'Cannot Be Empty' : null;
    return validationMessage;
  }

  chequeDateValidation(String value) {
    String validationMessage;
    validationMessage = value == '' ? 'Cannot Be Empty' : null;
    return validationMessage;
  }

  bankNameValidation(String value) {
    String validationMessage;
    validationMessage = value == '' ? 'Cannot Be Empty' : null;
    return validationMessage;
  }

//endregion
//endregion
}

//endregion
