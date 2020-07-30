import 'package:logger/logger.dart';
import 'package:sales_force/models/category.dart';
import 'package:sales_force/models/category_permissions.dart';
import 'package:sales_force/models/customer.dart';
import 'package:sales_force/models/customer_group.dart';
import 'package:sales_force/models/data_lists.dart';
import 'package:sales_force/models/invoice.dart';
import 'package:sales_force/models/product.dart';
import 'package:sales_force/models/product_foc.dart';
import 'package:sales_force/models/product_prices.dart';
import 'package:sales_force/models/user.dart';
import 'package:sales_force/models/user_type.dart';
import 'package:sales_force/shared/config.dart';

class ApiInstall {
  final String status;
  final String message;
  final Map data;
  final Logger _log = Config.log;

  ApiInstall({this.status, this.message, this.data}) {
    try {
      getUserTypesList(data['user_types']);
    } catch (e) {
      _log.e(e);
    }
    try {
      getUsersList(data['users']);
    } catch (e) {
      _log.e(e);
    }
    try {
      getCategoriesList(data['categories']);
    } catch (e) {
      _log.e(e);
    }
    try {
      getProductsList(data['products']);
    } catch (e) {
      _log.e(e);
    }
    try {
      getInvoicesList(data['invoices']);
    } catch (e) {
      _log.e('>>>ERROR ON getInvoicesList\n$e');
    }
    try {
      getCustomerGroupList(data['customer_groups']);
    } catch (e) {
      _log.e('>>>ERROR ON getInvoicesList\n$e');
    }
    try {
      getProductPricesList(data['pcg_prices']);
    } catch (e) {
      _log.e('>>>ERROR ON getInvoicesList\n$e');
    }
    try {
      getCustomersList(data['customers']);
    } catch (e) {
      _log.e('>>>ERROR ON getCustomers\n$e');
    }
  }

  getCustomersList(List<dynamic> i) {
    DataLists.listCustomer = [];
    i.forEach((e) {
      DataLists.listCustomer.add(new Customer(
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
  }

  getProductPricesList(List<dynamic> i) {
    DataLists.listProductPrices = [];
    i.forEach((e) {
      DataLists.listProductPrices.add(new ProductPrices(
          product_id: e['product_id'],
          customer_group_id: e['customer_group_id'],
          cash_price: e['cash_price'],
          credit_price: e['credit_price']));
    });
  }

  void getCustomerGroupList(List<dynamic> i) {
    DataLists.listCustomerGroups = [];
    i.forEach((e) {
      DataLists.listCustomerGroups.add(new CustomerGroup(
          customer_group_id: e['customer_group_id'], name: e['name']));
    });
  }

  void getUsersList(List<dynamic> i) {
    DataLists.listUsers = [];
    i.forEach((e) {
      DataLists.listUsers.add(new User(
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
          modifiedon: e['modifiedon'],
          discountPercent:
              e['discount_percent'] == null ? '0' : e['discount_percent']));
    });
  }

  void getUserTypesList(List<dynamic> i) {
    DataLists.listUserTypes = [];
    i.forEach((e) {
      DataLists.listUserTypes.add(new UserType(
          user_type_id: e['user_type_id'],
          title: e['user_type_title'],
          permission: e['user_type_permission']));
    });
  }

  void getCategoriesList(List<dynamic> i) {
    DataLists.listCategories = [];
    DataLists.listCategoryPermissions = [];
    i.forEach((e) {
      DataLists.listCategories.add(new Category(
          product_category_id: e['product_category_id'],
          user_id: e['user_id'],
          product_category_title: e['product_category_title'],
          product_category_image: e['product_category_image'],
          createdon: e['createdon'],
          modifiedon: e['modifiedon']));
      getCategoryPermissionsList(e['salesman']);
    });
  }

  void getCategoryPermissionsList(List<dynamic> i) {
    i.forEach((e) {
      DataLists.listCategoryPermissions.add(new CategoryPermissions(
          categoryId: e['product_category_id'],
          userId: e['user_id'].toString()));
    });
  }

  void getInvoicesList(List<dynamic> i) {
    DataLists.listInvoice = [];
    i.forEach((e) {
      DataLists.listInvoice.add(new Invoice(
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
  }

  void getProductsList(List<dynamic> i) {
    DataLists.listProduct = [];
    DataLists.listProductFoc = [];
    i.forEach((e) {
      DataLists.listProduct.add(new Product(
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
      try {
        getProductFoc(e['foc_slab']);
      } catch (e) {
        _log.e('>>>ERROR ON getProductFoc', [e]);
      }
    });
  }

  void getProductFoc(List<dynamic> i) {
    if (i != null)
      i.forEach((element) {
        DataLists.listProductFoc.add(new ProductFoc(
            int.parse(element['product_id']),
            int.parse(element['start']),
            int.parse(element['end']),
            int.parse(element['quantity'])));
      });
  }
}
