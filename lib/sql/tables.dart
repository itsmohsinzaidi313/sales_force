class TablesV1{
  static String USERS = 'CREATE TABLE users(id integer primary key,user_id text, user_type_id text, distributor_id text, user_first_name text, user_last_name text, user_email_address text, user_password text, user_phone_number text, user_mobile text, user_status text, login_status integer, createdon text, modifiedon text)';

  static String USERSTYPES = 'CREATE TABLE users_types(id integer primary key, user_type_id text, user_type_title text, user_type_permissions text)';

  static String CATEGORIES = 'CREATE TABLE categories(id integer primary key, product_category_id text, user_id text, product_category_title text, product_category_image text, createdon text, modifiedon text)';

  static String PRODUCTS = 'CREATE TABLE products(id integer primary key, product_id text, product_category_id text, product_type_id text, user_id text, product_title text, product_pack_price text, product_packs_per_carton text, product_carton_price text, product_price_per_liter text,discount_type text, discount text, isActive text, createdon text, modifiedon text, product_image text)';

  static String INVOICES = 'CREATE TABLE invoices(id integer primary key, invoice_id text, order_id text, customer_id text, user_id text, invoice_number text, invoice_date text, invoice_amount text, invoice_discount text, invoice_total_amount text, invoice_paid_amount text, invoice_balance text, invoice_status text, createdon text, modifiedon text)';

  static String PAID_INVOICES = 'CREATE TABLE paid_invoices(id integer primary key, payment_user_id text, payment_order_id text, payment_invoice_id text, payment_customer_id text, payment_amount text, payment_mode text, payment_cheque_no text, payment_clearing_date text, payment_bank_name text, date_added text, is_upload integer)';

  static String SALESMAN =
      'CREATE TABLE salesman(id integer primary key, category_to_salesman_id text, product_category_id text, user_id text)';

  static String APP_SETTINGS =
      'CREATE TABLE app_settings(id integer primary key, sync_date text)';

  static String PRODUCTPRICES =
      'CREATE TABLE product_prices(id integer primary key, product_to_customer_group_id text, product_id text, customer_group_id text, cash_price text, credit_price text)';

  static String CUSTOMERGROUPS =
      'CREATE TABLE customer_groups(id integer primary key, customer_group_id text, name text)';

  static String CUSTOMER =
      'CREATE TABLE customer(id integer primary key,customer_id text, customer_group_id text, user_id text, country_id text, city_id text, state_id text, area_id text, customer_first_name text, customer_last_name text, customer_email text, customer_phone text, customer_mobile text, customer_shop_name, customer_address1 text, status text, discount_type text, discount text, credit_limit text)';

  static String ORDER_MASTER =
      'CREATE TABLE order_master(id integer primary key, user_id text, customer_id text, order_amount text, order_discount text, order_total text, order_status text, order_delivery_date text, createdon text)'; //, is_upload integer

  static String ORDER_DETAIL =
      'CREATE TABLE order_detail(id integer primary key, master_id integer, product_category_id text, product_id text, order_product_total_packs text, order_product_free_qty text, order_product_price_per_pack text, order_product_discount_per_pack text, order_product_discounted_pack_price text, order_product_total_discount text, order_product_total_price text, product_image text)';

  static String VISITS =
      'CREATE TABLE visits(id integer primary key, customer_id text, user_id text, lat text, long text, isorder text, createdon text, is_upload integer, pair_id integer)';

  static String CATEGORY_PERMISSIONS =
      'CREATE TABLE category_permissions(id integer primary key, category_id text, user_id text)';

  static String SYNC_APIS =
      'CREATE TABLE sync_apis(id integer primary key, server_id integer, module text, operation text, url text, createdon text, is_used integer)';

  static String PRODUCT_FOC =
      'CREATE TABLE product_foc(id integer primary key, product_id integer, start integer, end integer, quantity integer)';

  static String DROP_USERS = 'DROP TABLE IF EXISTS users';
  static String DROP_USERSTYPES = 'DROP TABLE IF EXISTS users_types';
  static String DROP_CATEGORIES = 'DROP TABLE IF EXISTS categories';
  static String DROP_PRODUCTS = 'DROP TABLE IF EXISTS products';
  static String DROP_INVOICES = 'DROP TABLE IF EXISTS invoices';
  static String DROP_SALESMAN = 'DROP TABLE IF EXISTS salesman';
  static String DROP_APPSETTINGS = 'DROP TABLE IF EXISTS app_settings';
  static String DROP_PRODUCTPRICES = 'DROP TABLE IF EXISTS product_prices';
  static String DROP_CUSTOMERGROUPS = 'DROP TABLE IF EXISTS customer_groups';
  static String DROP_CUSTOMER ='DROP TABLE IF EXISTS customer';
  static String DROP_ORDER_MASTER = 'DROP TABLE IF EXISTS order_master';
  static String DROP_ORDER_DETAIL = 'DROP TABLE IF EXISTS order_detail';
  static String DROP_VISITS = 'DROP TABLE IF EXISTS visits';
  static String DROP_PAID_INVOICES = 'DROP TABLE IF EXISTS paid_invoices';
  static String DROP_CATEGORY_PERMISSIONS = 'DROP TABLE IF EXISTS category_permissions';
  static String DROP_SYNC_APIS = 'DROP TABLE IF EXISTS sync_apis';
  static String DROP_PRODUCT_FOC = 'DROP TABLE IF EXISTS product_foc';
}

