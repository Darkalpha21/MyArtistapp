import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_artist_demo/app/models/artists.dart';
import 'package:my_artist_demo/app/models/category.dart';
import 'package:my_artist_demo/app/models/search_artists.dart';
import 'package:my_artist_demo/app/models/tags.dart';
import 'package:my_artist_demo/app/screens/artists/artists_details_screen.dart';
import 'package:my_artist_demo/app/screens/artists/artists_list_screen.dart';
import 'package:my_artist_demo/app/services/odoo_response.dart';
import 'package:my_artist_demo/app/theme/theme_controller.dart';
import 'package:my_artist_demo/app/utility/images.dart';
import 'package:my_artist_demo/app/utility/styles.dart';
import 'package:my_artist_demo/app/widgets/custom_text_field.dart';
import 'package:my_artist_demo/base.dart';


class SearchArtistsScreen extends StatefulWidget {
  const SearchArtistsScreen({super.key});

  @override
  SearchArtistsScreenState createState() =>
      SearchArtistsScreenState();
}

class SearchArtistsScreenState
    extends Base<SearchArtistsScreen> {
  TextEditingController searchController = TextEditingController();
  SearchArtists? searchArtists;

  @override
  void initState() {
    super.initState();
    getOdooInstance().then((odoo) {
      _refresh();
    });
  }

  Future<void> _refresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 0), () {
      completer.complete(null);
    });
    return completer.future.then((_) {
      // fetchDetails("");
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child:
            SingleChildScrollView(
              child:

        Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.sp),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.arrow_back_ios)),
                      SizedBox(height: 10.h),
                      Expanded(
                        child:
                        CustomTextField(
                          autofocus: true,
                          hintText: "Search Artists Here",
                          isShowBorder: true,
                          isShowSuffixIcon: true,
                          isShowPrefixIcon: true,
                          isDense:false,
                          // suffixIconUrl: Images.close,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.black87,
                            size: 24.sp,
                          ),
                          suffixIcon:
                          InkWell(
                            onTap: ()
                            {
                              Navigator.pop(context);
                            },
                            child:
                            Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 24.sp,
                            ),
                          ),
                          controller: searchController,
                          inputAction: TextInputAction.search,
                          isIcon: true,
                          onSubmit: (text) {
                            if (searchController.text.isNotEmpty) {
                             //  searchProvider
                             //      .saveSearchAddress(searchController.text);
                             //  searchProvider.searchProduct(
                             //      searchController.text,Provider.of<BranchProvider>(context, listen: false).selectBranch!.id!, context, mounted);
                             // push(SearchResultScreen(searchString: searchController.text));
                            }
                          },
                          onChanged: (String newChar)
                          {
                            fetchDetails(newChar);
                          },
                        ),

                      ),
                      // TextButton(
                      //     onPressed: () {
                      //       Navigator.pop(context);
                      //     },
                      //     child: Text(
                      //      "Cancel",
                      //       style: textBoldRed
                      //     ))
                    ],
                  ),
                  // for resent search section
                  SizedBox(height: 20.h),
                  searchArtists != null && searchArtists!.listCategory!.isNotEmpty ?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Talents",
                        style: textBold18px
                      ),
                      Divider(
                        color: ThemeService().getDarkTheme() ? Colors.white : Colors.grey,
                      ),


                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchArtists!.listCategory!.length,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                            Category category = searchArtists!.listCategory![index];
                            return
                              InkWell(
                                onTap: () {
                                  Get.to(() =>
                                      ArtistsListScreen(
                                        talentId: category,),
                                      transition: Transition.downToUp);
                                },
                                child:
                                // Card(
                                //   // color: ColorConstants.buttonBgColor,
                                //   child:
                                Container(
                                  // width: 100.w,
                                  margin: EdgeInsets.all(5.sp),
                                  padding: EdgeInsets.all(5.sp),
                                  child:
                                  Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: category.image!,
                                          // placeholder: (context, url) => Center( child : CircularProgressIndicator()),
                                          errorWidget: (context, url,
                                              error) =>
                                              Image.asset(Images.logo,
                                                  fit: BoxFit.fill,
                                                  width: 40.w,
                                                  height: 40.h),
                                          fit: BoxFit.fill,
                                          width: 40.w,
                                          height: 40.h,
                                        ),
                                        SizedBox(width: 10.w),

                                        Expanded(
                                          child:
                                        Text(category.name!,
                                            maxLines: 2,
                                            style: poppinsBold)),

                                      ]),
                                ),
                                // )

                              );
                        },
                      ),

                    ],
                  ) : const SizedBox(),
                  searchArtists != null && searchArtists!.listCategory!.isNotEmpty ?
                  SizedBox(height: 10.h) : const SizedBox(),

                  searchArtists != null && searchArtists!.listTags!.isNotEmpty ?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Categories",
                          style: textBold18px
                      ),
                      Divider(
                        color: ThemeService().getDarkTheme() ? Colors.white : Colors.grey,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchArtists!.listTags!.length,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                          Tags tag = searchArtists!.listTags![index];
                          return
                              InkWell(
                                onTap: () {
                                  Get.to(() => ArtistsListScreen(tagId: tag,), transition: Transition.downToUp);
                                },
                                child:
                                Container(
                                  // width: 100.w,
                                  margin: EdgeInsets.all(5.sp),
                                  padding: EdgeInsets.all(5.sp),
                                  child:
                                  Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: tag.image!,
                                          // placeholder: (context, url) => Center( child : CircularProgressIndicator()),
                                          errorWidget: (context, url,
                                              error) =>
                                              Image.asset(Images.logo,
                                                  fit: BoxFit.fill,
                                                  width: 40.w,
                                                  height: 40.h),
                                          fit: BoxFit.fill,
                                          width: 40.w,
                                          height: 40.h,
                                        ),
                                        SizedBox(width: 10.w),

                                        Expanded(
                                            child:
                                            Text(tag.name!,
                                                maxLines: 2,
                                                style: poppinsBold)),

                                      ]),
                                ));
                        },
                      ),
                    ],
                  ) : const SizedBox(),
                  searchArtists != null && searchArtists!.listTags!.isNotEmpty ?
                  SizedBox(height: 10.h) : const SizedBox(),

                  searchArtists != null && searchArtists!.listArtists!.isNotEmpty ?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Artists",
                          style: textBold18px
                      ),
                      Divider(
                        color: ThemeService().getDarkTheme() ? Colors.white : Colors.grey,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchArtists!.listArtists!.length,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                          Artists artists = searchArtists!.listArtists![index];
                          return
                              InkWell(
                                onTap: () async {
                                 await Get.to(() => ArtistsDetailsScreen(artists: artists,), transition: Transition.downToUp);
                                 showData(artists.id!, index);
                                },
                                child:
                                Container(
                                  // width: 100.w,
                                  margin: EdgeInsets.all(5.sp),
                                  padding: EdgeInsets.all(5.sp),
                                  child:
                                  Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: artists.image!,
                                          // placeholder: (context, url) => Center( child : CircularProgressIndicator()),
                                          errorWidget: (context, url,
                                              error) =>
                                              Image.asset(Images.logo,
                                                  fit: BoxFit.fill,
                                                  width: 40.w,
                                                  height: 40.h),
                                          fit: BoxFit.fill,
                                          width: 40.w,
                                          height: 40.h,
                                        ),
                                        SizedBox(width: 10.w),

                                        Expanded(
                                            child:
                                            Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment
                                                    .start,
                                                children: [
                                            Text(artists.name!,
                                                maxLines: 2,
                                                style: poppinsBold),
                                                  Text(artists.artistCity!,
                                                      maxLines: 1,
                                                      style: textRegular12px)

                                        ])),

                                      ]),
                                ),
                          );
                        },
                      ),
                    ],
                  ) : const SizedBox(),
                  searchArtists != null && searchArtists!.listArtists!.isNotEmpty ?
                  SizedBox(height: 10.h) : const SizedBox(),


                  searchArtists != null && searchArtists!.listCity!.isNotEmpty ?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "City",
                          style: textBold18px
                      ),
                      Divider(
                        color: ThemeService().getDarkTheme() ? Colors.white : Colors.grey,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchArtists!.listCity!.length,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                          String city = searchArtists!.listCity![index];
                          return
                            InkWell(
                              onTap: () {
                                Get.to(() => ArtistsListScreen(city: city,), transition: Transition.downToUp);
                              },
                              child:
                              Container(
                                // width: 100.w,
                                margin: EdgeInsets.all(5.sp),
                                padding: EdgeInsets.all(5.sp),
                                child:
                                Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment
                                        .start,
                                    children: [
                                      Expanded(
                                          child:
                                          Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(city,
                                                    maxLines: 2,
                                                    style: poppinsBold),
                                              ])),

                                    ]),
                              ),
                            );
                        },
                      ),
                    ],
                  ) : const SizedBox(),
                  searchArtists != null && searchArtists!.listArtists!.isNotEmpty ?
                  SizedBox(height: 20.h) : const SizedBox(),

                ],
              ),
            )),
      ),
    );
  }

  fetchDetails(String query) {
    isNetworkConnected().then((isInternet) async {
      if (isInternet) {
        Map<String, dynamic> values = {};
        if (query != "") {
          values["search_text"] = query;
        }
        values["offset"] = offset;
        values["limit"] = limit;
        values["partner_id"] = getUser()!.partnerId;
        await odoo.searchArtist(values).then((OdooResponse res) async {
          if (!res.hasError()) {
            setState(() {
              searchArtists = SearchArtists.fromJson(res.getResult(), getURL(), getSession());
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
                searchArtists!.listArtists![pos] = products;
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
