class UserType {
  String user_type_id;
  String title;
  String permission;

  UserType({this.user_type_id, this.title, this.permission});

  getList() {
    return [this.user_type_id, this.title, this.permission];
  }
}