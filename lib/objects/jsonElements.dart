import 'dart:convert';

import 'package:http/http.dart';
import 'package:sales_force/config.dart';

class JSONInvoice {
  String androidPaymentId;
  String paymentUserId;
  String paymentOrderId;
  String paymentInvoiceId;
  String paymentCustomerId;
  String paymentAmount;
  String paymentMode;
  String paymentChequeNo;
  String paymentClearingDate;
  String paymentBankName;
  String dateAdded;

  String customerName;
  String invoiceNumber;
  String date;
  String amountReceived;
  String discount;
  String totalAmount;
  String paidAmount;

  JSONInvoice(
      {this.androidPaymentId,
      this.paymentUserId,
      this.paymentOrderId,
      this.paymentInvoiceId,
      this.paymentCustomerId,
      this.paymentAmount,
      this.paymentMode,
      this.paymentChequeNo,
      this.paymentClearingDate,
      this.paymentBankName,
      this.dateAdded,
      this.customerName,
      this.invoiceNumber,
      this.date,
      this.amountReceived,
      this.discount,
      this.totalAmount,
      this.paidAmount});

  List<String> getList() {
    List<String> list = [
      this.paymentUserId == null ? "" : this.paymentUserId,
      this.paymentOrderId == null ? "" : this.paymentOrderId,
      this.paymentInvoiceId == null ? "" : this.paymentInvoiceId,
      this.paymentCustomerId == null ? "" : this.paymentCustomerId,
      this.amountReceived == null ? "" : this.amountReceived,
      this.paymentMode == null ? "" : this.paymentMode,
      this.paymentChequeNo == null ? "" : this.paymentChequeNo,
      this.paymentClearingDate == null ? "" : this.paymentClearingDate,
      this.paymentBankName == null ? "" : this.paymentBankName,
      this.dateAdded == null ? "" : this.dateAdded
    ];
    return list;
  }

  upload() {
    _stabilize();

    Map<String, String> data = {
      'android_payment_id': this.androidPaymentId,
      'payment_user_id': this.paymentUserId,
      'payment_order_id': this.paymentOrderId,
      'payment_invoice_id': this.paymentInvoiceId,
      'payment_customer_id': this.paymentCustomerId,
      'payment_amount': this.paymentAmount,
      'payment_mode': this.paymentMode,
      'payment_cheque_no': this.paymentChequeNo,
      'payment_clearing_date': this.paymentClearingDate,
      'payment_bank_name': this.paymentBankName,
      'date_added': this.dateAdded
    };

    String body = json.encode(data);
    Future<Response> future =
        post(Config.putInvoiceAPILink, headers: data, body: body);
    future.then((onValue) {
      Map response = jsonDecode(onValue.body);
      print('>>>ENTRY INVOICE UPLOAD');
      print('STATUS CODE: ${onValue.statusCode}');
      print('STATUS: ${response['status']}');
      print('MESSAGE: ${response['message']}');
      print('DATA: ${response['data']}');
      print('>>>EXIT INVOICE UPLOAD');
    });
  }

  _stabilize() {
    this.androidPaymentId =
        this.androidPaymentId == null ? '' : this.androidPaymentId;
    this.paymentUserId = this.paymentUserId == null ? '' : this.paymentUserId;
    this.paymentOrderId =
        this.paymentOrderId == null ? '' : this.paymentOrderId;
    this.paymentInvoiceId =
        this.paymentInvoiceId == null ? '' : this.paymentInvoiceId;
    this.paymentCustomerId =
        this.paymentCustomerId == null ? '' : this.paymentCustomerId;
    this.paymentAmount = this.paymentAmount == null ? '' : this.paymentAmount;
    this.paymentMode = this.paymentMode == null ? '' : this.paymentMode;
    this.paymentChequeNo =
        this.paymentChequeNo == null ? '' : this.paymentChequeNo;
    this.paymentClearingDate =
        this.paymentClearingDate == null ? '' : this.paymentClearingDate;
    this.paymentBankName =
        this.paymentBankName == null ? '' : this.paymentBankName;
    this.dateAdded = this.dateAdded == null ? '' : this.dateAdded;
  }
}

class JSONGPSCoordinates {
  String long;
  String lat;
  String time;
}
