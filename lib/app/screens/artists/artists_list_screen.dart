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
import 'package:my_artist_demo/app/screens/artists/filter_artists_bottom_dialog.dart';
import 'package:my_artist_demo/app/services/odoo_response.dart';
import 'package:my_artist_demo/app/theme/theme_controller.dart';
import 'package:my_artist_demo/app/utility/color_constants.dart';
import 'package:my_artist_demo/app/utility/images.dart';
import 'package:my_artist_demo/app/utility/styles.dart';
import 'package:my_artist_demo/app/widgets/custom_app_bar.dart';
import 'package:my_artist_demo/base.dart';


class ArtistsListScreen extends StatefulWidget {

  final Category? talentId;
  final Tags? tagId;
  final String? city;

  const ArtistsListScreen({super.key, this.talentId, this.tagId, this.city});

  @override
  State<StatefulWidget> createState() {
    return ArtistsListScreenState();
  }
}

class ArtistsListScreenState extends Base<ArtistsListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchQuery = TextEditingController();
  List<Artists> _contactList = [];
  String title = "Artists";
  Widget? appBarTitle;
  FilterArtists? filterArtists;
  bool isFilter = false;

  @override
  void initState() {
    super.initState();
    if(widget.talentId != null)
      {
        title =widget.talentId!.name!;
      }
    if(widget.tagId != null)
    {
      title =widget.tagId!.name!;
    }
    if(widget.city != null)
    {
      title =widget.city!;
    }
    appBarTitle = Text(title, style: poppinsBold.copyWith(fontSize: 16.sp, color:
    ThemeService().getDarkTheme() ?  Colors.white : ColorConstants.black));
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
      offset = 0;
      fetchDetails("");
      _searchQuery.addListener(() {
        fetchDetails(_searchQuery.text, isSearch: true);
      });
      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          if (_searchQuery.text == "" || _searchQuery.text.isEmpty) {
            offset = offset + limit;
            fetchDetails("");
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          titleWidget: appBarTitle,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.filter_list_alt,
                  color: ThemeService().getDarkTheme()
                      ? Colors.white
                      : Colors.black,
                  size: 30.sp),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  isDismissible: true,
                  backgroundColor: Colors.transparent,
                  builder: (con) => FilterArtistsBottomDialogScreen(
                    filterArtists: filterArtists,
                    onTap: (filter) {
                      Navigator.pop(context);
                      filterArtists = filter;
                      _contactList.clear();
                      isFilter = true;
                      fetchDetails("");
                    },
                  ),
                );
              },
            ),
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
      appBarTitle = Text(title, style: poppinsBold.copyWith(fontSize: 16.sp, color:
      ThemeService().getDarkTheme() ?  Colors.white : ColorConstants.black));
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
                      showData(products.id!,index);
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
                                // placeholder: (context, url) => const CircularProgressIndicator(),
                                placeholder: (context, url) =>
                                    Image.asset(Images.logo,
                                      fit: BoxFit.fill,
                                    ),
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
            controller: _scrollController,
          ),

        !isListFound ? showEmptyList() : Container(),
      ]),
      // )
    );
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
                _contactList[pos].isFavorite = !artists.isFavorite!;
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

  fetchDetails(String query, {bool isSearch = false}) async {
    final isInternet = await isNetworkConnected();
    if (!isInternet) {
      print("No internet connection");
      return;
    }

    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> values = {
      "offset": (query.isNotEmpty || isSearch) ? 0 : offset,
      "limit": limit,
      "partner_id": getUser()?.partnerId ?? 0,
    };

    if (query.isNotEmpty || isSearch) {
      values["search_text"] = query;
      offset = 0;
    }

    if (isFilter) {
      isFilter = false;
      _contactList.clear();
      offset = 0;
      values["is_filter"] = true;

      // talents
      if (filterArtists?.talent != null) {
        values["filter_categ_id"] =
            filterArtists!.talent!.map((t) => t.id).toList();
      }

      // tags
      if (filterArtists?.tags != null) {
        values["filter_product_tag_ids"] =
            filterArtists!.tags!.map((t) => t.id).toList();
      }

      // price range
      if (filterArtists?.minPrice != null) {
        values["filter_min_price"] = filterArtists!.minPrice;
      }
      if (filterArtists?.maxPrice != null) {
        values["filter_max_price"] = filterArtists!.maxPrice;
      }

      // city
      if (filterArtists?.city != null) {
        values["filter_artist_city"] = filterArtists!.city;
      }
    } else {
      if (widget.talentId != null) {
        values["talent_ids"] = [widget.talentId!.id];
      }
      if (widget.tagId != null) {
        values["tag_ids"] = [widget.tagId!.id];
      }
      if (widget.city != null) {
        values["artist_city"] = widget.city;
      }
    }

    try {
      final res = await odoo.callShowArtists(values);
      if (!res.hasError()) {
        final result = res.getResult();
        final productDetails = result?["product_details"];

        if (productDetails == null) {
          print("No product_details found in response: $result");
          setState(() {
            isLoading = false;
            isListFound = false;
          });
          return;
        }

        setState(() {
          isLoading = false;
          if (query.isNotEmpty || isSearch) {
            _contactList.clear();
          }

          for (var record in productDetails) {
            _contactList.add(
              Artists.fromJson(record, getURL(), getSession()),
            );
          }

          isListFound = _contactList.isNotEmpty;
        });
      } else {
        setState(() {
          isLoading = false;
          isListFound = false;
        });
        showMessage("Warning", res.getErrorMessage());
      }
    } catch (e, stack) {
      print("Error in fetchDetails: $e");
      print(stack);
      setState(() {
        isLoading = false;
        isListFound = false;
      });
    }
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
