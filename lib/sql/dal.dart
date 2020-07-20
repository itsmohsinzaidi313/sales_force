import 'dart:core';

import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:sales_force/objects/cart.dart';
import 'package:sales_force/objects/category.dart';
import 'package:sales_force/objects/customer.dart';
import 'package:sales_force/objects/customerGroup.dart';
import 'package:sales_force/objects/invoice.dart';
import 'package:sales_force/objects/jsonElements.dart';
import 'package:sales_force/objects/product.dart';
import 'package:sales_force/objects/productPrices.dart';
import 'package:sales_force/objects/user.dart';
import 'package:sales_force/services/serviceControl.dart';
import 'package:sales_force/sql/selectQueries.dart';
import 'package:sqflite/sqflite.dart';

import '../config.dart';
import '../library.dart';
import 'insertQueries.dart';

class DAL {
  static List<Product> staticProducts;
  static List<Category> staticCategories;
  static List<User> staticUsers;
  static List<Invoice> staticInvoices;
  static List<Customer> staticCustomers;
  static List<String> staticCategoryNames;
  static List<CustomerGroup> staticCustomerGroups;
  static List<ProductPrices> staticProductPrices;
  static ServiceControl serviceCtrl;
  static User currentUser;
  static String userId;
  static DAL staticDal;
  Database db;
  String email;
  Logger _log = Config.log;

  DAL({this.email}) {
    if (this.email != null) {
      initDatabase();
    }
  }

  DAL.withDb({this.db});

  initDatabase() async {
    try {
      _log.v('INITIALIZING DAL');
      String dbStorage = await getDatabasesPath();
      String path = join(dbStorage, Config.DATABASE_NAME);
      db = await openDatabase(path, singleInstance: true);
      if (db != null) {
        initDAL();
        _log.v('DAL INITIALIZING COMPLETE');
      } else {
        _log.v('DAL INITIALIZING FAILED');
      }
    } catch (e) {
      _log.wtf('ERROR ON DAL INITIALIZATION FAILED', [e]);
    }
  }

  initDAL() {
    getUsers();
    getProducts();
    getProductPrices();
    loadUserSpecificResources();
  }

  getProductPrices() {
    try {
      _log.v('DAL LOADING PRODUCT PRICES');
      List productPrices = [];
      Future<List> future = db.rawQuery(Select.selectProductPrices);
      future.then((onValue) {
        productPrices = onValue;
        staticProductPrices = getProductPricesList(productPrices);
        _log.v('DAL PRODUCT PRICES LOADED');
      });
    } catch (e) {
      _log.e('ERROR ON DAL getProductPrices', [e]);
    }
  }

  getProductPricesList(List<dynamic> i) {
    try {
      List<ProductPrices> listProductPrices = [];
      i.forEach((e) {
        listProductPrices.add(new ProductPrices(
            product_id: e['product_id'],
            customer_group_id: e['customer_group_id'],
            cash_price: e['cash_price'],
            credit_price: e['credit_price']));
      });
      return listProductPrices;
    } catch (e) {
      _log.e('ERROR IN DAL', [e]);
    }
  }

  getCustomerGroups() {
    try {
      _log.v('DAL LOADING CUSTOMER GROUPS');
      List customerGroups = [];
      Future<List> future = db.rawQuery(Select.selectCustomerGroups);
      future.then((value) {
        customerGroups = value;
        staticCustomerGroups = getCustomersList(customerGroups);
        _log.v('DAL CUSTOMER GROUPS LOADED');
      });
    } catch (e) {
      _log.e('ERROR ON DAL getCustomerGroups', [e]);
      _log.e('ERROR IN DAL', [e]);
    }
  }

  getCustomerGroupList(List<dynamic> i) {
    try {
      List<CustomerGroup> listCustomerGroups = [];
      i.forEach((e) {
        listCustomerGroups.add(new CustomerGroup(
            customer_group_id: e['customer_group_id'], name: e['name']));
      });
      return listCustomerGroups;
    } catch (e) {
      _log.e('ERROR IN DAL', [e]);
    }
  }

  getCustomer() {
    try {
      _log.v('DAL LOADING CUSTOMERS');
      List customers = [];
      String query = Select.selectCustomer + ' where user_id = ?';
      List whereArgs = [currentUser.user_id];
      Future<List> future = db.rawQuery(query, whereArgs);
      future.then((onValue) {
        customers = onValue;
        staticCustomers = getCustomersList(customers);
        _log.v('DAL CUSTOMERS LOADED');
        _log.v('TOTAL CUSTOMERS :' + staticCustomers.length.toString());
      });
      _log.v('DAL CUSTOMERS LOADED');
    } catch (e) {
      _log.e('ERROR ON DAL LOADING CUSTOMERS', [e]);
    }
  }

