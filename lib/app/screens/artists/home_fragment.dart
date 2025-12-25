import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_artist_demo/app/models/artists.dart';
import 'package:my_artist_demo/app/models/category.dart';
import 'package:my_artist_demo/app/models/tags.dart';
import 'package:my_artist_demo/app/screens/artists/artists_details_screen.dart';
import 'package:my_artist_demo/app/screens/artists/artists_list_screen.dart';
import 'package:my_artist_demo/app/screens/artists/category_tags_screen.dart';
import 'package:my_artist_demo/app/screens/artists/category_talent_screen.dart';
import 'package:my_artist_demo/app/screens/artists/search_artist_screen.dart';
import 'package:my_artist_demo/app/services/odoo_response.dart';
import 'package:my_artist_demo/app/theme/theme_controller.dart';
import 'package:my_artist_demo/app/utility/color_constants.dart';
import 'package:my_artist_demo/app/utility/images.dart';
import 'package:my_artist_demo/app/utility/styles.dart';
import 'package:my_artist_demo/base.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({super.key});

  @override
  State<StatefulWidget> createState() => HomeFragmentState();
}

class HomeFragmentState extends Base<HomeFragment> {
  int _partnerRetryCount = 0;
  final TextEditingController _searchQuery = TextEditingController();
  List<Artists> _contactList = [];
  List<Category> _categoryList = [];
  List<Tags> _tagList = [];

  @override
  void initState() {
    super.initState();
    getOdooInstance().then((odoo) {
      _refresh();
    });
  }

  Future<void> _refresh() async {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(milliseconds: 100), () {
      completer.complete(null);
    });
    return completer.future.then((_) {
      _contactList = [];
      offset = 0;
      getCategory();
      fetchDetails('', isSearch: false);

      _searchQuery.addListener(() {
        fetchDetails(_searchQuery.text, isSearch: true);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = ThemeService().getDarkTheme();

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF9F9F9),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: ColorConstants.android_red_dark,
        child: Padding(
          padding: EdgeInsets.all(12.sp),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                systemOverlayStyle: isDark
                    ? SystemUiOverlayStyle.light
                    : SystemUiOverlayStyle.dark,
                title: Text(
                  'My Artists',
                  style: poppinsBold.copyWith(fontSize: 20.sp),
                ),
              ),

              /// MAIN CONTENT
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// SEARCH BAR
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.sp),
                      decoration: BoxDecoration(
                        color:
                        isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(14.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        readOnly: true,
                        onTap: () {
                          Get.to(
                                () => const SearchArtistsScreen(),
                            transition: Transition.downToUp,
                          );
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: const Icon(Icons.search),
                          hintText: 'Search artists, categories, tags',
                          hintStyle: textRegularGrey12px,
                        ),
                      ),
                    ),

                    SizedBox(height: 16.h),

                    /// TAGS
                    SizedBox(
                      height: 90.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _tagList.length + 1,
                        itemBuilder: (context, index) {
                          if (index == _tagList.length) {
                            return _tagList.length > 5
                                ? _buildViewMore()
                                : const SizedBox();
                          }
                          final tag = _tagList[index];
                          return _buildTagItem(tag);
                        },
                      ),
                    ),

                    SizedBox(height: 12.h),

                    /// ARTISTS HEADER
                    _sectionHeader('Artists', onTap: () {
                      Get.to(
                            () => const ArtistsListScreen(),
                        transition: Transition.downToUp,
                      );
                    }),

                    SizedBox(
                      height: 250.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _contactList.length > 10
                            ? 10
                            : _contactList.length,
                        itemBuilder: (context, index) {
                          final products = _contactList[index];
                          return _buildArtistCard(products, index);
                        },
                      ),
                    ),

                    SizedBox(height: 16.h),

                    /// TALENTS HEADER
                    _sectionHeader('Talents', onTap: () {
                      Get.to(
                            () => const CategoryTalentScreen(),
                        transition: Transition.downToUp,
                      );
                    }),

                    SizedBox(height: 8.h),

