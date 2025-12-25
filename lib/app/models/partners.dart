
import 'package:my_artist_demo/app/models/id_name_pair.dart';

class Partners {
  int? id;
  String? name;
  String? street;
  String? street2;
  String? city;
  IdNamePair? countryId;
  IdNamePair? stateId;
  String? zip;
  String? phone;
  String? mobile;
  String? email;
  String? image;
  String? base64String;

  Partners(
      {this.id,
      this.name,
      this.street,
      this.street2,
      this.city,
      this.countryId,
      this.stateId,
      this.zip,
      this.phone,
      this.mobile,
      this.email,
      this.image,
      this.base64String});

  static var fields = [
    "phone",
    "mobile",
    "street",
    "street2",
    "city",
    "state_id",
    "zip",
    "country_id",
    "name",
    "email"
  ];

  factory Partners.fromJson(Map i, String url) {
    return Partners(
        id: i["id"],
        name: i["name"] is! bool ? i["name"] : "",
        street: i['street'] is! bool ? i["street"] : "",
        street2: i['street2'] is! bool ? i["street2"] : "",
        city: i['city'] is! bool ? i["city"] : "",
        countryId: i['country_id'] is! bool
            ? IdNamePair.fromJson(i['country_id'])
            : null,
        stateId: i['state_id'] is! bool ? IdNamePair.fromJson(i['state_id']) : null,
        zip: i['zip'] is! bool ? i["zip"] : "",
        phone: i['phone'] is! bool ? i["phone"] : "",
        mobile: i['mobile'] is! bool ? i["mobile"] : "",
        email: i['email'] is! bool ? i["email"] : "",
        image: url,
        base64String : i.containsKey("image_1920") ?  i['image_1920'] is! bool ? i["image_1920"] : "":"",
    );
  }
}
