class ProductPrices {
//product_to_customer_group_id text, product_id text, customer_group_id text, cash_price text, cash_price text, credit_price text
  String product_id;
  String customer_group_id;
  String cash_price;
  String credit_price;

  ProductPrices(
      {this.product_id,
        this.customer_group_id,
        this.cash_price,
        this.credit_price});

  List<String> getList() {
    return [
      this.product_id,
      this.customer_group_id,
      this.cash_price,
      this.credit_price
    ];
  }
}
