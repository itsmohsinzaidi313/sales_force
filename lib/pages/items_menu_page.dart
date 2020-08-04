import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sales_force/models/cart.dart';
import 'package:sales_force/models/customer.dart';
import 'package:sales_force/models/menu_format.dart';
import 'package:sales_force/pages_backend/items_menu_page_backend.dart';
import 'package:sales_force/sql/dal.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sales_force/shared/app_theme.dart';
import 'package:sales_force/pages/final_order_page.dart';

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
  ItemsMenuBackend _backend;

  _StateItemsMenu({this.format}) {
    myCart = new Cart(format.customer);
  }

  TabController _tabController;
  List<Tab> tabs;
//  List<Category> categories = [];
  List<String> categories = [];
//  List<Product> products = [];
//  List<ProductPrices> productPrices = [];
//  List<ProductFoc> listProductFoc = [];

  initTabs() {
    tabs = [];
    _backend = new ItemsMenuBackend(DAL.staticCategories, DAL.staticProducts,
        DAL.staticProductPrices, DAL.staticProductFoc, format);
//    if (categories.length == 0) ;
//    categories.addAll(DAL.staticCategories);
    DAL.staticCategories.forEach((element) {
      categories.add(element.product_category_title);
    });
//    if (products.length == 0) products.addAll(DAL.staticProducts);
//    if (productPrices.length == 0)
//      productPrices.addAll(DAL.staticProductPrices);
//    if (listProductFoc.length == 0) listProductFoc.addAll(DAL.staticProductFoc);
    for (String value1 in categories) {
      tabs.add(new Tab(
        text: value1.toUpperCase(),
      ));
    }
    _tabController = TabController(vsync: this, length: tabs.length);
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
            color: AppTheme.backgroundColor,
            // decoration: BoxDecoration(
            //     image: DecorationImage(
            //         image: AssetImage(AppTheme.backgroundImage),
            //         repeat: ImageRepeat.repeat)),
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
    for (int i = 0; i < _backend.products.length; i++) {
      String unitPrice = _backend.getProductPrice(
          format.customer.customerGroupId, _backend.products[i].product_id);
      if (double.parse(unitPrice) >= 0.01) {
        if (_backend.products[i].product_category_id ==
            _backend.getCategoryId(tabTitle))
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
                                GestureDetector(
                                  child: Container(
                                    width: 200,
                                    height: 200,
                                    child: AppTheme.loadNetworkImage(
                                        _backend.products[i].getNetworkImage()),
                                  ),
                                  onTap: () {
                                    myCart.add(
                                        _backend.products[i],
                                        _backend.getProductPrice(
                                            format.customer.customerGroupId,
                                            _backend.products[i].product_id));
                                    setState(() {
                                      double _ =
                                          myCart.getAmountBeforeDiscount();
                                    });
                                  },
                                ),
                                AppTheme.imageButton(
                                    'images/shopping_cart.png', 30,
                                    onPressed: () {
                                  myCart.add(
                                      _backend.products[i],
                                      _backend.getProductPrice(
                                          format.customer.customerGroupId,
                                          _backend.products[i].product_id));
                                  setState(() {
                                    double _ = myCart.getAmountBeforeDiscount();
                                  });
                                }),
                              ],
                            ),
                          ),
                          Center(
                              child: AppTheme.text(
                                  text: _backend.products[i].product_title
                                      .toUpperCase(),
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
        child: ListView(children: getCartItemsWidgets()),
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
        if (!product.focOverride)
          product.focQuantity = _backend.getFocQuantity(
              int.parse(product.product_id), product.quantity);
        widgets.add(AppTheme.card(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: AppTheme.text(
                text: 'ItemName:${product.product_title}\n'
                    'Unit Price: ${product.product_pack_price}\n'
                    'Quantity: ${product.quantity}\n'
                    'FOC Qty: ${product.focQuantity}\n'
                    'Amount: ${product.getPrice()}',
              )),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  children: <Widget>[
                    AppTheme.text(text: 'FOC'),
                    AppTheme.roundRaisedButton(
                        text: '+',
                        onPressed: () {
                          product.focOverride = true;
                          setState(() => product.focQuantity++);
                        }),
                    AppTheme.roundRaisedButton(
                        text: '-',
                        onPressed: () {
                          setState(() {
                            product.focOverride = true;
                            myCart.cleanCart();
                            if (product.focQuantity >= 1) product.focQuantity--;
                          });
                        })
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  children: <Widget>[
                    AppTheme.text(text: 'Quantity'),
                    AppTheme.roundRaisedButton(
                        text: '+',
                        onPressed: () {
                          myCart.add(product, product.product_carton_price);
                          setState(() => null);
                        }),
                    AppTheme.roundRaisedButton(
                        text: '-',
                        onPressed: () {
                          myCart.less(product);
                          setState(() => myCart.cleanCart());
                        })
                  ],
                ),
              ),
            ],
          ),
        )));
      });
    }
    return widgets;
  }

  @override
  void initState() {
    super.initState();
    initTabs();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