  getCustomersList(List<dynamic> i) {
    try {
      List<Customer> listCustomer = [];
      i.forEach((e) {
        listCustomer.add(new Customer(
            customerId: e['customer_id'],
            customerGroupId: e['customer_group_id'],
            userId: e['user_id'],
            countryId: e['country_id'],
            cityId: e['city_id'],
            stateId: e['state_id'],
            areaId: e['area_id'],
            firstName: e['customer_first_name'],
            lastName: e['customer_last_name'],
            email: e['customer_email'],
            phone: e['customer_phone'],
            mobile: e['customer_mobile'],
            shopName: e['customer_shop_name'],
            address: e['customer_address1'],
            status: e['status'],
            discountType: e['discount_type'],
            discount: e['discount'],
            creditLimit: e['credit_limit']));
      });
      return listCustomer;
    } catch (e) {
      _log.e('ERROR IN DAL', [e]);
      return null;
    }
  }

  void loadUserSpecificResources() {
    try {
      _log.v('DAL LOADING USER');
      List users = [];
      String query = Select.selectUser + " where user_email_address = ?";
      List whereArgs = [email];
      Future<List> future = db.rawQuery(query, whereArgs);
      future.then((value) => users = value);
      future.whenComplete(() {
        users = getUsersList(users);
        currentUser = users[0];
        _log.v('USER LOADED');
        _log.v('USER :' + currentUser.email);
        getCategories();
        getCustomer();
        getCategoryNames();
        getInvoices();
      });
    } catch (e) {
      _log.e('ERROR ON DAL LOADING USERS', [e]);
    }
  }

  void getUsers() {
    try {
      _log.v('DAL LOADING USERS');
      List users;
      Future<List> future = db.rawQuery(Select.selectUser);
      future.then((value) {
        users = value;
        staticUsers = getUsersList(users);
        _log.v('USERS LOADED');
        _log.v('TOTAL USERS :' + staticUsers.length.toString());
      });
    } catch (e) {
      _log.e('ERROR ON DAL LOADING USERS', [e]);
    }
  }

  List<User> getUsersList(List<dynamic> i) {
    try {
      List<User> listUsers = [];
      i.forEach((e) {
        listUsers.add(new User(
            user_id: e['user_id'],
            user_type_id: e['user_type_id'],
            distributor_id: e['distributor_id'],
            firstname: e['user_first_name'],
            lastname: e['user_last_name'],
            email: e['user_email_address'],
            password: e['user_password'],
            phoneNumber: e['user_phone_number'],
            mobile: e['user_mobile'],
            user_status: e['user_status'],
            createdon: e['createdon'],
            modifiedon: e['modifiedon']));
      });
      return listUsers;
    } catch (e) {
      _log.e('ERROR IN DAL', [e]);
      return null;
    }
  }

  void getCategories() {
    try {
      _log.v('DAL LOADING CATEGORIES');
      List categories = [];
      String query = Select.selectCategories + " where b.user_id = ?";
      List whereArgs = [currentUser.user_id];
      Future<List> future = db.rawQuery(query, whereArgs);
      future.then((value) {
        categories = value;
        staticCategories = getCategoriesList(categories);
        _log.v('DAL CATEGORIES LOADED');
        _log.v('TOTAL CATEGORIES :' + staticCategories.length.toString());
      });
    } catch (e) {
      _log.e('ERROR ON DAL getCategories', [e]);
    }
  }

  List<Category> getCategoriesList(List<dynamic> i) {
    try {
      List<Category> listCategories = [];
      i.forEach((e) {
        listCategories.add(new Category(
            product_category_id: e['product_category_id'],
            user_id: e['user_id'],
            product_category_title: e['product_category_title'],
            product_category_image: e['product_category_image'],
            createdon: e['createdon'],
            modifiedon: e['modifiedon']));
      });
      return listCategories;
    } catch (e) {
      return null;
    }
  }

  Future<void> getCategoryNames() async {
    try {
      _log.v('DAL LOADING CATEGORY NAMES');
      staticCategoryNames = [];
      String query = '${Select.selectCategoryNames} where b.user_id = ?';
      List<Map<String, dynamic>> data =
          await db.rawQuery(query, [currentUser.user_id]);
      if (data != null)
        data.forEach((e) {
          staticCategoryNames.add(e['product_category_title']);
        });
      _log.v('DAL CATEGORY NAMES LOADED');
    } catch (e) {
      _log.e('ERROR ON DAL getCategoryNames', [e]);
    }
  }

