class Select {

  static String selectUser = 'select user_id, user_type_id, distributor_id, user_first_name, user_last_name, user_email_address, user_password, user_phone_number, user_mobile, user_status, createdon, modifiedon from users ';

  static String selectUserTypes = 'select user_type_id, user_type_title, user_type_permissions from users_types ';

  static String selectCategories = 'select distinct product_category_id, b.user_id, product_category_title, product_category_image, createdon, modifiedon from Categories a left join category_permissions b on b.category_id = a.product_category_id ';

  static String selectProducts = "select product_id, product_category_id, product_type_id, user_id, product_title, product_pack_price, product_packs_per_carton, product_carton_price, product_price_per_liter, discount_type, discount, isActive, createdon, modifiedon, ifnull(product_image,'https://www.freeiconspng.com/uploads/no-image-icon-23.jpg') as product_image from products ";

  static String selectProducts2 = 'select products.product_id, products.product_category_id, products.product_type_id, products.user_id, products.product_title, products.product_pack_price, products.product_packs_per_carton, products.product_carton_price, products.product_price_per_liter, products.discount, products.isActive, products.createdon, products.modifiedon, categories.product_category_title from products left join categories on categories.product_category_id = products.product_category_id ';

  static String selectInvoices = 'select invoice_id, order_id, customer_id, user_id, invoice_number, invoice_date, invoice_amount, invoice_discount, invoice_total_amount, invoice_paid_amount, invoice_balance, invoice_status, createdon, modifiedon from invoices ';

  static String selectSalesman = 'select product_category_id, user_id from salesman ';

  static String selectCategoryNames = 'select a.product_category_title from categories a left join category_permissions b on b.category_id = a.product_category_id ';

  static String selectProductPrices = 'select product_id, customer_group_id, cash_price, credit_price from product_prices ';

  static String selectCustomer = 'select customer_id, customer_group_id, user_id, country_id, city_id, state_id, area_id, customer_first_name, customer_last_name, customer_email, customer_phone, customer_mobile, customer_shop_name, customer_address1, status, discount_type, discount, credit_limit from customer ';

  static String selectCustomerGroups = 'select customer_group_id, name from customer_groups ';

  static String selectOrderMaster = 'select id as order_android_id, user_id, customer_id, order_amount, order_discount, order_total, order_status, order_delivery_date, createdon from order_master ';

  static String selectOrderDetail = 'select master_id as order_id, product_category_id, product_id, order_product_total_packs, order_product_price_per_pack, order_product_discount_per_pack, order_product_discounted_pack_price, order_product_total_discount, order_product_total_price from order_detail ';

  static String selectOrderMasterDetail = 'select a.product_title, b.order_product_total_packs, b.order_product_price_per_pack from products a left join order_detail b on b.product_id = a.product_id ';

  static String selectInvoiceForPost = 'select id as android_payment_id, payment_user_id, payment_order_id, payment_invoice_id, payment_customer_id, payment_amount, payment_mode, payment_cheque_no, payment_clearing_date, payment_bank_name, date_added from paid_invoices ';

  static String selectVisitJson = 'select id as order_taken_android_id, customer_id as order_taken_customer_id, user_id as order_taken_visit_admin_users_id_parcosf, lat as order_taken_visit_lat, long as order_taken_visit_long, isorder as order_taken_visit_isorder, createdon as order_taken_visit_createdon from visits ';

  static String selectSyncApis = 'select id, server_id, module, operation, url, createdon from sync_apis';

  static String selectVisits = 'select createdon, is_upload, pair_id from visits ';

  static String selectProductFoc = 'select product_id, start, end, quantity';
}
