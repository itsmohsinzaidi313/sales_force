import 'package:sales_force/models/category.dart';
import 'package:sales_force/models/customer.dart';
import 'package:sales_force/models/customer_group.dart';
import 'package:sales_force/models/data_lists.dart';
import 'package:sales_force/models/menu_format.dart';
import 'package:sales_force/models/product.dart';
import 'package:sales_force/models/product_foc.dart';
import 'package:sales_force/models/product_prices.dart';

class ItemsMenuBackend {
  List<Category> _categories = [];

  List<Product> get products => _products;

  set products(List<Product> value) {
    _products = value;
  }

  List<Product> _products = [];
  List<ProductPrices> _productPrices = [];
  List<ProductFoc> _listProductFoc = [];
  MenuFormat _format;

  ItemsMenuBackend(
      List<Category> categories,
      List<Product> products,
      List<ProductPrices> productPrices,
      List<ProductFoc> listProductFoc,
      MenuFormat format) {
    this._categories.addAll(categories);
    this._products.addAll(products);
    this._productPrices.addAll(productPrices);
    this._listProductFoc.addAll(listProductFoc);
    this._format = format;
  }

  String getProductPrice(String customerGroupId, Product product) {
    final productPrice = _productPrices.singleWhere(
      (element) =>
          element.product_id == product.product_id &&
          customerGroupId == element.customer_group_id,
      orElse: () => ProductPrices(
          cash_price: '0',
          credit_price: '0',
          customer_group_id: customerGroupId,
          product_id: product.product_id),
    );

    if (_format.paymentMode == 'CASH') {
      if (product.discount_type.toUpperCase() == 'P') {
        double price = double.parse(productPrice.cash_price) *
            (double.parse(product.discount) / 100);
        return price.toString();
      } else if (product.discount_type.toUpperCase() == 'A') {
        double price = double.parse(productPrice.cash_price) -
            double.parse(product.discount);
        return price.toString();
      } else if (product.discount_type.toUpperCase() == 'N') {
        double price = double.parse(productPrice.cash_price);
        return price.toString();
      }
    } else if (_format.paymentMode == 'CREDIT') {
      if (product.discount_type.toUpperCase() == 'P') {
        double price = double.parse(productPrice.credit_price) *
            (double.parse(product.discount) / 100);
        return price.toString();
      } else if (product.discount_type.toUpperCase() == 'A') {
        double price = double.parse(productPrice.credit_price) -
            double.parse(product.discount);
        return price.toString();
      } else if (product.discount_type.toUpperCase() == 'N') {
        double price = double.parse(productPrice.credit_price);
        return price.toString();
      }
    }

    // for (ProductPrices value in _productPrices) {
    //   if (customerGroupId == value.customer_group_id &&
    //       product.product_id == value.product_id) {
    //     if (_format.paymentMode == 'CASH') {
    //       if (product.discount_type.toUpperCase() == 'P') {
    //         double price = double.parse(value.cash_price) *
    //             (double.parse(product.discount) / 100);
    //         return price.toString();
    //       } else if (product.discount_type.toUpperCase() == 'A') {
    //         double price =
    //             double.parse(value.cash_price) - double.parse(product.discount);
    //         return price.toString();
    //       } else if (product.discount_type.toUpperCase() == 'N') {
    //         double price = double.parse(value.cash_price);
    //         return price.toString();
    //       }
    //     } else if (_format.paymentMode == 'CREDIT') {
    //       if (product.discount_type.toUpperCase() == 'P') {
    //         double price = double.parse(value.credit_price) *
    //             (double.parse(product.discount) / 100);
    //         return price.toString();
    //       } else if (product.discount_type.toUpperCase() == 'A') {
    //         double price = double.parse(value.credit_price) -
    //             double.parse(product.discount);
    //         return price.toString();
    //       } else if (product.discount_type.toUpperCase() == 'N') {
    //         double price = double.parse(value.credit_price);
    //         return price.toString();
    //       }
    //     }
    //   }
    // }

    // for (Product value1 in _products) {
    //   if (product.product_id == value1.product_id) {
    //     return value1.product_carton_price;
    //   }
    // }
    return product.product_carton_price ?? '0';
  }

  String getCategoryId(String category) {
    String categoryId = "0";
    for (Category value in _categories) {
      if (value.product_category_title.toUpperCase() ==
          category.toUpperCase()) {
        categoryId = value.product_category_id;
        break;
      }
    }
    return categoryId;
  }

  int getFocQuantity(int productId, int quantity) {
    int focQuantity = 0;
    _listProductFoc.forEach((element) {
      if (productId == element.productId &&
          quantity >= element.start &&
          quantity <= element.end) {
        focQuantity = element.quantity;
      }
    });
    return focQuantity;
  }

  List<Product> searchProduct(String keyWord) {
    if (keyWord == '') {
      return _products;
    } else {
      return _products
          .where((element) => element.product_title.contains(keyWord))
          .toList();
    }
  }
}
