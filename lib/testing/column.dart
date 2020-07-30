class Column {
  static const List<String> USERS = [
    'id',
    'user_id',
    'user_type_id',
    'distributor_id',
    'user_first_name',
    'user_last_name',
    'user_email_address',
    'user_password',
    'user_phone_number',
    'user_mobile',
    'user_status',
    'login_status',
    'createdon',
    'modifiedon'
  ];
  static const List<String> USERSTYPES = [
    'id',
    'user_type_id',
    'user_type_title',
    'user_type_permissions'
  ];
  static const List<String> CATEGORIES = [
    'id',
    'product_category_id',
    'user_id',
    'product_category_title',
    'product_category_image',
    'createdon',
    'modifiedon'
  ];
  static const List<String> PRODUCTS = [
    'id',
    'product_id',
    'product_category_id',
    'product_type_id',
    'user_id',
    'product_title',
    'product_pack_price',
    'product_packs_per_carton',
    'product_carton_price',
    'product_price_per_liter',
    'discount',
    'isActive',
    'createdon',
    'modifiedon'
  ];
  static const List<String> PRODUCTPRICES = [
    'id',
    'product_to_customer_group_id',
    'product_id',
    'customer_group_id',
    'cash_price',
    'credit_price'
  ];
  static const List<String> INVOICES = [
    'id',
    'invoice_id',
    'order_id',
    'customer_id',
    'user_id',
    'invoice_number',
    'invoice_date',
    'invoice_amount',
    'invoice_discount',
    'invoice_total_amount',
    'invoice_paid_amount',
    'invoice_balance',
    'invoice_status',
    'createdon',
    'modifiedon'
  ];
  static const List<String> SALESMAN = [
    'id',
    'category_to_salesman_id',
    'product_category_id',
    'user_id'
  ];
  static const List<String> APP_SETTINGS = ['id', 'sync_date'];
  static const List<String> CUSTOMER_GROUPS = [
    'id',
    'product_to_customer_group_id',
    'product_id',
    'customer_group_id',
    'cash_price',
    'credit_price'
  ];
  static const List<String> CUSTOMER = [
    'id',
    'customer_id',
    'customer_group_id',
    'user_id',
    'country_id',
    'city_id',
    'state_id',
    'area_id',
    'customer_first_name',
    'customer_last_name',
    'customer_email',
    'customer_phone',
    'customer_mobile',
    'customer_shop_name',
    'customer_address1',
    'status',
    'discount_type',
    'discount',
    'credit_limit'
  ];
  static const List<String> ORDER_MASTER = [
    'id',
    'user_id',
    'customer_id',
    'order_amount',
    'order_discount',
    'order_total',
    'order_status',
    'order_delivery_date',
    'createdon'
  ];
  static const List<String> ORDER_DETAIL = [
    'id',
    'master_id',
    'product_category_id',
    'product_id',
    'order_product_total_packs',
    'order_product_price_per_pack',
    'order_product_discount_per_pack',
    'order_product_discounted_pack_price',
    'order_product_total_discount',
    'order_product_total_price'
  ];
}
