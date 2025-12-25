import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_artist_demo/app/models/category.dart';
import 'package:my_artist_demo/app/screens/artists/artists_list_screen.dart';
import 'package:my_artist_demo/app/services/odoo_response.dart';
import 'package:my_artist_demo/app/theme/theme_controller.dart';
import 'package:my_artist_demo/app/utility/images.dart';
import 'package:my_artist_demo/app/utility/styles.dart';
import 'package:my_artist_demo/app/widgets/custom_app_bar.dart';
import 'package:my_artist_demo/base.dart';

import '../../utility/color_constants.dart' show ColorConstants;


class CategoryTalentScreen extends StatefulWidget {
  const CategoryTalentScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return CategoryTalentScreenState();
  }
}

class CategoryTalentScreenState extends Base<CategoryTalentScreen> {
  final TextEditingController _searchQuery = TextEditingController();
  List<Category> _talentList = [];
  Widget appBarTitle = Text("Talents", style: poppinsBold);

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
      _talentList = [];
      getTalents("");
      _searchQuery.addListener(() {
        getTalents(_searchQuery.text, isSearch: true);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleWidget: appBarTitle, actions: <Widget>[
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
    );
  }

  void _handleSearchEnd() {
    setState(() {
      actionIcon = const Icon(Icons.search);
      appBarTitle = Text("Talents", style: poppinsBold);
      isLoading = false;
      _searchQuery.clear();
      _talentList.isNotEmpty ? isListFound = true : isListFound = false;
    });
  }

  RefreshIndicator body(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: Stack(children: [
        Container(
            color: Colors.white,
            padding: EdgeInsets.all(10.sp),
            child:
            ListView(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              children: [
            GridView.count(
              crossAxisCount: 2,
              // itemCount: category.categoryList.length,
              padding: EdgeInsets.only(left: 10.sp),
              physics: const NeverScrollableScrollPhysics(),
              // scrollDirection: Axis.horizontal,
              // childAspectRatio: (itemWidth / itemHeight),
              childAspectRatio: getDeviceType() == "phone" ? 2.0 : 2.5,
              shrinkWrap: true,
              children: List.generate(_talentList.length, (index) {
                Category category = _talentList[index];
                return InkWell(
                    onTap: () {
                      Get.to(
                          () => ArtistsListScreen(
                                talentId: category,
                              ),
                          transition: Transition.downToUp);
                    },
                    child: Card(
                      color: ColorConstants.buttonBgColor,
                      child: Container(
                        // width: 100.w,
                        margin: EdgeInsets.all(5.sp),
                        padding: EdgeInsets.all(5.sp),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Text(
                                category.name!,
                                style: textBoldWhite10px,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              )),
                              SizedBox(
                                  height: 40.h,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.r),
                                    child: CachedNetworkImage(
                                      imageUrl: category.image!,
                                      // placeholder: (context, url) => CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(Images.logo),
                                      fit: BoxFit.fill,
                                    ),
                                  )),
                            ]),
                      ),
                    ));
              }),
            )])

            // Column(
            //   children: [
            //     Expanded(child:
            //     ListView(
            //       shrinkWrap: true,
            //       physics: const ScrollPhysics(),
            //       children: [
            //         Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           children: [
            //             GridView.count(
            //               crossAxisCount: 3,
            //               // itemCount: category.categoryList.length,
            //               padding: EdgeInsets.only(
            //                   left: 10.sp),
            //               physics: const NeverScrollableScrollPhysics(),
            //               // scrollDirection: Axis.horizontal,
            //               // childAspectRatio: (itemWidth / itemHeight),
            //               childAspectRatio: 1.0,
            //               shrinkWrap: true,
            //               children: List.generate(
            //                   _talentList.length, (index) {
            //                 Category category = _talentList[index];
            //                 return
            //                   InkWell(
            //                     onTap: () {
            //                       Get.to(() =>
            //                           ArtistsListScreen(
            //                             talentId: category,),
            //                           transition: Transition.downToUp);
            //                     },
            //                     child:
            //                     // Card(
            //                     //   // color: ColorConstants.buttonBgColor,
            //                     //   child:
            //                       Container(
            //                         // width: 100.w,
            //                         margin: EdgeInsets.all(5.sp),
            //                         padding: EdgeInsets.all(5.sp),
            //                         child:
            //                         Column(
            //                             crossAxisAlignment:
            //                             CrossAxisAlignment.center,
            //                             mainAxisAlignment: MainAxisAlignment
            //                                 .center,
            //                             children: [
            //                               CachedNetworkImage(
            //                                 imageUrl: category.image!,
            //                                 // placeholder: (context, url) => Center( child : CircularProgressIndicator()),
            //                                 errorWidget: (context, url,
            //                                     error) =>
            //                                     Image.asset(Images.logo,
            //                                         fit: BoxFit.fill,
            //                                         width: 40.w,
            //                                         height: 40.h),
            //                                 fit: BoxFit.fill,
            //                                 width: 40.w,
            //                                 height: 40.h,
            //                               ),
            //                               SizedBox(height: 5.h),
            //
            //                               Text(category.name!,
            //                                   maxLines: 2,
            //                                   textAlign: TextAlign.center,
            //                                   style: textBold10px),
            //
            //                             ]),
            //                       ),
            //                     // )
            //
            //
            //                   );
            //               }),
            //             )
            //           ],
            //         )
            //       ],
            //     )),
            //   ],
            // )

            ),
        !isListFound ? showEmptyList() : Container(),
      ]),
      // )
    );
  }

  getTalents(String query, {bool isSearch = false}) {
    isNetworkConnected().then((isInternet) async {
      if (isInternet) {
        setState(() {
          isLoading = true;
        });
        Map<String, dynamic> values = {};
        await odoo.callShowTalents(values).then((OdooResponse res) async {
          if (!res.hasError()) {
            setState(() {
              isLoading = false;
              if (query != "" || isSearch) {
                _talentList.clear();
              }
              for (var record in res.getResult()["category_details"]) {
                Category tags =
                    Category.fromJson(record, getURL(), getSession());
                _talentList.add(tags);
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

  String getDeviceType() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.shortestSide < 600 ? 'phone' : 'tablet';
  }
}
