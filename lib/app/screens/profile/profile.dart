import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_artist_demo/app/models/partners.dart';
import 'package:my_artist_demo/app/screens/profile/editprofile_page.dart';
import 'package:my_artist_demo/app/services/odoo_response.dart';
import 'package:my_artist_demo/app/theme/theme_controller.dart' show ThemeService;
import 'package:my_artist_demo/app/utility/color_constants.dart';
import 'package:my_artist_demo/app/utility/images.dart';
import 'package:my_artist_demo/app/utility/strings.dart';
import 'package:my_artist_demo/app/widgets/custom_app_bar.dart';
import 'package:my_artist_demo/base.dart';

import '../../utility/styles.dart';

class ProfilePage extends StatefulWidget {

  const ProfilePage({super.key,this.isAppBar = false});
  final bool isAppBar;

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends Base<ProfilePage> {
  String name = "";
  String? imageURL = "";
  String email = "";
  var phone = "";
  var mobile = "";
  var street = "";
  var street2 = "";
  var city = "";
  var countryName = "";
  var stateName = "";
  var zip = "";
  var fullAddress = "";
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  int profileId = 0;

  _getProfileData() async {
    showLoading();

    final user = getUser();

    // 🔑 ADMIN FALLBACK (no error, no API call)
    if (user == null) {
      hideLoading();
      setState(() {
        name = "Admin";
        email = "";
        phone = "";
        mobile = "";
        street = "";
        street2 = "";
        city = "";
        stateName = "";
        zip = "";
        countryName = "";
        fullAddress = "";
        imageURL = null; // keep default avatar
      });
      return;
    }

    // 👇 Normal user flow (Odoo API)
    odoo.searchRead(
      Strings.res_partner,
      [
        ["id", "=", user.partnerId]
      ],
      Partners.fields,
    ).then((OdooResponse res) {
      hideLoading();

      if (!res.hasError()) {
        final results = res.getResult();
        if (results.isEmpty) {
          // fallback if profile not found
          setState(() {
            name = "Admin";
            email = "";
            phone = "";
            mobile = "";
            fullAddress = "";
          });
          return;
        }

        setState(() {
          final result = results.first;
          profileId = result['id'];

          imageURL =
          "${getURL()}/web/content?model=${Strings.res_partner}"
              "&id=$profileId&field=image_1920&${getSession()}";

          final partners = Partners.fromJson(result, imageURL!);

          // 🛡 Null-safe assignments
          name = partners.name ?? "Admin";
          email = partners.email ?? "";
          phone = partners.phone ?? "";
          mobile = partners.mobile ?? "";
          street = partners.street ?? "";
          street2 = partners.street2 ?? "";
          city = partners.city ?? "";
          stateName = partners.stateId?.name ?? "";
          zip = partners.zip ?? "";
          countryName = partners.countryId?.name ?? "";

          // 📍 Build address safely
          fullAddress = "";
          if (street.isNotEmpty) fullAddress += "$street, ";
          if (street2.isNotEmpty) fullAddress += "$street2, ";
          if (city.isNotEmpty) fullAddress += "$city, ";
          if (stateName.isNotEmpty) fullAddress += "$stateName, ";
          if (zip.isNotEmpty) fullAddress += " - $zip, ";
          if (countryName.isNotEmpty) fullAddress += countryName;
        });
      } else {
        // 🔁 graceful fallback instead of crash
        setState(() {
          name = "Admin";
          email = "";
          phone = "";
          mobile = "";
          fullAddress = "";
        });
      }
    });
  }



  @override
  void initState() {
    super.initState();
    getOdooInstance().then((odoo) {
      _getProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final lower = Column(
      children: <Widget>[

        Divider(
          height: 5.h,
          color: ThemeService().getDarkTheme() ? Colors.white : ColorConstants.black,
        ),
        InkWell(
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.all(10.sp),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 0.sp),
                          child: Text(
                              "Mobile Number:",
                              style: poppinsBold
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.sp),
                          child: Text(
                              mobile,
                              style: poppinsRegular
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
        Divider(
          height: 5.h,
          color: ThemeService().getDarkTheme() ? Colors.white : ColorConstants.black,
        ),
        InkWell(
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.all(10.sp),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 0.sp),
                          child: Text(
                              "Email:",
                              style: poppinsBold
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.sp),
                          child: Text(
                              email,
                              style: poppinsRegular
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      appBar:
      const CustomAppBar(title: "Profile"),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 40.sp),
                ),
                imageURL != null
                    ? SizedBox(
                  width: 110.w,
                  height: 110.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(55.r),
                    child:
                    CachedNetworkImage(
                      imageUrl: imageURL!,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Image.asset(Images.customer),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
                    : CircleAvatar(
                  radius: 30.r,
                  backgroundColor: ColorConstants.colorPrimary,
                  child: ClipOval(
                    child: Text(
                        name + name.substring(name.indexOf(" ") + 1)[0],
                        style: textBoldWhite
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 5.sp, bottom: 5.sp)),
                Text(
                    name,
                    style: textBold16px
                ),
                Padding(padding: EdgeInsets.only(top: 5.sp, bottom: 5.sp)),
              ],
            ),
//            upper_header,
            lower,
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorConstants.colorPrimary,
        onPressed: () async {
          _awaitReturnValueProfile(context);
        },
        child: const Icon(
          Icons.edit,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 1), () {
      completer.complete(null);
    });
    return completer.future.then((_) {
      isNetworkConnected().then((isInternet) {
        if (!isInternet) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No Internet Connection!")));
          return;
        }
        name = "";
        email = "";
        phone = "";
        mobile = "";
        street = "";
        street2 = "";
        city = "";
        countryName = "";
        stateName = "";
        zip = "";
        fullAddress = "";
        _getProfileData();
      });
    });
  }

  void _awaitReturnValueProfile(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const EditProfilePage(),
        ));
    if (result != null) {
      setState(() {
        name = "";
        email = "";
        phone = "";
        mobile = "";
        street = "";
        street2 = "";
        city = "";
        countryName = "";
        stateName = "";
        zip = "";
        fullAddress = "";
      });
      imageCache.clear();
      _getProfileData();
    }
  }
}