  void getProducts() {
    try {
      _log.v('DAL LOADING PRODUCTS');
      List products = [];
      Future<dynamic> future = db.rawQuery(Select.selectProducts);
      future.then((value) {
        products = value;
        staticProducts = getProductsList(products);
        _log.v('DAL PRODUCTS LOADED');
        _log.v('TOTAL PRODUCTS :' + staticProducts.length.toString());
      });
    } catch (e) {
      _log.e('ERROR ON DAL getProducts');
    }
  }

  List<Product> getProductsList(List<dynamic> i) {
    try {
      List<Product> listProduct = [];
      i.forEach((e) {
        listProduct.add(new Product(
            product_id: e['product_id'],
            product_category_id: e['product_category_id'],
            product_type_id: e['product_type_id'],
            user_id: e['user_id'],
            product_title: e['product_title'],
            product_pack_price: e['product_pack_price'],
            product_pack_per_carton: e['product_packs_per_carton'],
            product_carton_price: e['product_carton_price'],
            product_price_per_liter: e['product_price_per_liter'],
            discount_type: e['discount_type'],
            discount: e['discount'],
            isActive: e['isActive'],
            createdon: e['createdon'],
            modifiedon: e['modifiedon'],
            product_image: e['product_image']));
      });
      return listProduct;
    } catch (e) {
      _log.e('ERROR IN DAL', [e]);
      return null;
    }
  }

  void getInvoices() {
    try {
      _log.v('DAL LOADING INVOICES');
      List invoices = [];
      Future<dynamic> future = db.rawQuery(
          "${Select.selectInvoices} where user_id = ${DAL.currentUser.user_id} order by invoice_date desc");
      future.then((value) {
        invoices = value;
        staticInvoices = getInvoicesList(invoices);
        _log.v('DAL INVOICES LOADED');
        _log.v('TOTAL INVOICES :' + staticInvoices.length.toString());
      });
    } catch (e) {
      _log.e('ERROR ON DAL getInvoices', [e]);
      _log.e('ERROR IN DAL', [e]);
    }
  }

  getInvoicesList(List<dynamic> i) {
    try {
      List<Invoice> listInvoice = [];
      i.forEach((e) {
        listInvoice.add(new Invoice(
            invoice_id: e['invoice_id'],
            order_id: e['order_id'],
            customer_id: e['customer_id'],
            user_id: e['user_id'],
            invoice_number: e['invoice_number'],
            invoice_date: e['invoice_date'],
            invoice_amount: e['invoice_amount'],
            invoice_discount: e['invoice_discount'],
            invoice_total_amount: e['invoice_total_amount'],
            invoice_paid_amount: e['invoice_paid_amount'],
            invoice_balance: e['invoice_balance'],
            invoice_status: e['invoice_status'],
            createdon: e['createdon'],
            modifiedon: e['modifiedon']));
      });
      return listInvoice;
    } catch (e) {
      _log.e('ERROR ON DAL getInvoicesList', [e]);
      return null;
    }
  }

  storeInvoice(JSONInvoice invoice) {
    try {
      _log.v('ENTRY DAL storeInvoice');
      int id = 0;
      db
          .rawInsert(Insert.insertPaidInvoices, invoice.getList())
          .then((value) => id = value)
          .whenComplete(() {
        db.rawUpdate("update paid_invoices set is_upload = 0 where id = '$id'");
        updateInvoicePaidAmount(invoice);
      }).catchError((onError) => _log.e(onError));
      _log.v('EXIT DAL storeInvoice');
    } catch (e) {
      _log.e('ERROR ON DAL storeInvoice', [e]);
    }
  }

  void updateInvoicePaidAmount(JSONInvoice invoice) async {
    List<Map<String, dynamic>> x = await db.rawQuery(
        "select invoice_paid_amount from invoices where invoice_number = '${invoice.invoiceNumber}'");
    x.forEach((element) {
      double previousAmount = double.parse(element['invoice_paid_amount']);
      double updatedAmount =
          previousAmount + double.parse(invoice.amountReceived);
      db.rawUpdate(
          "update invoices set invoice_paid_amount = ? where invoice_number = '${invoice.invoiceNumber}'",
          [
            updatedAmount.toString()
          ]).whenComplete(() => DAL.staticDal.getInvoices());
    });
  }

