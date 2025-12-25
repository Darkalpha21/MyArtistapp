import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_artist_demo/app/models/artists.dart';
import 'package:my_artist_demo/app/models/category.dart';
import 'package:my_artist_demo/app/models/filter_artists.dart';
import 'package:my_artist_demo/app/models/tags.dart';
import 'package:my_artist_demo/app/screens/artists/artists_details_screen.dart';
import 'package:my_artist_demo/app/services/odoo_response.dart';
import 'package:my_artist_demo/app/theme/theme_controller.dart';
import 'package:my_artist_demo/app/utility/images.dart';
import 'package:my_artist_demo/app/utility/styles.dart';
import 'package:my_artist_demo/app/widgets/custom_app_bar.dart';
import 'package:my_artist_demo/base.dart';

class FavoritesArtistsListScreen extends StatefulWidget {

  final Category? talentId;
  final Tags? tagId;

  const FavoritesArtistsListScreen({super.key, this.talentId, this.tagId});

  @override
  State<StatefulWidget> createState() {
    return FavoritesArtistsListScreenState();
  }
}

class FavoritesArtistsListScreenState extends Base<FavoritesArtistsListScreen> {
  final TextEditingController _searchQuery = TextEditingController();
  List<Artists> _contactList = [];
  Widget appBarTitle = Text("My Favorites", style: poppinsBold);
  FilterArtists? filterArtists;
  bool isFilter = false;

  @override
  void initState() {
    super.initState();
    getOdooInstance().then((odoo) {
      _refresh();
    });
  }

