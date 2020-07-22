import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/imoss/OneDrive/Documents/Projects/Flutter/sales_force/lib/shared/app_theme.dart';
import 'file:///C:/Users/imoss/OneDrive/Documents/Projects/Flutter/sales_force/lib/shared/library.dart';
import 'package:sales_force/objects/cart.dart';
import 'package:sales_force/objects/category.dart';
import 'package:sales_force/objects/customer.dart';
import 'package:sales_force/objects/product.dart';
import 'package:sales_force/objects/product_prices.dart';
import 'package:sales_force/sql/dal.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ItemsMenu extends StatefulWidget {
  MenuFormat format;

  ItemsMenu(String paymentMode, Customer customer) {
    format = new MenuFormat(paymentMode: paymentMode, customer: customer);
  }

  @override
  _StateItemsMenu createState() => _StateItemsMenu(format: format);
}

class _StateItemsMenu extends State<ItemsMenu>
    with SingleTickerProviderStateMixin {
  MenuFormat format;
  Cart myCart;

  _StateItemsMenu({this.format}) {
    myCart = new Cart(format.customer);
  }

  TabController _tabController;

  List<Tab> tabs;
  List<Category> categories = [];
  List<Product> products = [];
  List<ProductPrices> productPrices = [];

  initTabs() {
    tabs = [];
    if (categories.length == 0) ;
    categories.addAll(DAL.staticCategories);
    if (products.length == 0) products.addAll(DAL.staticProducts);
    if (productPrices.length == 0)
      productPrices.addAll(DAL.staticProductPrices);
    for (Category value1 in categories) {
      tabs.add(new Tab(
        text: value1.product_category_title.toUpperCase(),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    initTabs();
    _tabController = TabController(vsync: this, length: tabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: tabs,
          ),
        ),
        body: SlidingUpPanel(
          minHeight: 60,
          maxHeight: 500,
          border: Border(top: BorderSide(color: Colors.blue)),
          panel: slideUpPanelPanel(),
          collapsed: slideUpPanelCollapsed(),
          body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/salesPattern1.jpg'),
                    repeat: ImageRepeat.repeat)),
            margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 200),
            child: slideUpPanelBody(),
          ),
          onPanelClosed: () {
            setState(() {
              myCart.cleanCart();
            });
          },
        ));
  }

  List<Widget> productsView(String tabTitle) {
    List<Widget> widgets = [];
    for (int i = 0; i < products.length; i++) {
      String unitPrice = getProductPrice(
          format.customer.customerGroupId, products[i].product_id);
      if (double.parse(unitPrice) >= 0.01) {
        if (products[i].product_category_id == getCategoryId(tabTitle))
          widgets.add(Container(
            child: Column(
              children: <Widget>[
                Card(
                  margin: EdgeInsets.all(15.0),
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0),
                  ),
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Stack(
                              alignment: Alignment(1, 1),
                              children: <Widget>[
                                Container(
                                  width: 200,
                                  height: 200,
                                  child: Image.network(
                                    products[i].getNetworkImage(),
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                                AppTheme.imageButton(
                                    'images/shopping_cart.png', 30,
                                    onPressed: () {
                                  myCart.add(
                                      products[i],
                                      getProductPrice(
                                          format.customer.customerGroupId,
                                          products[i].product_id));
                                  setState(() {
                                    double _ = myCart.getAmountBeforeDiscount();
                                  });
                                }),
                              ],
                            ),
                          ),
                          Center(
                              child: AppTheme.text(
                                  text: products[i].product_title.toUpperCase(),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          Center(
                              child: AppTheme.text(
                                  text: 'RS: $unitPrice',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ],
                      )),
                ),
              ],
            ),
          ));
      }
    }
    return widgets;
  }

  String getCategoryId(String category) {
    String categoryId = "0";
    for (Category value in categories) {
      if (value.product_category_title.toUpperCase() ==
          category.toUpperCase()) {
        categoryId = value.product_category_id;
        break;
      }
    }
    return categoryId;
  }

  String getProductPrice(String customerGroupId, String productId) {
    Product product = new Product();

    products.forEach((element) {
      if (element.product_id == productId) product = element;
    });
    for (ProductPrices value in productPrices) {
      if (customerGroupId == value.customer_group_id &&
          productId == value.product_id) {
        if (format.paymentMode == 'CASH') {
          if (product.discount_type.toUpperCase() == 'P') {
            double price = double.parse(value.cash_price) *
                (double.parse(product.discount) / 100);
            return price.toString();
          } else if (product.discount_type.toUpperCase() == 'A') {
            double price =
                double.parse(value.cash_price) - double.parse(product.discount);
            return price.toString();
          } else if (product.discount_type.toUpperCase() == 'N') {
            double price = double.parse(value.cash_price);
            return price.toString();
          }
        } else if (format.paymentMode == 'CREDIT') {
          if (product.discount_type.toUpperCase() == 'P') {
            double price = double.parse(value.credit_price) *
                (double.parse(product.discount) / 100);
            return price.toString();
          } else if (product.discount_type.toUpperCase() == 'A') {
            double price = double.parse(value.credit_price) -
                double.parse(product.discount);
            return price.toString();
          } else if (product.discount_type.toUpperCase() == 'N') {
            double price = double.parse(value.credit_price);
            return price.toString();
          }
        }
      }
    }
    for (Product value1 in products) {
      if (productId == value1.product_id) {
        return value1.product_carton_price;
      }
    }
    return '0';
  }

  slideUpPanelCollapsed() {
    return Container(
      decoration: BoxDecoration(color: Colors.blue[600]),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: AppTheme.text(
                  text: 'Total: ${myCart.getAmountBeforeDiscount()}',
                  color: Colors.white,
                  fontSize: 24),
            ),
            //AppTheme.roundRaisedButton(text: 'Checkout', onPressed: () {}),
          ],
        ),
      ),
    );
  }

  slideUpPanelBody() {
    return TabBarView(
      controller: _tabController,
      children: tabs.map((Tab tab) {
        final String label = tab.text.toLowerCase();
        return layoutController(label);
      }).toList(),
    );
  }

  Widget layoutController(String label) {
    try {
      return GridView.count(
        crossAxisCount: 2,
        children: productsView(label),
      );
    } catch (e) {
      print(e);
      return Text('No Widget');
    }
  }

  slideUpPanelPanel() {
    return Column(children: <Widget>[
      Container(
          color: Colors.blue[600],
          child: Center(
              heightFactor: 2,
              child: AppTheme.text(
                  text: 'YOUR ITEMS',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white))),
      Expanded(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: getCartItemsWidgets(),
        ),
      )),
      Container(
          color: Colors.blue[400],
          child: Row(children: <Widget>[
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppTheme.text(
                  color: Colors.white,
                  text: 'Total ${myCart.getAmountBeforeDiscount()}'),
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppTheme.roundRaisedButton(
                  text: 'Checkout',
                  onPressed: () {
                    double creditLimit =
                        double.parse(format.customer.creditLimit);
                    double orderAmount = myCart.getAmountAfterDiscount();
                    if (orderAmount > creditLimit) {
                      AppTheme.showAlertDialogOK(context,
                          title: 'Warning',
                          message:
                              'Your order amount is exceeding credit limit of Rs:${format.customer.creditLimit} allowed.',
                          onOK: () => Navigator.pop(context));
                    } else {
                      int qty = myCart.products.length;
                      if (qty >= 1) {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) =>
                                    new FinalOrder(cart: myCart)));
                      } else {
                        AppTheme.showAlertDialog(context,
                            title: 'Attention',
                            content: Text('Your cart is empty.'));
                      }
                    }
                  }),
            )
          ]))
    ]);
  }

  List<Widget> getCartItemsWidgets() {
    List<Widget> widgets = [];
    if (myCart.products.length == 0) {
      setState(() {});
      widgets.add(
          AppTheme.card(child: AppTheme.text(text: 'No Items In Your Cart')));
    } else {
      myCart.products.forEach((product) {
        widgets.add(AppTheme.card(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: AppTheme.text(
                text: 'ItemName:${product.product_title}\n'
                    'Unit Price: ${product.product_pack_per_carton}\n'
                    'Quantity: ${product.quantity}\n'
                    'Amount: ${product.getPrice()}',
              )),
              Column(
                children: <Widget>[
                  AppTheme.roundRaisedButton(
                      text: '+',
                      onPressed: () {
                        myCart.add(product, product.product_carton_price);
                        setState(() {
//                              product.product_carton_price;
//                              product.quantity;
//                              product.getPrice();
                        });
                      }),
                  AppTheme.roundRaisedButton(
                      text: '-',
                      onPressed: () {
                        myCart.less(product);
                        setState(() {
                          myCart.cleanCart();
                          //                          product.product_carton_price;
                          //                          product.quantity.toString();
                          //                          product.getPrice();
                        });
                      })
                ],
              ),
            ],
          ),
        )));
      });
    }
    return widgets;
  }
}

class MenuFormat {
  String paymentMode;
  Customer customer;
  MenuFormat({this.paymentMode, this.customer});
}

class FinalOrder extends StatelessWidget {
  Cart cart;
  final double titleFontSize = 18;
  final double rowSpacing = 8.0;

  FinalOrder({this.cart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Confirm Order')),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
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
            ])),
            Center(
                child: AppTheme.roundRaisedButton(
                    text: 'Take Order',
                    onPressed: () {
                      DAL.staticDal.addOrder(cart);
                      AppTheme.showAlertDialog(context,
                          title: 'Success',
                          content: Text('Order Saved'),
                          onPressed: () =>
                              Library.resetViewToDashBoard(context));
                    }))
          ],
        ),
      ),
    );
  }
}
