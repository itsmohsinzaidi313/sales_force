import 'package:sales_force/models/product.dart';
import 'package:sales_force/models/product_foc.dart';
import 'package:sales_force/models/product_prices.dart';
import 'package:sales_force/models/sync_packet.dart';
import 'package:sales_force/models/user.dart';
import 'package:sales_force/models/user_type.dart';
import 'category.dart';
import 'category_permissions.dart';
import 'customer.dart';
import 'customer_group.dart';
import 'invoice.dart';

class DataLists {
  static List<UserType> listUserTypes;
  static List<User> listUsers;
  static List<Category> listCategories;
  static List<Product> listProduct;
  static List<Invoice> listInvoice;
  static List<CustomerGroup> listCustomerGroups;
  static List<ProductPrices> listProductPrices;
  static List<Customer> listCustomer;
  static List<CategoryPermissions> listCategoryPermissions;
  static List<SyncPacket> listSyncPackets;
  static List<ProductFoc> listProductFoc;

  DataLists(
      {listUserTypes,
      listCategories,
      listInvoice,
      listProduct,
      listUsers,
      listCustomerGroups,
      listPCGPrices,
      listCustomer,
      listCategoryPermissions,
      listSyncPackets,
      listProductFoc});
}
