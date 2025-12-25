
import 'package:my_artist_demo/app/models/id_name_pair.dart';

class Company {
  int? id;
  String? name;
  IdNamePair? currencyId;
  String? phone;
  String? email;

  Company({
    this.id,
    this.name,
    this.currencyId,
    this.phone,
    this.email
  });

  factory Company.fromJson(Map i) {
    return Company(
      id: i["id"],
      name: i["name"] is! bool ? i["name"] : "",
      currencyId: i['currency_id'] is! bool
          ? IdNamePair.fromJson(i['currency_id'])
          : null,
        phone: i["phone"] is! bool ? i["phone"] : "",
      email: i["email"] is! bool ? i["email"] : "",
    );
  }

}
