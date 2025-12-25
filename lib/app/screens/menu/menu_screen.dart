
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_artist_demo/app/screens/auth/change_password_screen.dart';
import 'package:my_artist_demo/app/screens/home/home.dart';
import 'package:my_artist_demo/app/screens/profile/profile.dart';
import 'package:my_artist_demo/app/screens/settings/settings.dart';
import 'package:my_artist_demo/app/screens/webview/webview.dart';
import 'package:my_artist_demo/app/theme/theme_controller.dart';
import 'package:my_artist_demo/app/utility/constant.dart';
import 'package:my_artist_demo/app/utility/images.dart';
import 'package:my_artist_demo/app/utility/styles.dart';
import 'package:my_artist_demo/app/widgets/custom_app_bar.dart';
import 'package:my_artist_demo/base.dart';

class MenuScreen extends StatefulWidget {
  final HomeState? homeState;

  const MenuScreen({super.key, this.homeState});

  @override
  MenuScreenState createState() => MenuScreenState();
}

class MenuScreenState extends Base<MenuScreen> {

  @override
  void initState() {
    super.initState();
    getOdooInstance().then((odoo) async {
      setState(() {
        getGroups();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ThemeService().getDarkTheme()
            ? const CustomAppBar(
                title: "Settings",
                isBackButtonExist: false,
              )
            : const CustomAppBar(
                title: "Settings",
                isBackButtonExist: false,
              ),
        body: Container(
            padding: EdgeInsets.all(10.sp),
            child: ListView(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                children: [

                  Card(
                      elevation: 10.0,
                      color: ThemeService().getDarkTheme()
                          ? Colors.black
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: InkWell(
                          borderRadius: BorderRadius.circular(8.r),
                          onTap: () {
                            Get.to(() => const ChangePasswordScreen(), transition: Transition.downToUp);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.sp),
                            child: Row(
                              children: [
                                Image.asset(Images.aboutus,
                                    width: 20.w, height: 20.h,
                                    color: ThemeService().getDarkTheme() ? Colors.white : Colors.black),
                                SizedBox(width: 10.w),
                                Text("Change Password", style: poppinsRegular)
                              ],
                            ),
                          )
                      )
                  ),
                  !rightUser ?
                  Card(
                      elevation: 10.0,
                      color: ThemeService().getDarkTheme()
                          ? Colors.black
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: InkWell(
                          borderRadius: BorderRadius.circular(8.r),
                          onTap: () {
                            launchMail(getCompanyEmail(), "Inquiry of My Artist App","My Artist Admin \n \n I need some Help for My Artist Application");
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.sp),
                            child: Row(
                              children: [
                                Image.asset(Images.help,
                                    width: 20.w, height: 20.h,
                                    color: ThemeService().getDarkTheme() ? Colors.white : Colors.black),
                                SizedBox(width: 10.w),
                                Text("Help", style: poppinsRegular)
                              ],
                            ),
                          ))): const SizedBox(),

                  Card(
                      elevation: 10.0,
                      color: ThemeService().getDarkTheme()
                          ? Colors.black
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: InkWell(
                          borderRadius: BorderRadius.circular(8.r),
                          onTap: () {
                             Get.to(() => const WebViewScreen(title: "Contact Us",url: Constants.CONTACTUS,), transition: Transition.downToUp);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.sp),
                            child: Row(
                              children: [
                                Image.asset(Images.contactus,
                                    width: 20.w, height: 20.h,
                                    color: ThemeService().getDarkTheme() ? Colors.white : Colors.black),
                                SizedBox(width: 10.w),
                                Text("Contact Us", style: poppinsRegular)
                              ],
                            ),
                          ))),

                  Card(
                      elevation: 10.0,
                      color: ThemeService().getDarkTheme()
                          ? Colors.black
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: InkWell(
                          borderRadius: BorderRadius.circular(8.r),
                          onTap: () {
                             Get.to(() => const WebViewScreen(title: "Terms & Conditions",url: Constants.ABOUTAS), transition: Transition.downToUp);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.sp),
                            child: Row(
                              children: [
                                Image.asset(Images.privacy,
                                    width: 20.w, height: 20.h,
                                    color: ThemeService().getDarkTheme() ? Colors.white : Colors.black),
                                SizedBox(width: 10.w),
                                Text("Terms & Conditions", style: poppinsRegular)
                              ],
                            ),
                          ))),

                  Card(
                      elevation: 10.0,
                      color: ThemeService().getDarkTheme()
                          ? Colors.black
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: InkWell(
                          borderRadius: BorderRadius.circular(8.r),
                          onTap: () {
                             Get.to(() => const ProfilePage(), transition: Transition.downToUp);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.sp),
                            child: Row(
                              children: [
                                Image.asset(Images.user,
                                    width: 20.w, height: 20.h,
                                    color: ThemeService().getDarkTheme() ? Colors.white : Colors.black),
                                SizedBox(width: 10.w),
                                Text("Profile", style: poppinsRegular)
                              ],
                            ),
                          ))),

                  Card(
                      elevation: 10.0,
                      color: ThemeService().getDarkTheme()
                          ? Colors.black
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: InkWell(
                          borderRadius: BorderRadius.circular(8.r),
                          onTap: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const Settings(isAppBar: true)));
                            widget.homeState!.refreshDarkTheme();
                            setState(() {
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.sp),
                            child: Row(
                              children: [
                                Image.asset(Images.settings,
                                    width: 20.w, height: 20.h,
                                    color: ThemeService().getDarkTheme() ? Colors.white : Colors.black),
                                SizedBox(width: 10.w),
                                Text("Settings", style: poppinsRegular)
                              ],
                            ),
                          ))),
                  Card(
                      elevation: 10.0,
                      color: ThemeService().getDarkTheme()
                          ? Colors.black
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: InkWell(
                          borderRadius: BorderRadius.circular(8.r),
                          onTap: () {
                            _logoutDialog();
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.sp),
                            child: Row(
                              children: [
                                Image.asset(Images.logout,
                                    width: 20.w, height: 20.h,
                                    color: ThemeService().getDarkTheme() ? Colors.white : Colors.black),
                                SizedBox(width: 10.w),
                                Text("Logout", style: poppinsRegular)
                              ],
                            ),
                          ))),
                ])));
  }

  _logoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Warning",
            style: textBoldBlack,
          ),
          content: Text(
            "Are you sure you want to logout?",
            style: textRegularBlack,
          ),
          actions: <Widget>[
            buttonBuilder("CANCEL", Constants.NEUTRAL, onPressed: () {
              Navigator.pop(context);
            }),
            buttonBuilder("LOGOUT", Constants.WARNING, onPressed: () {
              clearPrefs();
            })
          ],
        );
      },
    );
  }
}
