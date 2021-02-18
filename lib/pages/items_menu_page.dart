import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sales_force/models/cart.dart';
import 'package:sales_force/models/customer.dart';
import 'package:sales_force/models/menu_format.dart';
import 'package:sales_force/models/product.dart';
import 'package:sales_force/pages/final_order_page.dart';
import 'package:sales_force/pages_backend/items_menu_page_backend.dart';
import 'package:sales_force/shared/app_theme.dart';
import 'package:sales_force/sql/dal.dart';
import 'package:sales_force/widgets/thumbnail_listTile.dart';
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
  ItemsMenuBackend _backend;
  bool _validateQuantity = false;
  bool _validateFoc = false;

  _StateItemsMenu({this.format}) {
    myCart = new Cart(format.customer);
  }

  List<TextEditingController> listQuantityController = [];
  List<TextEditingController> listFocController = [];
  TabController _tabController;
  List<Tab> tabs;

  List<String> categories = [];
  List<Product> products = [];
  List<Product> filteredItems = [];
  bool isSearching = false;
  TextEditingController textController;

  initTabs() {
    tabs = [];
    _backend = new ItemsMenuBackend(DAL.staticCategories, DAL.staticProducts,
        DAL.staticProductPrices, DAL.staticProductFoc, format);
    DAL.staticCategories.forEach((element) {
      categories.add(element.product_category_title);
    });
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
        backgroundColor: Colors.blue,
        title: !isSearching
            ? Text('Products - ${format.paymentMode}')
            : TextField(
                onChanged: (value) {
                  _filterItems(value, '');
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    hintText: "Search Items Here",
                    hintStyle: TextStyle(color: Colors.white)),
              ),
        actions: <Widget>[
          isSearching
              ? IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      this.isSearching = false;
                      filteredItems = _backend.products;
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
        ],
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
          margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 200),
          child: slideUpPanelBody(),
        ),
        onPanelClosed: () {
          setState(() {
            myCart.cleanCart();
          });
        },
      ),
    );
  }

  List<Widget> productsGirdView(String tabTitle) {
    List<Widget> widgets = [];
    for (int i = 0; i < _backend.products.length; i++) {
      String unitPrice = _backend.getProductPrice(
          format.customer.customerGroupId, _backend.products[i].product_id);
      if (double.parse(unitPrice) >= 0.01) {
        if (_backend.products[i].product_category_id ==
            _backend.getCategoryId(tabTitle))
          widgets.add(Card(
            elevation: 10.0,
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(5.0),
            ),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: <Widget>[
                Stack(
                  alignment: Alignment(1, 1),
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.21,
                        width: MediaQuery.of(context).size.width * 0.43,
                        padding: EdgeInsets.only(top: 8),
                        child: AppTheme.loadNetworkImage(
                          url: _backend.products[i].getNetworkImage(),
                        ),
                      ),
                      onTap: () {
                        myCart.add(
                            _backend.products[i],
                            _backend.getProductPrice(
                                format.customer.customerGroupId,
                                _backend.products[i].product_id));
                        setState(() {
                          double _ = myCart.getAmountBeforeDiscount();
                        });
                      },
                    ),
                    AppTheme.imageButton('images/shopping_cart.png', 30,
                        onPressed: () {
                      myCart.add(
                          _backend.products[i],
                          _backend.getProductPrice(
                              format.customer.customerGroupId,
                              _backend.products[i].product_id));
                      setState(() {});
                    }),
                  ],
                ),
                Center(
                    child: AppTheme.text(
                        text: _backend.products[i].product_title.toUpperCase(),
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                Center(
                    child: AppTheme.text(
                        text: 'RS: $unitPrice',
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
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
          ],
        ),
      ),
    );
  }

  slideUpPanelBody() {
    return TabBarView(
      controller: _tabController,
      children: tabs.map((Tab tab) {
        final String label = tab.text == null ? '' : tab.text.toLowerCase();
        return layoutController(label);
      }).toList(),
    );
  }

  Widget layoutController(String label) {
    try {
      // return ListView(
      //   children: productsListView2(label),
      // );
      _filterItems(searchValue, label);
      // _getCategoryProducts(label);
      return ListView.builder(
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          String unitPrice = _backend.getProductPrice(
              format.customer.customerGroupId, filteredItems[index].product_id);
          return Column(
            children: [
              CustomListItem(
                thumbnail: GestureDetector(
                  child: AppTheme.loadNetworkImage(
                      url: filteredItems[index].getNetworkImage(),
                      height: MediaQuery.of(context).size.height * 0.2,
                      boxFit: BoxFit.fill),
                  onTap: () => setState(() {
                    myCart.add(
                        filteredItems[index],
                        _backend.getProductPrice(
                            format.customer.customerGroupId,
                            filteredItems[index].product_id));
                  }),
                ),
                title: filteredItems[index].product_title.toUpperCase(),
                secondLine: 'RS: $unitPrice',
              ),
              Divider(),
            ],
          );
        },
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
              child: ListView(children: getCartItemsWidgets()))),
      Container(
          color: Colors.blue[400],
          child: Row(children: <Widget>[
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppTheme.text(
                        color: Colors.white,
                        text: 'Total ${myCart.getAmountBeforeDiscount()}'))),
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
      setState(() {
        widgets.add(
            AppTheme.card(child: AppTheme.text(text: 'No Items In Your Cart')));
      });
    } else {
      for (int i = 0; i < myCart.products.length; i++) {
        Product product = new Product.withProduct(product: myCart.products[i]);
        if (!product.focOverride) {
          product.focQuantity = _backend.getFocQuantity(
              int.parse(product.product_id), product.quantity);
        }
        listQuantityController.add(new TextEditingController());
        listFocController.add(new TextEditingController());
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
                          'Amount: ${product.getPrice()}')),
              Container(
                padding: EdgeInsets.all(8.0),
                margin: EdgeInsets.only(right: 8.0),
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(style: BorderStyle.solid, width: 0.5)),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: listFocController[i],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'FOC'),
                  onSubmitted: (value) => setState(() {
                    myCart.setFOCQuantity(product, int.parse(value));
                    product.focOverride = true;
                  }),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                margin: EdgeInsets.only(right: 8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(style: BorderStyle.solid, width: 0.5)),
                width: 80,
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: listQuantityController[i],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                  ),
                  onSubmitted: (value) {
                    setState(() {
                      if (int.parse(value) > 0) {
                        myCart.setQuantity(product, int.parse(value));
                      } else {
                        _validateQuantity = false;
                      }
                    });
                  },
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.blue,
                ),
                onPressed: () {
                  myCart.remove(product);
                  setState(() {
                    listQuantityController[i].clear();
                    listFocController[i].clear();
                    myCart.cleanCart();
                  });
                },
              ),
            ],
          ),
        )));
      }
    }
    return widgets;
  }

  @override
  void initState() {
    super.initState();
    initTabs();
    textController = TextEditingController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String title = '';
  String searchValue = '';
  void _filterItems(String value, String label) {
    searchValue = value;
    setState(() {
      if (label != '') title = label;
      products = _backend.products
          .where((element) =>
              _backend.getCategoryId(title).toLowerCase() ==
              element.product_category_id.toLowerCase())
          .toList();
      if (searchValue == 'All Items' || searchValue == '')
        filteredItems = products;
      else
        filteredItems = products
            .where((element) => element.product_title
                .toLowerCase()
                .contains(searchValue.toLowerCase()))
            .toList();
    });
  }
}
