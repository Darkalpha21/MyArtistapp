

import 'package:my_artist_demo/app/models/groups.dart';

class User {
  String? sessionId;
  int? uid;
  bool? isAdmin;
  String? db;
  String? name;
  String? username;
  String? mobile;
  int? companyId;
  int? partnerId;
  String? email;
  String? imageUrl;
  bool? isSubscriber;
  Groups? groups;

  User(
      {this.sessionId,
      this.uid,
      this.isAdmin,
      this.db,
      this.name,
      this.companyId,
      this.partnerId,
      this.email,
      this.imageUrl,
      this.mobile,
      this.isSubscriber,
      this.username,
      this.groups});

  User.fromJson(Map<String, dynamic> json) {
    sessionId = json['session_id'];
    uid = json['uid'] is! bool ? json['uid'] : 0;
    isAdmin = json['is_admin'];
    db = json['db'] is! bool ? json['db'] : "N/A";
    name = json['name'] is! bool ? json['name'] : "N/A";
    username = json['username'] is! bool ? json['username'] : "N/A";
    companyId = json['company_id'];
    partnerId = json['partner_id'];
    isSubscriber = json['is_subscriber'];
    groups = json['groups'] != null ? Groups.fromJson(json['groups']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['session_id'] = sessionId;
    data['uid'] = uid;
    data['is_admin'] = isAdmin;
    data['db'] = db;
    data['username'] = username;
    data['name'] = name;
    data['company_id'] = companyId;
    data['partner_id'] = partnerId;
    data['is_subscriber'] = isSubscriber;
    data['groups'] = groups!.toJson();
    return data;
  }
}

class UserContext {
  String? lang;
  String? tz;
  int? uid;

  UserContext({this.lang, this.tz, this.uid});

  UserContext.fromJson(Map<String, dynamic> json) {
    lang = json['lang'] is! bool ? json['lang'] : "N/A";
    tz = json['tz'] is! bool ? json['tz'] : "N/A";
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lang'] = lang;
    data['tz'] = tz;
    data['uid'] = uid;
    return data;
  }
}