                    GridView.count(
                      crossAxisCount: 2,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      childAspectRatio:
                      getDeviceType() == 'phone' ? 2.1 : 2.6,
                      children:
                      List.generate(_categoryList.length, (index) {
                        final category = _categoryList[index];
                        return _buildCategoryTile(category);
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========================= UI HELPERS =========================

  Widget _sectionHeader(String title, {required VoidCallback onTap}) {
    final bool isDark = ThemeService().getDarkTheme();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: poppinsBold.copyWith(fontSize: 16.sp)),
        InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Text(
                'See all',
                style: poppinsBold.copyWith(
                  fontSize: 12.sp,
                  color: isDark
                      ? Colors.white
                      : ColorConstants.android_red_dark,
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: isDark
                    ? Colors.white
                    : ColorConstants.android_red_dark,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildViewMore() {
    return Container(
      width: 80.w,
      margin: EdgeInsets.symmetric(horizontal: 6.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: ColorConstants.android_red_dark),
      ),
      child: InkWell(
        onTap: () {
          Get.to(
                () => const CategoryTagsScreen(),
            transition: Transition.downToUp,
          );
        },
        child: Center(
          child: Text(
            'View More',
            textAlign: TextAlign.center,
            style: textBoldRed12px,
          ),
        ),
      ),
    );
  }

  Widget _buildTagItem(Tags tag) {
    return Container(
      width: 80.w,
      margin: EdgeInsets.symmetric(horizontal: 6.sp),
      padding: EdgeInsets.all(8.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Get.to(
                () => ArtistsListScreen(tagId: tag),
            transition: Transition.downToUp,
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: tag.image!,
              width: 36.w,
              height: 36.h,
              placeholder: (_, __) => Image.asset(Images.logo),
              errorWidget: (_, __, ___) => Image.asset(Images.logo),
            ),
            SizedBox(height: 6.h),
            Text(
              tag.name!,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: textBold10px,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArtistCard(Artists products, int index) {
    final bool isDark = ThemeService().getDarkTheme();

    /// Get Artist Type safely from Category
    String artistType = 'Artist';
    if (products.productCategoryData != null &&
        products.productCategoryData!.isNotEmpty) {
      artistType = products.productCategoryData!.first.name ?? 'Artist';
    }

    return Container(
      width: 160.w,
      margin: EdgeInsets.only(right: 12.sp),
      child: InkWell(
        onTap: () async {
          await Get.to(
                () => ArtistsDetailsScreen(artists: products),
            transition: Transition.downToUp,
          );
          showData(products.id!, index);
        },
        child: Card(
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// IMAGE
              ClipRRect(
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(18.r)),
                child: CachedNetworkImage(
                  imageUrl: products.image!,
                  height: 150.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Image.asset(Images.logo),
                  errorWidget: (_, __, ___) => Image.asset(Images.logo),
                ),
              ),

              /// TEXT AREA
              Padding(
                padding: EdgeInsets.all(10.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ARTIST NAME
                    Text(
                      products.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: poppinsBold.copyWith(fontSize: 13.sp),
                    ),

                    SizedBox(height: 4.h),

                    /// ARTIST TYPE (Singer / Band)
                    Text(
                      artistType,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTile(Category category) {
    return InkWell(
      onTap: () {
        Get.to(
              () => ArtistsListScreen(talentId: category),
          transition: Transition.downToUp,
        );
      },
      child: Card(
        color: ColorConstants.buttonBgColor,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        child: Padding(
          padding: EdgeInsets.all(10.sp),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  category.name!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: textBoldWhite10px,
                ),
              ),
              SizedBox(width: 6.w),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: CachedNetworkImage(
                  imageUrl: category.image!,
                  width: 40.w,
                  height: 40.h,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Image.asset(Images.logo),
                  errorWidget: (_, __, ___) => Image.asset(Images.logo),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========================= LOGIC BELOW (UNCHANGED) =========================


  fetchDetails(String query, {bool isSearch = false}) {
    isNetworkConnected().then((isInternet) async {
      if (isInternet) {
        setState(() {
          isLoading = true;
        });

        Map<String, dynamic> values = {};
        values['offset'] = (query.isNotEmpty || isSearch) ? 0 : offset;
        values['limit'] = limit;

        if (query.isNotEmpty || isSearch) {
          values['search_text'] = query;
          offset = 0;
        }
        final user = getUser();
        if (user == null || user.partnerId == null)
        {
          print("User or partnerId is null");
          return;
        }
        values['partner_id'] = user.partnerId;

        await odoo.callShowArtists(values).then((OdooResponse res) {
          if (!res.hasError()) {
            final result = res.getResult();
            if (result == null || result['product_details'] == null) {
              print("No product_details found in response");
              return;
            }
            print("Artists fetched: ${result['product_details'].length}");

            setState(() {
              if (query.isNotEmpty || isSearch) {
                _contactList.clear();
              }
              for (var record in result['product_details']) {
                _contactList.add(
                  Artists.fromJson(record, getURL(), getSession()),
                );
              }
            });
          } else {
            print("Error fetching artists: ${res.getErrorMessage()}");
          }
          getTags();
        });
      }
    });
  }
  getCategory() {
    _categoryList = [];
    isNetworkConnected().then((isInternet) async {
      if (isInternet) {
        Map<String, dynamic> values = {'offset': 0, 'limit': 20};
        await odoo.callShowTalents(values).then((OdooResponse res) async {
          if (!res.hasError()) {
            setState(() {
              for (var record in res.getResult()['category_details']) {
                _categoryList.add(
                  Category.fromJson(record, getURL(), getSession()),
                );
              }
            });
          }
          fetchDetails('');
        });
      }
    });
  }

  getTags() {
    _tagList = [];
    isNetworkConnected().then((isInternet) async {
      if (isInternet) {
        Map<String, dynamic> values = {'offset': 0, 'limit': 20};
        await odoo.callShowTags(values).then((OdooResponse res) async {
          setState(() {
            isLoading = false;
          });

          if (!res.hasError()) {
            final result = res.getResult();
            if (result == null || result['tag_details'] == null) {
              print("No tag_details found in response");
              return;
            }

            setState(() {
              for (var record in result['tag_details']) {
                _tagList.add(
                  Tags.fromJson(record, getURL(), getSession()),
                );
              }
            });
          } else {
            print("Error fetching tags: ${res.getErrorMessage()}");
          }
        });
      }
    });
  }

  String getDeviceType() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.shortestSide < 600 ? 'phone' : 'tablet';
  }

  showData(int id, int pos) {
    isNetworkConnected().then((isInternet) async {
      if (isInternet) {
        Map<String, dynamic> values = {
          'partner_id': getUser()!.partnerId,
          'product_id': id
        };
        await odoo.callShowArtists(values).then((OdooResponse res) async {
          if (!res.hasError()) {
            setState(() {
              for (var record in res.getResult()['product_details']) {
                _contactList[pos] =
                    Artists.fromJson(record, getURL(), getSession());
              }
            });
          }
        });
      }
    });
  }
}

