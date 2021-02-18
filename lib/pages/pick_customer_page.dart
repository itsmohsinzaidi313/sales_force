import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sales_force/models/customer.dart';
import 'package:sales_force/models/visit.dart';
import 'package:sales_force/pages/items_menu_page.dart';
import 'package:sales_force/pages/view_sales_page.dart';
import 'package:sales_force/shared/app_theme.dart';
import 'package:sales_force/shared/config.dart';
import 'package:sales_force/shared/library.dart';
import 'package:sales_force/sql/dal.dart';
import 'package:sales_force/sql/select_queries.dart';
import 'package:sqflite/sqflite.dart';

class PickCustomer extends StatefulWidget {
  String loadFor;

  PickCustomer({this.loadFor});

  @override
  _PickCustomerState createState() => _PickCustomerState(loadFor: this.loadFor);
}

class _PickCustomerState extends State<PickCustomer> {
  List<Customer> customers = DAL.staticCustomers;
  List<Customer> filteredCustomers = [];
  String loadFor;
  Logger _log = Config.log;
  bool isSearching = false;

  _PickCustomerState({this.loadFor});

  @override
  void initState() {
    super.initState();
    filteredCustomers = customers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.blue,
            title: !isSearching
                ? Text('Shops')
                : TextField(
                    onChanged: (value) {
                      _filterCustomers(value);
                    },
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        hintText: "Search Shops Here",
                        hintStyle: TextStyle(color: Colors.white)),
                  ),
            actions: <Widget>[
              isSearching
                  ? IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        setState(() {
                          this.isSearching = false;
                        });
                      },
                    )
                  : IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          this.isSearching = true;
                        });
                      },
                    )
            ]),
        body: Container(
          color: AppTheme.backgroundColor,
          child: Padding(
            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: ListView.builder(
              itemCount: filteredCustomers.length,
              itemBuilder: (context, index) => Card(
                child: Container(
                  height: Config.deviceDisplayHeight(context) * 0.16,
                  padding: const EdgeInsets.all(10.0),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 45,
                        left: 10,
                        child: Column(children: <Widget>[
                          Text(
                            '${filteredCustomers[index].shopName}',
                            style: AppTheme.textStyle(),
                          ),
                          Text(
                            '(${filteredCustomers[index].getName()})',
                            style: AppTheme.textStyle(fontSize: 15),
                          ),
                        ]),
                      ),
                      Positioned(
                        top: 15,
                        right: 5,
                        child: Column(
                          children: layoutController(filteredCustomers[index]),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  List<Widget> layoutController(Customer value) {
    if (loadFor == 'newSale') {
      return newSaleView(value);
    } else if (loadFor == 'viewSale') {
      return viewSale(value);
    } else if (loadFor == 'registerVisit') {
      return registerVisit(value);
    } else {
      return <Widget>[Text('EMPTY')];
    }
  }

  List<Widget> newSaleView(Customer value) {
    return <Widget>[
      Row(children: <Widget>[
        AppTheme.recRaisedButton(
            text: 'Cash',
            onPressed: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new ItemsMenu('CASH', value)));
            })
      ]),
      Row(
        children: <Widget>[
          AppTheme.recRaisedButton(
              text: 'Credit',
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new ItemsMenu('CREDIT', value)));
              })
        ],
      ),
    ];
  }

  List<Widget> viewSale(Customer customer) {
    return <Widget>[
      AppTheme.recRaisedButton(
        text: 'View Sale',
        onPressed: () async {
          List<Map<String, dynamic>> record = await DAL.staticDal
              .getMasterSalesRecord(
                  customer: customer, userId: DAL.currentUser.user_id);
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) =>
                      new ViewSales(customer: customer, record: record)));
        },
      )
    ];
  }

  List<Widget> registerVisit(Customer customer) {
    return <Widget>[
      //TODO: ENABLE FOR CUSTOMER WISE VISIT VIEW
      /*AppTheme.recRaisedButton(
          text: 'View History',
          onPressed: () {
            getVisits(customer).then((value) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new ViewVisits(
                            visits: value,
                          )));
            });
          }),*/
      AppTheme.recRaisedButton(
          text: 'Add Visit',
          onPressed: () async {
            AppTheme.showAlertDialogYN(context,
                title: 'Question',
                message: 'Are you sure?',
                onYes: () async {
                  ProgressDialog plzWait = ProgressDialog(context,
                      isDismissible: false, type: ProgressDialogType.Normal);
                  plzWait.update(message: 'Getting Location\nPlease Wait');
                  if (await Geolocator().isLocationServiceEnabled()) {
                    plzWait.show();
                    DAL.staticDal.addVisit(customer).then((value) {
                      plzWait.hide();
                      value = value == null ? 0 : value;
                      if (value > 0) {
                        AppTheme.showAlertDialogOK(context,
                            title: 'Success',
                            message: 'Visit Registered', onOK: () {
                          Library.resetViewToDashBoard(context);
                        });
                      } else {}
                    });
                  } else {
                    if (plzWait.isShowing()) plzWait.hide();
                    AppTheme.showAlertDialogOK(context,
                        title: 'Attention',
                        message: 'Please enable loacation and try again.',
                        onOK: () => Navigator.pop(context));
                  }
                },
                onNo: () => Navigator.pop(context));
          }),
    ];
  }

  Future<List<Visit>> getVisits(Customer customer) async {
    int paidId = 0;
    List<Visit> visits = [];
    Database db = await Library.getDatabase();
    List<dynamic> list = await db.rawQuery(
        "${Select.selectVisits} where customer_id = '${customer.customerId}' and user_id = ${DAL.currentUser.user_id} order by createdon desc");
    list.forEach((e) {
      if (paidId != e['pair_id']) {
        bool value = e['is_upload'] == 1 ? true : false;
        visits.add(new Visit(
            createdOn: DateTime.parse(e['createdon']), isUploaded: value));
        paidId = e['pair_id'];
      } else
        paidId = e['pair_id'];
    });
    return visits;
  }

  void _filterCustomers(String value) {
    setState(() {
      if (value == '')
        filteredCustomers = customers;
      else
        filteredCustomers = customers
            .where((element) => element.shopName
                .toString()
                .toLowerCase()
                .contains(value.toLowerCase()))
            .toList();
    });
  }
}
