class Insert {
  static String insertUsers =
      'INSERT INTO users(user_id, user_type_id, distributor_id, user_first_name, user_last_name, user_email_address, user_password, user_phone_number, user_mobile, user_status, createdon, modifiedon, discount_percent) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)';

  static String insertUsersTypes =
      'INSERT INTO users_types(user_type_id, user_type_title, user_type_permissions) VALUES(?,?,?)';

  static String insertCategories =
      'INSERT INTO Categories(product_category_id, user_id, product_category_title, product_category_image, createdon, modifiedon) VALUES(?,?,?,?,?,?)';

  static String insertProducts =
      'INSERT INTO products(product_id, product_category_id, product_type_id, user_id, product_title, product_pack_price, product_packs_per_carton, product_carton_price, product_price_per_liter, discount_type, discount, isActive, createdon, modifiedon, product_image) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';

  static String insertInvoices =
      'INSERT INTO invoices(invoice_id, order_id, customer_id, user_id, invoice_number, invoice_date, invoice_amount, invoice_discount, invoice_total_amount, invoice_paid_amount, invoice_balance, invoice_status, createdon, modifiedon) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)';

  static String insertPaidInvoices =
      'INSERT INTO paid_invoices(payment_user_id, payment_order_id, payment_invoice_id, payment_customer_id, payment_amount, payment_mode, payment_cheque_no, payment_clearing_date, payment_bank_name, date_added) VALUES(?,?,?,?,?,?,?,?,?,?)';

  static String insertSalesman =
      'INSERT INTO salesman(product_category_id, user_id) VALUES(?,?)';

  static String insertAppSettings =
      'INSERT INTO app_settings(is_loggedin, sync_date) VALUES(?,?)';

  static String insertCustomerGroups =
      'INSERT INTO customer_groups(customer_group_id, name) VALUES(?,?)';

  static String insertProductPrices =
      'INSERT INTO product_prices(product_id, customer_group_id, cash_price, credit_price) VALUES(?,?,?,?)';

  static String insertCustomer =
      'INSERT INTO customer(customer_id, customer_group_id, user_id, country_id, city_id, state_id, area_id, customer_first_name, customer_last_name, customer_email, customer_phone, customer_mobile, customer_shop_name, customer_address1, status, discount_type, discount, credit_limit) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';

  static String insertOrderMaster =
      'INSERT INTO order_master(user_id, customer_id, order_amount, order_discount, order_total, order_status, order_delivery_date, createdon, spo_discount) VALUES(?,?,?,?,?,?,?,?,?)';

  static String insertOrderDetail =
      'INSERT INTO order_detail(master_id, product_category_id, product_id, order_product_total_packs,order_product_free_qty, order_product_price_per_pack, order_product_discount_per_pack, order_product_discounted_pack_price, order_product_total_discount, order_product_total_price, product_image) VALUES(?,?,?,?,?,?,?,?,?,?,?)';

  static String insertVisit =
      'INSERT INTO visits(customer_id, user_id, lat, long, isorder, createdon, is_upload, pair_id) VALUES(?,?,?,?,?,?,?,?)';
  static String insertOrderLocation =
      'INSERT INTO visits(customer_id, user_id, lat, long, isorder, createdon, is_upload, order_id) VALUES(?,?,?,?,?,?,?,?)';
  static String insertCategoryPermissions =
      'INSERT INTO category_permissions(category_id, user_id) VALUES(?,?)';

  static String insertSyncDate =
      'INSERT INTO app_settings(sync_date) VALUES(?)';

  static String insertSyncApi =
      'INSERT INTO sync_apis(server_id, module, operation, url, createdon) VALUES(?,?,?,?,?)';

  static String insertProductFoc =
      'INSERT INTO product_foc(product_id, start, end, quantity) VALUES(?,?,?,?)';

//  static String insertInvoiceIfNotExists(Invoice invoice) {
//    return "INSERT INTO invoices(invoice_id, order_id, customer_id, user_id, invoice_number, invoice_date, invoice_amount, invoice_discount, invoice_total_amount, invoice_paid_amount, invoice_balance, invoice_status, createdon, modifiedon) select invoice_id, order_id, customer_id, user_id, invoice_number, invoice_date, invoice_amount, invoice_discount, invoice_total_amount, invoice_paid_amount, invoice_balance, invoice_status, createdon, modifiedon from (select '${invoice.invoice_id}' as invoice_id, '${invoice.order_id}' as order_id, '${invoice.customer_id}' as customer_id, '${invoice.user_id}' as  user_id, '${invoice.invoice_number}' as invoice_number, '${invoice.invoice_date}' as invoice_date, '${invoice.invoice_amount}' as invoice_amount, '${invoice.invoice_discount}' as invoice_discount, '${invoice.invoice_total_amount}' as invoice_total_amount, '${invoice.invoice_paid_amount}' as invoice_paid_amount, '${invoice.invoice_balance}' as invoice_balance, '${invoice.invoice_status}' as invoice_status, '${invoice.createdon}' as createdon, '${invoice.modifiedon}' as modifiedon) t WHERE NOT EXISTS (SELECT 1 from invoices where invoices.invoice_number = t.invoice_number); select last_insert_rowid() as id;";
//  }

//  static String insertCustomerIfNotExists(Customer customer) {
//    return "INSERT INTO customer(customer_id, customer_group_id, user_id, country_id, city_id, state_id, area_id, customer_first_name, customer_last_name, customer_email, customer_phone, customer_mobile, customer_shop_name, customer_address1, status, discount_type, discount, credit_limit) select customer_id, customer_group_id, user_id, country_id, city_id, state_id, area_id, customer_first_name, customer_last_name, customer_email, customer_phone, customer_mobile, customer_shop_name, customer_address1, status, discount_type, discount, credit_limit from (select '${customer.customerId}' as customer_id, '${customer.customerGroupId}' as customer_group_id, '${customer.userId}' as user_id, '${customer.countryId}' as country_id, '${customer.cityId}' as city_id, '${customer.stateId}' as state_id, '${customer.areaId}' as area_id, '${customer.firstName}' as customer_first_name, '${customer.lastName}' as customer_last_name, '${customer.email}' as customer_email, '${customer.phone}' as customer_phone, '${customer.mobile}' as customer_mobile, '${customer.shopName}' as customer_shop_name, '${customer.address}' as customer_address1, '${customer.status}' as status, '${customer.discountType}' as discount_type, '${customer.discount}' as discount, '${customer.creditLimit}' as credit_limit) t WHERE NOT EXISTS (select 1 from customer where customer.customer_id = t.customer_id); select last_insert_rowid() as id;";
//  }

//  static String insertUserIfNotExists(User user) {
//    return "INSERT INTO users(user_id, user_type_id, distributor_id, user_first_name, user_last_name, user_email_address, user_password, user_phone_number, user_mobile, user_status, createdon, modifiedon) select user_id, user_type_id, distributor_id, user_first_name, user_last_name, user_email_address, user_password, user_phone_number, user_mobile, user_status, createdon, modifiedon from (select '${user.user_id}' as user_id, '${user.user_type_id}' as user_type_id, '${user.distributor_id}' as distributor_id, '${user.firstname}' as user_first_name, '${user.lastname}' as user_last_name, '${user.email}' as user_email_address, '${user.password}' as user_password, '${user.phoneNumber}' as user_phone_number, '${user.mobile}' as user_mobile, '${user.user_status}' as user_status, '${user.createdon}' as createdon, ${user.modifiedon}' as modifiedon) t where not exists (select 1 from users where users.user_id = t.user_id); select last_insert_rowid() as id;";
//  }
}
