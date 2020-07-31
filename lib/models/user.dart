class User {
  String user_id;
  String user_type_id;
  String distributor_id;
  String firstname;
  String lastname;
  String email;
  String password;
  String phoneNumber;
  String mobile;
  String user_status;
  String createdon;
  String modifiedon;
  String discountPercent;

  User(
      {this.user_id,
      this.user_type_id,
      this.distributor_id,
      this.firstname,
      this.lastname,
      this.email,
      this.password,
      this.phoneNumber,
      this.mobile,
      this.user_status,
      this.createdon,
      this.modifiedon,
      this.discountPercent});

  User.withUser(User user) {
    this.user_id = user.user_id;
    this.user_type_id = user.user_type_id;
    this.distributor_id = user.distributor_id;
    this.firstname = user.firstname;
    this.lastname = user.lastname;
    this.email = user.email;
    this.password = user.password;
    this.phoneNumber = user.phoneNumber;
    this.mobile = user.mobile;
    this.user_status = user.user_status;
    this.createdon = user.createdon;
    this.modifiedon = user.modifiedon;
  }

  User.withMap(List<dynamic> i) {
    if (i.isNotEmpty) {
      this.user_id = i[0]['user_id'] == null ? '' : i[0]['user_id'];
      this.user_type_id =
          i[0]['user_type_id'] == null ? '' : i[0]['user_type_id'];
      this.distributor_id =
          i[0]['distributor_id'] == null ? '' : i[0]['distributor_id'];
      this.firstname =
          i[0]['user_first_name'] == null ? '' : i[0]['user_first_name'];
      this.lastname =
          i[0]['user_last_name'] == null ? '' : i[0]['user_last_name'];
      this.email =
          i[0]['user_email_address'] == null ? '' : i[0]['user_email_address'];
      this.password =
          i[0]['user_password'] == null ? '' : i[0]['user_password'];
      this.phoneNumber =
          i[0]['user_phone_number'] == null ? '' : i[0]['user_phone_number'];
      this.mobile = i[0]['user_mobile'] == null ? '' : i[0]['user_mobile'];
      this.user_status = i[0]['user_status'] == null ? '' : i[0]['user_status'];
      this.createdon = i[0]['createdon'] == null ? '' : i[0]['createdon'];
      this.modifiedon = i[0]['modifiedon'] == null ? '' : i[0]['modifiedon'];
      this.discountPercent =
          i[0]['discount_percent'] == null ? '' : i[0]['discount_percent'];
    }
  }
  User.withQueryResult(List<Map<String, dynamic>> listMap) {
    this.user_id = listMap[0]['user_id'] == null ? '' : listMap[0]['user_id'];
    this.user_type_id =
        listMap[0]['user_type_id'] == null ? '' : listMap[0]['user_type_id'];
    this.distributor_id = listMap[0]['distributor_id'] == null
        ? ''
        : listMap[0]['distributor_id'];
    this.firstname = listMap[0]['user_first_name'] == null
        ? ''
        : listMap[0]['user_first_name'];
    this.lastname = listMap[0]['user_last_name'] == null
        ? ''
        : listMap[0]['user_last_name'];
    this.email = listMap[0]['user_email_address'] == null
        ? ''
        : listMap[0]['user_email_address'];
    this.password =
        listMap[0]['user_password'] == null ? '' : listMap[0]['user_password'];
    this.phoneNumber = listMap[0]['user_phone_number'] == null
        ? ''
        : listMap[0]['user_phone_number'];
    this.mobile =
        listMap[0]['user_mobile'] == null ? '' : listMap[0]['user_mobile'];
    this.user_status =
        listMap[0]['user_status'] == null ? '' : listMap[0]['user_status'];
    this.createdon =
        listMap[0]['createdon'] == null ? '' : listMap[0]['createdon'];
    this.modifiedon =
        listMap[0]['modifiedon'] == null ? '' : listMap[0]['modifiedon'];
    this.discountPercent = listMap[0]['discount_percent'] == null
        ? ''
        : listMap[0]['discount_percent'];
  }

  getList() {
    return [
      this.user_id,
      this.user_type_id,
      this.distributor_id,
      this.firstname,
      this.lastname,
      this.email,
      this.password,
      this.phoneNumber,
      this.mobile,
      this.user_status,
      this.createdon,
      this.modifiedon,
      this.discountPercent
    ];
  }
}
