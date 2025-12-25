
import 'package:my_artist_demo/app/utility/strings.dart';

class Tags {
  int? id;
  String? name;
  String? image;


  Tags();

  Tags.fromJson(Map<String, dynamic> json, String serverUrl, String session) {
    id = json['id'];
    name = json['name'] is! bool ? json["name"] : "";
    image = "$serverUrl/web/content?model=${Strings.product_tag}&field=image&id=${json["id"]}&$session";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }



}