  getInvoiceForJson() async {
    try {
      _log.v('ENTRY DAL getInvoiceForJson');
      String query = Select.selectInvoiceForPost +
          'where payment_user_id = ${DAL.currentUser.user_id}';
      List<Map<String, dynamic>> result = await db.rawQuery(query);
      _log.v('EXIT DAL getInvoiceForJson');
      return result;
    } catch (e) {
      _log.e('ERROR ON DAL getInvoiceForJson', [e]);
    }
  }

  getMasterSalesRecord({Customer customer, String userId}) async {
    try {
      //_log.v('DAL ENTRY getSalesRecord');
      String query = Select.selectOrderMaster +
          'where customer_id = ${customer.customerId} and user_id = $userId order by id desc';
      List<Map<String, dynamic>> x = await db.rawQuery(query);
      //_log.v('DAL EXIT getSalesRecord');
      return x;
    } catch (e) {
      _log.e('ERROR IN DAL', [e]);
    }
  }

  getDetailSalesRecord({String masterId}) async {
    try {
      List<Product> products = [];
      //_log.v('DAL ENTRY getDetailSalesRecord');
      String query =
          Select.selectOrderMasterDetail + 'where b.master_id = $masterId';
      List<Map<String, dynamic>> x = await db.rawQuery(query);
      x.forEach((e) {
        products.add(new Product(
            product_title: e['product_title'],
            purchasedQuantity: e['order_product_total_packs'],
            product_pack_price: e['order_product_price_per_pack']));
      });
      //_log.v('DAL EXIT getDetailSalesRecord');
      return products;
    } catch (e) {
      _log.e('ERROR IN DAL', [e]);
    }
  }

  addOrder(Cart cart) async {
    try {
      _log.v('ENTRY addOrder');
      List<dynamic> orderMasterValues = [
        currentUser.user_id,
        cart.customer.customerId,
        cart.getAmountBeforeDiscount().toString(),
        cart.getDiscountedAmount().toString(),
        cart.getAmountAfterDiscount().toString(),
        '0',
        '0',
        Library.getDateTime()
      ];
      int id = await db.rawInsert(Insert.insertOrderMaster, orderMasterValues);

      cart.products.forEach((e) async {
        List<dynamic> orderDetailValues = [
          id,
          e.product_category_id,
          e.product_id,
          e.quantity.toString(),
          e.product_pack_price,
          '0',
          '0',
          '0',
          e.getPrice(),
          e.product_image
        ];
        int _ = await db.rawInsert(Insert.insertOrderDetail, orderDetailValues);
      });
      _log.v('EXIT addOrder');
    } catch (e) {
      _log.e('ERROR ON addOrder', [e]);
      _log.v('$e');
    }
  }

  setInvoiceUploadStatus(String id, bool isUploaded) async {
    int uploaded = 0;
    if (isUploaded)
      uploaded = 1;
    else
      uploaded = 0;
    int x = await db.update('paid_invoices', {'is_upload': uploaded},
        where: 'id = ?', whereArgs: [id]);
    if (x == 1)
      return true;
    else
      return false;
  }

  getLastMaxVisitId() async {
    String query = 'select ifnull(max(id),0) + 1 as id from visits';
    List<Map<String, dynamic>> id = await db.rawQuery(query);
    return id[0]['id'].toString();
  }

  addVisit(Customer customer) async {
    try {
      String paidId = await getLastMaxVisitId();
      int id = 0;
      Position location1 = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      Position location2 = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      _log.v('$location1\n$location2');
      List<String> values1 = [
        customer.customerId,
        currentUser.user_id,
        location1.latitude.toString(),
        location1.longitude.toString(),
        '0',
        Library.getDateTime(),
        '0',
        paidId
      ];
      List<String> values2 = [
        customer.customerId,
        currentUser.user_id,
        location2.latitude.toString(),
        location2.longitude.toString(),
        '0',
        Library.getDateTime(),
        '0',
        paidId
      ];
      id = await db.rawInsert(Insert.insertVisit, values1);
      //id = await db.rawInsert(Insert.insertVisit, values2);
      return id;
    } catch (e) {
      _log.e('ERROR ON addVisit', [e]);
    }
  }

  setVisitUploadStatus(String paidId, bool status) {
    try {
      int value = 0;
      if (status) value = 1;

      db.update('visits', {'is_upload': '$value'},
          where: 'pair_id = ?', whereArgs: [paidId]);
    } catch (e) {
      _log.e('ERROR ON setVisitUploadStatus', [e]);
    }
  }

  setOrderUploadStatus(int id, bool status) {
    try {
      int value = 0;
      if (status) value = 1;
      db.update('order_master', {'order_status': '$value'},
          where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      _log.e('ERROR ON setOrderUploadStatus', [e]);
    }
  }
}
