class Groups {
  bool? groupPortal;
  bool? groupUser;
  bool? groupSaleManager;

  Groups({this.groupPortal, this.groupUser, this.groupSaleManager});

  Groups.fromJson(Map<String, dynamic> json) {
    groupPortal = json['group_portal'];
    groupUser = json['group_user'];
    groupSaleManager = json['group_sale_manager'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['group_portal'] = groupPortal;
    data['group_user'] = groupUser;
    data['group_sale_manager'] = groupSaleManager;

    return data;
  }
}