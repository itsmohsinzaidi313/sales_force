class Invoice {
  String invoice_id;
  String order_id;
  String customer_id;
  String user_id;
  String invoice_number;
  String invoice_date;
  String invoice_amount;
  String invoice_discount;
  String invoice_total_amount;
  String invoice_paid_amount;
  String invoice_balance;
  String invoice_status;
  String createdon;
  String modifiedon;

  Invoice(
      {this.invoice_id,
      this.order_id,
      this.customer_id,
      this.user_id,
      this.invoice_number,
      this.invoice_date,
      this.invoice_amount,
      this.invoice_discount,
      this.invoice_total_amount,
      this.invoice_paid_amount,
      this.invoice_balance,
      this.invoice_status,
      this.createdon,
      this.modifiedon});

  Invoice.withMap(List<dynamic> map) {
    if (map.isNotEmpty) {
      this.invoice_id = map[0]['invoice_id'];
      this.order_id = map[0]['order_id'];
      this.customer_id = map[0]['customer_id'];
      this.user_id = map[0]['user_id'];
      this.invoice_number = map[0]['invoice_number'];
      this.invoice_date = map[0]['invoice_date'];
      this.invoice_amount = map[0]['invoice_amount'];
      this.invoice_discount = map[0]['invoice_discount'];
      this.invoice_total_amount = map[0]['invoice_total_amount'];
      this.invoice_paid_amount = map[0]['invoice_paid_amount'];
      this.invoice_balance = map[0]['invoice_balance'];
      this.invoice_status = map[0]['invoiice_status'];
      this.createdon = map[0]['createdon'];
      this.modifiedon = map[0]['modifiedon'];
    } else {
      throw ArgumentError.value(map, '', 'Null Map Value');
    }
  }

  getList() {
    return [
      this.invoice_id,
      this.order_id,
      this.customer_id,
      this.user_id,
      this.invoice_number,
      this.invoice_date,
      this.invoice_amount,
      this.invoice_discount,
      this.invoice_total_amount,
      this.invoice_paid_amount,
      this.invoice_balance,
      this.invoice_status,
      this.createdon,
      this.modifiedon
    ];
  }

  getMap() {
    return {
      'invoice_id': this.invoice_id,
      'order_id': this.order_id,
      'customer_id': this.customer_id,
      'user_id': this.user_id,
      'invoice_number': this.invoice_number,
      'invoice_date': this.invoice_date,
      'invoice_amount': this.invoice_amount,
      'invoice_discount': this.invoice_discount,
      'invoice_total_amount': this.invoice_total_amount,
      'invoice_paid_amount': this.invoice_paid_amount,
      'invoice_balance': this.invoice_balance,
      'invoice_status': this.invoice_status,
      'createdon': this.createdon,
      'modifiedon': this.modifiedon
    };
  }
}
