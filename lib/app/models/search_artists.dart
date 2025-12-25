


import 'package:my_artist_demo/app/models/artists.dart';
import 'package:my_artist_demo/app/models/category.dart';

import 'tags.dart';

class SearchArtists {
  int? id;
  List<Category>? listCategory;
  List<Tags>? listTags;
  List<Artists>? listArtists;
  List? listCity;

  SearchArtists();

  SearchArtists.fromJson(Map i, String serverUrl, String session) {
    id = i["id"];
    listCategory = i.containsKey('category_details')
        ? i['category_details'] is! bool
        ?
    i['category_details'].map((entry) => (Category.fromJson(entry,serverUrl,session))).toList().cast<Category>()
        : [] : [];

    listTags = i.containsKey('tag_details')
        ? i['tag_details'] is! bool
        ?
    i['tag_details'].map((entry) => (Tags.fromJson(entry,serverUrl,session))).toList().cast<Tags>()
        : [] : [];

    listArtists = i.containsKey('product_details')
        ? i['product_details'] is! bool
        ?
    i['product_details'].map((entry) => (Artists.fromJson(entry,serverUrl,session))).toList().cast<Artists>()
        : [] : [];

    listCity = i.containsKey('city_details')
        ? i['city_details'] is! bool
        ?
    i['city_details']
        : [] : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_details'] = listCategory;
    data['tag_details'] = listTags;
    data['product_details'] = listArtists;
    data['city_details'] = listCity;

    return data;
  }

}
