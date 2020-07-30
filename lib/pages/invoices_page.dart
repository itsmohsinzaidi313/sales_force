import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sales_force/models/customer.dart';
import 'package:sales_force/models/invoice.dart';
import 'package:sales_force/models/json_elements.dart';
import 'package:sales_force/pages/invoice_payment_page.dart';
import 'package:sales_force/sql/dal.dart';
import 'package:sales_force/shared/app_theme.dart';

class Invoices extends StatefulWidget {
  @override
  _InvoicesState createState() => _InvoicesState();
}

class _InvoicesState extends State<Invoices> {
  List<Invoice> invoices = [];
  List<Customer> customers = [];

  @override
  Widget build(BuildContext context) {
    if (invoices.length == 0) invoices.addAll(DAL.staticInvoices);
    if (customers.length == 0) customers.addAll(DAL.staticCustomers);
    return Scaffold(
        appBar: AppBar(
          title: Text("INVOICES"),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/salesPattern1.jpg'),
                  repeat: ImageRepeat.repeat)),
          child: ListView(
              children: ListTile.divideTiles(
                      tiles: invoiceView(),
                      context: context,
                      color: Colors.grey)
                  .toList()),
        ));
  }

  List<Widget> invoiceView() {
    try {
      List<Widget> widgets = [];
      for (Invoice value in invoices) {
        double invoiceAmount = double.parse(value.invoice_total_amount);
        double paidAmount = double.parse(value.invoice_paid_amount);
        Widget widget;
        if (invoiceAmount == paidAmount)
          widget = RaisedButton(
            child: AppTheme.text(text: 'PAID', color: Colors.blue),
            color: Colors.white,
            onPressed: () => false,
          );
        else
          widget = AppTheme.rectangleRaisedButton(
              text: 'PAY', onPressed: () async => onTap(value));
        widgets.add(Card(
            color: Colors.white,
            child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                isThreeLine: true,
                title: AppTheme.text(
                    text: '${getCustomerName(value.customer_id)}',
                    fontSize: 20),
                subtitle: AppTheme.text(
                    text: '${value.invoice_number}\n${value.invoice_amount}',
                    fontSize: 20),
                trailing: widget)));
      }
      if (widgets.length == 0)
        widgets.add(Card(
          color: Colors.white,
          child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              isThreeLine: true,
              title: AppTheme.text(text: 'No Invoies', fontSize: 20),
              subtitle: AppTheme.text(
                  text: 'There are no invoices to display.', fontSize: 20),
              trailing: AppTheme.rectangleRaisedButton(
                text: 'Pay',
                onPressed: () {},
              )),
        ));
      return widgets;
    } catch (e) {
      List<Widget> widgets = [];

      widgets.add(Card(
        child: Text(e.toString()),
      ));
      return widgets;
    }
  }

  onTap(Invoice invoice) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new InvoicePayment(
                invoice: new JSONInvoice(
                    androidPaymentId: invoice.invoice_id,
                    paymentUserId: invoice.user_id,
                    paymentOrderId: invoice.order_id,
                    paymentInvoiceId: invoice.invoice_id,
                    paymentCustomerId: invoice.customer_id,
                    paymentAmount: invoice.invoice_amount,
                    customerName: getCustomerName(invoice.customer_id),
                    invoiceNumber: invoice.invoice_number,
                    date: invoice.invoice_date,
                    amountReceived: "",
                    discount: invoice.invoice_discount,
                    totalAmount: invoice.invoice_total_amount,
                    paidAmount: invoice.invoice_paid_amount))));
  }

  getCustomerName(String id) {
    String name = '';
    for (Customer value in customers) {
      if (value.customerId == id) {
        name =
            value.firstName.toUpperCase() + ' ' + value.lastName.toUpperCase();
        break;
      } else {
        name = 'NO NAME';
      }
    }
    return name;
  }

  getInvoice(String invoiceId) {
    for (Invoice value in invoices) {
      if (value.invoice_id == invoiceId) {
        return value;
      }
    }
  }
}
