import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:my_artist_demo/app/screens/home/home.dart';
import 'package:my_artist_demo/app/services/odoo_api.dart';
import 'package:my_artist_demo/app/services/odoo_response.dart';
import 'package:my_artist_demo/app/theme/theme_controller.dart';
import 'package:my_artist_demo/app/utility/color_constants.dart';
import 'package:my_artist_demo/app/utility/strings.dart';
import 'package:my_artist_demo/app/widgets/custom_app_bar.dart';
import 'package:my_artist_demo/app/widgets/custom_text_field.dart';
import 'package:my_artist_demo/base.dart';

import '../../utility/styles.dart';

class Settings extends StatefulWidget {
  final HomeState? homePageState;

  const Settings({super.key,this.isAppBar = false, this.homePageState});
  final bool isAppBar;

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends Base<Settings> {
  final TextEditingController _urlCtr = TextEditingController();
  String odooURL = "";

  bool isDarkTheme = false;

  @override
  void initState() {
    super.initState();
    isDarkTheme = ThemeService().getDarkTheme();
    getOdooInstance().then((odoo) {
      setState(() {
        user = getUser();
      });
    });

    _checkFirstTime();
  }

  _checkFirstTime() async {
    if (getURL() != "") {
      setState(() {
        _urlCtr.text = odooURL = getURL();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const DrawerWidget(),
      // appBar: widget.isAppBar ? CustomAppBar(isDarkTheme: ThemeService().loadThemeFromBox(),title: "Settings") : null,
      appBar: isDarkTheme ? const CustomAppBar(title: "Settings") : const CustomAppBar(title: "Settings"),
      body: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(16.sp),
                child: Text(
                    'Dark Theme',
                    style: poppinsBold
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.sp),
                child: FlutterSwitch(
                  width: 70.w,
                  height: 35.h,
                  toggleSize: 25.sp,
                  value: ThemeService().getDarkTheme(),
                  borderRadius: 30.r,
                  padding: 2.sp,
                  activeToggleColor: ColorConstants.backgroundColor,
                  inactiveToggleColor: const Color(0xFF2F363D),
                  activeSwitchBorder: Border.all(
                    color: ColorConstants.darkAppBarColor,
                    width: 6.w,
                  ),
                  inactiveSwitchBorder: Border.all(
                    color: const Color(0xFFD1D5DA),
                    width: 6.w,
                  ),
                  activeColor: ColorConstants.lightBlack,
                  inactiveColor: Colors.white,
                  activeIcon: const Icon(
                    Icons.nightlight_round,
                    color: Color(0xFFF8E3A1),
                  ),
                  inactiveIcon: const Icon(
                    Icons.wb_sunny,
                    color: Color(0xFFFFDF5D),
                  ),
                  onToggle: (val) {
                    setState(() {
                      ThemeService().switchTheme();
                      isDarkTheme = ThemeService().getDarkTheme();
                    });
                  },
                ),
              ),
            ],
          ),
          //Divider(),


          // change url code

          Padding(
            padding: EdgeInsets.all(15.sp),
            child: CustomTextField(
              controller: _urlCtr,
              labelText: "Odoo Server URL",
              labelStyle: textRegularGrey,
              style: ThemeService().getDarkTheme() ? textBoldWhite : poppinsBold,
            ),
          ),



          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 16.sp,right: 16.sp, top: 10.sp),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ), backgroundColor: ColorConstants.green,
                padding: EdgeInsets.all(12.sp),
              ),
              onPressed: () {
                _saveURL(_urlCtr.text);
              },
              child: Text(
                  'Update URL',
                  style: textBoldWhite18px
              ),
            ),
          ),


          SizedBox(height: 20.h,),

          user != null ?
          Container(
            margin: EdgeInsets.all(10.sp),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 16.sp),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ), backgroundColor: ColorConstants.redDark,
                padding: EdgeInsets.all(12.sp),
              ),
              onPressed: () {
                _showLogoutMessage("are you sure want to Logout?");
              },
              child: Text(
                  'Logout',
                  style: textBoldWhite18px
              ),
            ),
          ) : const SizedBox(),
        ],
      ),
    );
  }

  _showLogoutMessage(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctxt) {
        return AlertDialog(
          title: Text(
              "Warning",
              style: textBoldBlack
          ),
          content: Text(
              message,
              style: textRegularBlack
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                  "No",
                  style: poppinsBold
              ),
            ),
            TextButton(
              onPressed: () {
                clearPrefs();
              },
              child: Text(
                  "Yes",
                  style: poppinsBold
              ),
            ),
          ],
        );
      },
    );
  }

  _saveURL(String url) async {
    if (!url.toLowerCase().contains("http://") &&
        !url.toLowerCase().contains("https://")) {
      url = "http://$url";
    }
    if (url.isNotEmpty && url != " ") {
      isNetworkConnected().then((isInternet) {
        if (isInternet) {
          odoo = Odoo(url: url);
          odoo.getDatabases().then((OdooResponse res) {
            saveOdooUrl(url);
            _showLogoutMessage(Strings.loginAgainMessage);
          }).catchError((error) {
            _showMessage(Strings.invalidUrlMessage);
          });
        }
      });
    } else {
      _showMessage("Please enter valid URL");
    }
  }

  _showMessage(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctxt) {
        return AlertDialog(
          title: Text(
            translate('warning'),
            style: textBoldBlack22px,
          ),
          content: Text(message, style:textBoldBlack),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Ok",
                style: poppinsBold,
              ),
            ),
          ],
        );
      },
    );
  }
}
