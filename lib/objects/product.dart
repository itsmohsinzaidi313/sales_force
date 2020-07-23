import 'package:sales_force/objects/product_prices.dart';

class Product {
  String product_id;
  String product_category_id;
  String product_type_id;
  String user_id;
  String product_title;
  String product_pack_price;
  String product_pack_per_carton;
  String product_carton_price;
  String product_price_per_liter;
  String discount_type;
  String discount;
  String isActive;
  String createdon;
  String modifiedon;
  String customer_group_id;
  String purchasedQuantity;
  String product_image;
  int quantity;
  int focQuantity;
  List<dynamic> _customerGroupPrices;

  Product(
      {this.product_id,
      this.product_category_id,
      this.product_type_id,
      this.user_id,
      this.product_title,
      this.product_pack_price,
      this.product_pack_per_carton,
      this.product_carton_price,
      this.product_price_per_liter,
      this.discount,
      this.discount_type,
      this.isActive,
      this.createdon,
      this.modifiedon,
      this.purchasedQuantity,
      this.product_image,
      this.focQuantity}) {
    this.quantity = 1;
    this.focQuantity = 0;
  }

  Product.withProduct({Product product}) {
    this.product_id = product.product_id;
    this.product_category_id = product.product_category_id;
    this.product_type_id = product.product_type_id;
    this.user_id = product.user_id;
    this.product_title = product.product_title;
    this.product_pack_price = product.product_pack_price;
    this.product_pack_per_carton = product.product_pack_per_carton;
    this.product_carton_price = product.product_carton_price;
    this.product_price_per_liter = product.product_price_per_liter;
    this.discount = product.discount;
    this.discount_type = product.discount_type;
    this.isActive = product.isActive;
    this.createdon = product.createdon;
    this.modifiedon = product.modifiedon;
    this.purchasedQuantity = product.purchasedQuantity;
    this.quantity = product.quantity;
    this.focQuantity = product.focQuantity;
  }

  Product.withMap(List<dynamic> i) {
    this.product_id = i[0]['product_id'];
    this.product_category_id = i[0]['product_category_id'];
    this.product_type_id = i[0]['product_type_id'];
    this.user_id = i[0]['user_id'];
    this.product_title = i[0]['product_title'];
    this.product_pack_price = i[0]['product_pack_price'];
    this.product_pack_per_carton = i[0]['product_packs_per_carton'];
    this.product_carton_price = i[0]['product_carton_price'];
    this.product_price_per_liter = i[0]['product_price_per_liter'];
    this.product_image = i[0]['product_image'];
    this.discount = i[0]['discount'];
    this.discount_type = i[0]['discount_type'];
    this.isActive = i[0]['isActive'];
    this.createdon = i[0]['createdon'];
    this.modifiedon = i[0]['modifiedon'];
    this._customerGroupPrices = i[0]['customer_group_prices'];
  }

  getCustomerGroupPrices() {
    List<ProductPrices> list = [];
    if (_customerGroupPrices != null)
      _customerGroupPrices.forEach((e) {
        list.add(new ProductPrices(
            product_id: e['product_id'],
            customer_group_id: e['customer_group_id'],
            cash_price: e['cash_price'],
            credit_price: e['credit_price']));
      });
    return list;
  }

  getList() {
    return [
      this.product_id,
      this.product_category_id,
      this.product_type_id,
      this.user_id,
      this.product_title,
      this.product_pack_price,
      this.product_pack_per_carton,
      this.product_carton_price,
      this.product_price_per_liter,
      this.discount_type,
      this.discount,
      this.isActive,
      this.createdon,
      this.modifiedon,
      this.product_image
    ];
  }

  add() {
    this.quantity++;
  }

  less() {
    int difference = this.quantity - 1;
    if (difference >= 0) {
      quantity--;
    }
  }

  addFoc() {
    this.focQuantity++;
  }

  lessFoc() {
    int difference = this.focQuantity - 1;
    if (difference >= 0) {
      focQuantity--;
    }
  }

  setQuantity(int quantity) {
    this.quantity = quantity;
  }

  setFocQuantity(int focQuantity) {
    this.focQuantity = focQuantity;
  }

  getPrice() {
    return double.parse(product_pack_price) * quantity;
  }

  getNetworkImage() {
    if (this.product_image == null || this.product_image == '')
      return 'https://www.freeiconspng.com/uploads/no-image-icon-23.jpg';
    else
      return this.product_image;
  }
}
