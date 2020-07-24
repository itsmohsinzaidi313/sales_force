import 'package:sales_force/objects/category.dart';
import 'package:sales_force/objects/menu_format.dart';
import 'package:sales_force/objects/product.dart';
import 'package:sales_force/objects/product_foc.dart';
import 'package:sales_force/objects/product_prices.dart';

class ItemsMenuBackend {
  List<Category> _categories = [];
  List<Product> _products = [];
  List<ProductPrices> _productPrices = [];
  List<ProductFoc> _listProductFoc = [];
  MenuFormat _format;

  ItemsMenuBackend(this._categories, this._products, this._productPrices,
      this._listProductFoc, this._format);

  String getProductPrice(String customerGroupId, String productId) {
    Product product = new Product();

    _products.forEach((element) {
      if (element.product_id == productId) product = element;
    });
    for (ProductPrices value in _productPrices) {
      if (customerGroupId == value.customer_group_id &&
          productId == value.product_id) {
        if (_format.paymentMode == 'CASH') {
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
        } else if (_format.paymentMode == 'CREDIT') {
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
    for (Product value1 in _products) {
      if (productId == value1.product_id) {
        return value1.product_carton_price;
      }
    }
    return '0';
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
}
