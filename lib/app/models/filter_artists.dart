

import 'package:my_artist_demo/app/models/category.dart';

import 'tags.dart';

class FilterArtists {

  double? minPrice;
  double? maxPrice;
  List<Category>? talent;
  List<Tags>? tags;
  String? city;

  FilterArtists({
    this.minPrice,
    this.maxPrice,
    this.talent,
    this.tags,
    this.city

  });
}





