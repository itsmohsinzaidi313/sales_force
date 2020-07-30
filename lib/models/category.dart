import 'package:sales_force/models/category_permissions.dart';

class Category {
  String product_category_id;
  String user_id;
  String product_category_title;
  String product_category_image;
  String createdon;
  String modifiedon;
  List<dynamic> _salesman;

  Category(
      {this.product_category_id,
      this.user_id,
      this.product_category_title,
      this.product_category_image,
      this.createdon,
      this.modifiedon});

  Category.withMap(List<dynamic> i) {
    this.product_category_id = i[0]['product_category_id'];
    this.user_id = i[0]['user_id'];
    this.product_category_title = i[0]['product_category_title'];
    this.product_category_image = i[0]['product_category_image'];
    this.createdon = i[0]['createdon'];
    this.modifiedon = i[0]['modifiedon'];
    _salesman = i[0]['salesman'];
  }

  List<CategoryPermissions> getCategoryPermissions() {
    List<CategoryPermissions> list = [];
    _salesman.forEach((e) {
      list.add(new CategoryPermissions(
          categoryId: e['product_category_id'], userId: e['user_id']));
    });
    return list;
  }

  getList() {
    return [
      this.product_category_id,
      this.user_id,
      this.product_category_title,
      this.product_category_image,
      this.createdon,
      this.modifiedon
    ];
  }
}