  Future<void> _refresh() async {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 0), () {
      completer.complete(null);
    });
    return completer.future.then((_) {
      _contactList = [];
      fetchDetails("");
      _searchQuery.addListener(() {
        fetchDetails(_searchQuery.text, isSearch: true);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          titleWidget: appBarTitle,
          isBackButtonExist: false,
          actions: <Widget>[
            IconButton(
              icon: actionIcon,
              onPressed: () {
                setState(() {
                  if (actionIcon.icon == Icons.search) {
                    actionIcon = const Icon(Icons.close);
                    appBarTitle = TextField(
                      controller: _searchQuery,
                      style: ThemeService().getDarkTheme()
                          ? textBoldWhite
                          : poppinsBold,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search,
                              color: ThemeService().getDarkTheme()
                                  ? Colors.white
                                  : Colors.grey),
                          hintText: "Search...",
                          hintStyle: poppinsRegular.copyWith(
                              color: ThemeService().getDarkTheme()
                                  ? Colors.white
                                  : Colors.grey)),
                    );
                  } else {
                    _handleSearchEnd();
                  }
                });
              },
            ),
          ]),
      body: body(context),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // floatingActionButton:
      // FloatingActionButton.extended(
      //   tooltip: 'Save',
      //   heroTag: 'fab',
      //   icon: const Icon(Icons.done),
      //   label: Text('Create', style: poppinsBold),
      //   onPressed: () {
      //     _awaitReturnValueFromCreateFoodItemScreen(context);
      //   },
      // ),
    );
  }

  void _handleSearchEnd() {
    setState(() {
      actionIcon = const Icon(Icons.search);
      appBarTitle = Text("My Favorites", style: poppinsBold);
      isLoading = false;
      _searchQuery.clear();
      _contactList.isNotEmpty ? isListFound = true : isListFound = false;
    });
  }

  RefreshIndicator body(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: Stack(children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: _contactList.length + 1,
            physics: const ScrollPhysics(),
            itemBuilder: (context, index) {
              if (index == _contactList.length) {
                return buildProgressIndicator();
              } else {
                Artists products = _contactList[index];
                String categoryDisplay = "";
                String tagDisplay = "";
                for (var category in products.productCategoryData!){
                  if(categoryDisplay != "")
                  {
                    categoryDisplay += ", ${category.name!.trimLeft()}";
                  }
                  else
                  {
                    categoryDisplay = category.name!.trimLeft();
                  }
                }

                for (var tag in products.productTagData!){
                  if(tagDisplay != "")
                  {
                    tagDisplay += ", ${tag.name!.trimLeft()}";
                  }
                  else
                  {
                    tagDisplay = tag.name!.trimLeft();
                  }
                }

                return Card(
                  margin: EdgeInsets.all(10.sp),
                  elevation: 10.0,
                  color:
                  ThemeService().getDarkTheme() ? Colors.black : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8.r),
                    onTap: () async {
                      await Get.to(() => ArtistsDetailsScreen(artists: products,), transition: Transition.downToUp);
                      showData(products.id!, index);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          vertical: 10.sp, horizontal: 10.sp),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                                width: 100.w,
                                height: 120.h,
                        child:
                              CachedNetworkImage(
                                imageUrl: products.image!,
                                placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Image.asset(Images.logo,
                                      fit: BoxFit.fill,
                                     ),
                                fit: BoxFit.fill,
                            )),

                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              child:
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[

                                  Text(products.name!, style: poppinsBold),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(child:
                                      Text(
                                          categoryDisplay,
                                          style: textRegular12px),
                                      ),

                                      Expanded(child:
                                      Row(
                                          children: [
                                            Image.asset(Images.marker,
                                            height: 16.h, width: 16.w,),
                                      SizedBox(width: 5.w,),
                                      Expanded(child:
                                      Text(
                                          "${products.artistCity}",
                                          style: textRegular12px))

                                          ])
                                      ),

                                    ],
                                  ),
                                  SizedBox(height: 5.h,),
                                  Text(
                                      tagDisplay,
                                      style: textRegular12px),
                                  products.privatePrice != 0.0 && products.corporatePrice != 0.0 ?
                                      SizedBox(height: 5.h,)
                                      :
                                      const SizedBox(),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      products.privatePrice != 0.0 ?
                                      Expanded(
                                          child:
                                          Text(
                                              "${getCurrencySymbol(products.currencyId?.name ?? "")} ${Base.dp(products.privatePrice!, 2)}",
                                              style: textBoldGreen16px))  :
                                      products.privatePrice == 0.0 && products.corporatePrice != 0.0?
                                      Expanded(
                                          child:
                                          Text(
                                              "${getCurrencySymbol(products.currencyId?.name ?? "")} ${Base.dp(products.corporatePrice!, 2)}",
                                              style: textBoldGreen16px)) : const SizedBox(),

                                      IconButton(
                                        onPressed: () {
                                          addRemoveFavorites(products, index);
                                        },
                                        icon: products.isFavorite!
                                            ? const Icon(Icons.favorite)
                                            : const Icon(Icons.favorite_border),
                                        color: Colors.red,
                                        iconSize: 24.sp,
                                      ),

                                    ],
                                  )


                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
          ),

        !isListFound ? showEmptyList() : Container(),
      ]),
      // )
    );
  }

  fetchDetails(String query, {bool isSearch = false}) {
    isNetworkConnected().then((isInternet) async {
      if (isInternet) {
        setState(() {
          isLoading = true;
        });
        Map<String, dynamic> values = {};
        if (query != "" || isSearch) {
          values["search_text"] = query;
        }
        values["partner_id"] = getUser()!.partnerId;
        await odoo.callShowFavorites(values).then((OdooResponse res) async {
          if (!res.hasError()) {
            setState(() {
              isLoading = false;
              if (query != "" || isSearch) {
                _contactList.clear();
              }
              for (var record in res.getResult()["product_details"]) {
                Artists products =
                    Artists.fromJson(record, getURL(), getSession());
                _contactList.add(products);
              }
              if (_contactList.isEmpty) {
                isListFound = false;
              } else {
                isListFound = true;
              }
            });
          } else {
            setState(() {
              isLoading = false;
            });
            showMessage("Warning", res.getErrorMessage());
          }
        });
      }
    });
  }

  addRemoveFavorites(Artists artists, int pos) {
    Map<String, dynamic> values = {};
    values["partner_id"] = getUser()!.partnerId;
    values["product_id"] = artists.id;
    values["is_favorite"] = artists.isFavorite;
    isNetworkConnected().then((isInternet) {
      if (isInternet) {
        odoo.addRemoveFavorites(
            values
        ).then((OdooResponse res) {
          if (!res.hasError()) {
            if (res.getResult()["status"] == true)
            {
              _contactList.removeAt(pos);
              setState(() {
              });
            }
            else
            {
              showMessage("Alert", res.getResult()["message"]);
            }
          } else {
            showMessage("Error", res.getErrorMessage());
          }
        });
      }
    });
  }
  showData(int id, int pos) {
    isNetworkConnected().then((isInternet) async {
      if (isInternet) {
        Map<String, dynamic> values = {};
        values["partner_id"] = getUser()!.partnerId;
        values["product_id"] = id;
        await odoo.callShowArtists(values).then((OdooResponse res) async {
          if (!res.hasError()) {
            setState(() {
              for (var record in res.getResult()["product_details"]) {
                Artists products =
                Artists.fromJson(record, getURL(), getSession());
                _contactList[pos] = products;
              }
            });
          } else {
            showMessage("Warning", res.getErrorMessage());
          }
        });
      }
    });
  }
}
