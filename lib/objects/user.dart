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
      this.modifiedon});

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
      this.user_id = i[0]['user_id'] == null ? "" : i[0]['user_id'];
      this.user_type_id = i[0]['user_type_id'] == null ? "" : i[0]['user_type_id'];
      this.distributor_id = i[0]['distributor_id'] == null ? "" : i[0]['distributor_id'];
      this.firstname = i[0]['user_first_name'] == null ? "" : i[0]['user_first_name'];
      this.lastname = i[0]['user_last_name'] == null ? "" : i[0]['user_last_name'];
      this.email = i[0]['user_email_address'] == null ? "" : i[0]['user_email_address'];
      this.password = i[0]['user_password'] == null ? "" : i[0]['user_password'];
      this.phoneNumber = i[0]['user_phone_number'] == null ? "" : i[0]['user_phone_number'];
      this.mobile = i[0]['user_mobile'] == null ? "" : i[0]['user_mobile'];
      this.user_status = i[0]['user_status'] == null ? "" : i[0]['user_status'];
      this.createdon = i[0]['createdon'] == null ? "" : i[0]['createdon'];
      this.modifiedon = i[0]['modifiedon'] == null ? "" : i[0]['modifiedon'];
    }
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
      this.modifiedon
    ];
  }
}
