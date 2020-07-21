import 'package:sales_force/objects/customer.dart';
import 'package:sales_force/objects/product.dart';


class Cart {
  List<Product> products;
  Customer customer;
  String _discountType;
  Cart(Customer customer){
    products = new List();
    this.customer = customer;
    this._discountType = customer.discountType;
  }

  getCartItems() {
    return products;
  }

  void add(Product product, String price) {
    Product newInstance = new Product.withProduct(product: product);
      newInstance.product_pack_price = price;
    if (products.length == 0) {
      products.add(newInstance);
    } else {
      for (int i = 0; i <= products.length; i++) {
        if (i < products.length && products[i].product_id == newInstance.product_id) {
          products[i].add();
          break;
        }
        if (i == products.length) {
          products.add(newInstance);
          break;
        }
      }
    }
  }

  double getAmountBeforeDiscount() {
    double totalPrice = 0.0;
    for (int i = 0; i < products.length; i++) {
      totalPrice += products[i].getPrice();
    }
    return totalPrice;
  }

  String _orderDiscount = '0';
  double getAmountAfterDiscount(){
    String orderTotal = '0';

    if (customer.discountType.toUpperCase() == 'A') {
      _orderDiscount = customer.discount;
      orderTotal =
          (getAmountBeforeDiscount() - double.parse(_orderDiscount))
              .toString();
    }
    else if (customer.discountType.toUpperCase() == 'P') {
      _orderDiscount =
          (getAmountBeforeDiscount() *
              (double.parse(customer.discount) / 100))
              .toString();
      orderTotal = (getAmountBeforeDiscount() - double.parse(_orderDiscount))
          .toString();
    }
    else{
      orderTotal = getAmountBeforeDiscount().toString();
    }
    return double.parse(orderTotal);
  }

  String getDiscountedAmount(){
    double beforeDiscount = getAmountBeforeDiscount();
    double afterDiscount = getAmountAfterDiscount();
    _orderDiscount = (beforeDiscount - afterDiscount).toString();
    return _orderDiscount;
  }

  String getDiscount() {
    String discount;
    if(customer.discountType.toUpperCase() == 'P')
      discount = '${customer.discount}%';
    else if(customer.discountType.toUpperCase() == 'A')
      discount = 'Rs:${customer.discount}';
    return discount;
  }

  String getDiscountType(){
    return _discountType;
  }

  void less(Product product) {
    if (products.length > 0) {
      for (int i = 0; i < products.length; i++) {
        String prodId = products[i].product_id;
        if (prodId == product.product_id) {
          int productQty = products[i].quantity;
          if ((productQty - product.quantity) >= 0) {
            products[i].less();
          }
          break;
        }
      }
    }
  }

  void remove(Product product) {
    if (products.length > 0) {
      for (int i = 0; i < products.length; i++) {
        if (products[i].product_id == product.product_id) {
          products.removeAt(i);
        }
      }
    }
  }

  void cleanCart() {
    if (products.length > 0) {
      for (int i = 0; i < products.length; i++) {
        if (products[i].quantity == 0) products.removeAt(i);
      }
    }
  }
}
