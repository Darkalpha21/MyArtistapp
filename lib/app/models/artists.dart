

import 'package:my_artist_demo/app/models/category.dart';
import 'package:my_artist_demo/app/models/id_name_pair.dart';
import 'package:my_artist_demo/app/models/tags.dart';
import 'package:my_artist_demo/app/models/video_link.dart';
import 'package:my_artist_demo/app/utility/strings.dart';

class Artists {
  int? id;
  String? name;
  double? privatePrice;
  double? corporatePrice;
  String? image;
  String? backgroundImage;
  String? artistCity;
  List<VideoLink>? videoLinkData;
  String? description;
  List? publicCategIds;
  List? productTagIds;
  List<Tags>? productTagData;
  List<Category>? productCategoryData;
  IdNamePair? currencyId;
  bool? isFavorite;

  Artists({
    this.id,
    this.name,
    this.privatePrice,
    this.corporatePrice,
    this.artistCity,
    this.videoLinkData,
    this.description,
    this.publicCategIds,
    this.productTagIds,
    this.image,
    this.backgroundImage,
    this.productTagData,
    this.productCategoryData,
    this.currencyId,
    this.isFavorite
  });

  factory Artists.fromJson(Map i, String serverUrl, String session) {
    String image = "";
    image = "$serverUrl/web/content?model=${Strings.product_product}&field=image_1920&id=${i["id"]}&$session";
    String bgImage = "";
    bgImage = "$serverUrl/web/content?model=${Strings.product_product}&field=background_image&id=${i["id"]}&$session";
    return Artists(
      id: i["id"],
      name: i["name"] is! bool ? i["name"] : "",
      privatePrice: i["private_price"] is! bool ? i["private_price"] :0.0,
      corporatePrice: i["corporate_price"] is! bool ? i["corporate_price"] :0.0,
      artistCity: i["artist_city"] is! bool ? i["artist_city"] : "",

      videoLinkData: i.containsKey('video_url_data')
          ? i['video_url_data'] is! bool ?
      i['video_url_data'].map((entry) => (VideoLink.fromJson(entry))).toList().cast<VideoLink>()
          : [] : [],

      description: i["description"] is! bool ? i["description"] : "",
      publicCategIds: i['public_categ_ids']is! bool ? i["public_categ_ids"] :[],
        image: image,
      backgroundImage: bgImage,
      productTagIds: i["product_tag_ids"] is! bool ? i["product_tag_ids"] :[],
      productTagData: i.containsKey('product_tag_data')
          ? i['product_tag_data'] is! bool
          ?
      i['product_tag_data'].map((entry) => (Tags.fromJson(entry,serverUrl,session))).toList().cast<Tags>()
          : [] : [],

      productCategoryData: i.containsKey('product_categ_data')
          ? i['product_categ_data'] is! bool ?
      i['product_categ_data'].map((entry) => (Category.fromJson(entry,serverUrl,session))).toList().cast<Category>()
          : [] : [],

        currencyId: i['currency_id'] is! bool
            ? IdNamePair.fromJson(i['currency_id'])
            : null,
      isFavorite: i["is_favorite"],
    );
  }


}
