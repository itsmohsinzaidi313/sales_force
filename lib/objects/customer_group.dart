class CustomerGroup{
  String customer_group_id;
  String name;
  CustomerGroup({this.customer_group_id, this.name});

  getList(){
    return [this.customer_group_id, this.name];
  }
}