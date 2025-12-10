import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:my_artist_demo/models/groups.dart';
import 'package:my_artist_demo/models/user.dart';
import 'package:my_artist_demo/services/odoo_api.dart';
import 'package:my_artist_demo/services/odoo_response.dart';
import 'package:my_artist_demo/theme/theme_controller.dart';
import 'package:my_artist_demo/utility/color_constants.dart';
import 'package:my_artist_demo/utility/constant.dart';
import 'package:my_artist_demo/utility/images.dart';
import 'package:my_artist_demo/utility/shared_prefs.dart';
import 'package:my_artist_demo/utility/strings.dart';
import 'package:my_artist_demo/utility/styles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

abstract class Base<T extends StatefulWidget> extends State<T> {
  late Odoo odoo;
  User? user;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoginInProgress = false;
  bool isProgressLoading = false;
  Color bgColor = ColorConstants.gradient2;
  Color textColor = Colors.white;
  bool isLoading = false;
  final numberFormatter = NumberFormat(
    "##,##,###",
    "en_US",     // local US
  );
  bool isListFound = true;
  bool rightUser = false;  // hr_group_hr_manager
  bool rightSaleManager = false;
  Groups? groups;
  int offset = 0;
  int limit = 20;
  Icon actionIcon = const Icon(
    Icons.search,
  );

  Future<Odoo> getOdooInstance() async {
    String? userPref =
    SharedPrefs.instance.getString(Constants.USER_PREF); // User Data
    String odooUrl = getURL(); // Get OdooURL from SharedPreferences
    if (userPref != null) {
      Map<String, dynamic> map = json.decode(userPref);
      user = User.fromJson(map);
      if(user != null && user!.groups != null)
      {
        groups = user!.groups;
      }
    }
    odoo = Odoo(url: odooUrl);
    bgColor = ThemeService().getDarkTheme()
        ? ColorConstants.colorPrimaryLight
        : ColorConstants.colorPrimaryDark;
    // textColor = getContrastColorFromColor(bgColor);
    return odoo;
  }

  int? getUID() {
    return user?.uid;
  }

  bool isLoggedIn() {
    return user != null;
  }

  String getURL() {
    String? url = SharedPrefs.instance.getString(Constants.ODOO_URL);
    return url ?? "";
    // return Constants.SERVER_URL;
  }

  int? getCompanyId() {
    return user!.companyId ?? 0;
  }

  String? getLanguageISOCode() {
    return SharedPrefs.instance.getString(Constants.LANGUAGE_ISO_CODE);
  }

  bool isSubscriber() {
    return user != null ? user!.isSubscriber ?? false : false;
  }

  String getImageUrl(String model, String field, int id) {
    String session = getSession();
    return "${getURL()}/web/image?model=$model&field=$field&$session&id=$id";
  }

  String getSession() {
    String? session = SharedPrefs.instance.getString(Constants.SESSION);
    session = session?.split(",")[0].split(";")[0];
    return session ?? "";
  }

  User? getUser() {
    return user;
  }

  void saveUser(String userData) {
    SharedPrefs.instance.setString(Constants.USER_PREF, userData);
  }

  void saveOdooUrl(String url) {
    SharedPrefs.instance.setString(Constants.ODOO_URL, url);
  }

  void getGroups()
  {
    rightUser = groups!.groupUser!;
    rightSaleManager = groups!.groupSaleManager!;
  }

  void setPartnerMobile(String value) {
    SharedPrefs.instance.setString(Constants.MOBILE, value);
  }

  String getPartnerMobile() {
    String? mobile = SharedPrefs.instance.getString(Constants.MOBILE);
    return mobile ?? "";
  }

  void setCurrencyDetails(int id,String value) {
    SharedPrefs.instance.setInt(Constants.CURRENCYID, id);
    SharedPrefs.instance.setString(Constants.CURRENCYNAME, value);
  }

  String getCurrencyDetails() {
    String? currencyName = SharedPrefs.instance.getString(Constants.CURRENCYNAME);
    return currencyName ?? "";
  }

  void setCompanyMobile(String mobile) {
    SharedPrefs.instance.setString(Constants.COMPANYMOBILE, mobile);
  }

  String getCompanyMobile() {
    String? companyMobile = SharedPrefs.instance.getString(Constants.COMPANYMOBILE);
    return companyMobile ?? "";
  }

  void setCompanyEmail(String mobile) {
    SharedPrefs.instance.setString(Constants.COMPANYEMAIL, mobile);
  }

  String getCompanyEmail() {
    String? companyMobile = SharedPrefs.instance.getString(Constants.COMPANYEMAIL);
    return companyMobile ?? "";
  }

  Widget networkImage(String url,
      {double? height, double? width, BoxFit? fit}) {
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) => Container(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      height: height,
      width: width,
      fit: fit,
    );
  }

  Future<void> launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
  }

  Future<void> launchCall(String mobile) async {
    if (!await launchUrl(Uri.parse("tel:+$mobile"))) throw 'Could not launch $mobile';
  }

  // This method is for push to new widget and replace current widget
  void pushReplacement(Widget screenName) {
    if (!mounted) return;

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => screenName));
  }

  // This method is for push to new widget but don't replace current widget
  Future<dynamic> push(Widget screenName) async {
    if (!mounted) return Future.value(false);

    var res = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => screenName));
    return res;
  }

  // This method is for push to new widget and remove all previous widget
  void pushAndRemoveUntil(Widget screenName) {
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => screenName),
            (_) => false);
  }
  Widget customDropDownExampleMultiSelection(BuildContext context, List<dynamic> selectedItems) {
    if (selectedItems.isEmpty) {
      return ListTile(
        contentPadding: EdgeInsets.all(0.sp),
        title: Text("No item selected", style: poppinsRegular,),
      );
    }
    // return Wrap(
    //   children: selectedItems.map((e) {
    //     return Padding(
    //       padding: const EdgeInsets.all(4.0),
    //       child: Text(e.name!, style: textRegular12px,),
    //     );
    //   }).toList(),
    // );
    return Wrap(
      children: selectedItems.map((e) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(e.name!, style: textRegular12px),
        );
      }).toList(),
    );
  }

  Future<void> launchWhatsapp(String phone, String text) async{
    var contact = phone;
    var androidUrl = "whatsapp://send?phone=$contact&text=$text";
    var iosUrl = "https://wa.me/$contact?text=${Uri.parse(text)}";
    try{
      if(Platform.isIOS){
        await launchUrl(Uri.parse(iosUrl));
      }
      else{
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp is not installed on the device"),
        ),
      );
    }
  }
  Future<void> launchMail(String email, String subject, String message) async {
    var url =
        'mailto:$email?subject=$subject&body=$message';
    try{
      await launchUrl(Uri.parse(url));
    } on Exception{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gmail is not installed on the device"),
        ),
      );
    }
  }

  Future<void> launchPhoneDialer(String contactNumber) async {
    final Uri phoneUri = Uri(
        scheme: "tel",
        path: contactNumber
    );
    try {
      await launchUrl(phoneUri);
    } catch (error) {
      throw("Cannot dial");
    }
  }

  // Show loading with optional message params
  void showLoading() {
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  color: ThemeService().getDarkTheme()
                      ? ColorConstants.colorPrimaryLight
                      : ColorConstants.colorPrimary,
                )),
          );
        },
      );
      isProgressLoading = true;
    }
  }

  void hideLoading() {
    if (mounted && isProgressLoading) {
      isProgressLoading = false;
      Navigator.pop(context);
    }
  }

  void showSnackBar(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  void snackBarMSG({required String message, String? status}) {
    Color color;
    if (status == "success") {
      color = ThemeService().getDarkTheme()
          ? ColorConstants.successDarkTheme
          : ColorConstants.successLightTheme;
    } else if (status == "error") {
      color = ThemeService().getDarkTheme()
          ? ColorConstants.errorDarkTheme
          : ColorConstants.errorLightTheme;
    } else if (status == "warning") {
      color = ThemeService().getDarkTheme()
          ? ColorConstants.infoDarkTheme
          : ColorConstants.infoLightTheme;
    } else {
      color =
      ThemeService().getDarkTheme() ? ColorConstants.white : ColorConstants
          .backgroundColor;
    }
    final snackBar = SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        backgroundColor: color);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  String getPlaceholderImageUrl(String label) {
    return 'https://picsum.photos/300/150?text=$label';
  }

  void showMessage(String title, String message) {
    if (!mounted) {
      return;
    }
    if (isProgressLoading) {
      hideLoading();
    }

    if (isLoginInProgress) {
      return;
    }
    if (message.contains("Session expired") || message.contains("404")) {
      isLoginInProgress = true;
      // pushAndRemoveUntil(const Login());
      return;
    }
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext ctxt) {
          return AlertDialog(
            title: Text(
                title,
                style: textBoldBlack
            ),
            content:
            Text(message, style: textRegularBlack),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  isLoginInProgress = false;
                  Navigator.pop(context);
                },
                child: const Text(
                  "Ok",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext ctxt) {
          return CupertinoAlertDialog(
            title: Text(
                title,
                style: textBoldBlack
            ),
            content:
            Text(message, style: textRegularBlack),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  isLoginInProgress = false;
                  Navigator.pop(context);
                },
                child: const Text(
                  "Ok",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  String getCurrencySymbol(String currencyCode) {
    return NumberFormat
        .compactSimpleCurrency(name: currencyCode)
        .currencySymbol;
  }

  Future<void> clearPrefs() async {
    Map<String, dynamic> values = {};
    try{
      if(user != null)
      {
        values["partner_id"] = user!.partnerId;
        values["device_type"] = Platform.isAndroid ? "android" : "ios";
        values["device_token"] = "";
        await odoo.sendFCMToken(values).then((OdooResponse res) async {
          if (!res.hasError()) {
            redirectLogin();
          }
          else{
            redirectLogin();
          }
        });
      }
      else
      {
        redirectLogin();
      }
    }
    catch(e)
    {
      redirectLogin();
    }
  }

  void redirectLogin()
  {
    odoo.destroy();
    String? odooUrl = SharedPrefs.instance.getString(Constants.ODOO_URL);
    SharedPrefs.instance.clear();
    SharedPrefs.instance.setString(Constants.ODOO_URL, odooUrl!);
    // pushAndRemoveUntil(const Login());
  }

  Future<bool> isNetworkConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      showSnackBar(Strings.internetMessage);
      return false;
    }
    showSnackBar(Strings.internetMessage);
    return false;
  }

  Widget emptyView(IconData iconData, String text) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              iconData,
              color: Colors.grey.shade300,
              size: 30,
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Text(
                text,
                style: TextStyle(
                    fontFamily: 'GoogleSansMediumItalic',
                    fontSize: 14,
                    color: Colors.grey.shade400),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget addHorizontalSpace(double size) {
    return SizedBox(width: size);
  }

  Widget addVerticalSpace(double size) {
    return SizedBox(height: size);
  }

  Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }

  Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  bool isDarkColor(Color myColor) {
    var r = myColor.red;
    var g = myColor.green;
    var b = myColor.blue;

    // Get YIQ ratio
    var yiq = ((r * 299) + (g * 587) + (b * 114)) / 1000;

    // Check contrast
    return yiq < 128;
  }

  Color getContrastColor(String hexCode) {
    Color myColor = HexColor(hexCode);
    return isDarkColor(myColor) ? Colors.black : Colors.white;
  }

  Color getContrastColorFromColor(Color myColor) {
    return isDarkColor(myColor) ? Colors.white : Colors.black;
  }

  Color getPrimaryContrastColor() {
    return getContrastColorFromColor(ThemeService().getDarkTheme()
        ? ColorConstants.colorPrimaryLight
        : ColorConstants.colorPrimary);
  }

  LinearGradient getThemeGradient() {
    return LinearGradient(
      colors: [bgColor, darken(bgColor, 0.2)],
      stops: const [0.0, 1.0],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight =
    hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  Widget buttonBuilder(String text, String action,
      {required VoidCallback onPressed}) {
    Color color;
    if (action == Constants.WARNING) {
      color = Colors.red.shade700;
    } else if (action == Constants.NEUTRAL) {
      color = Colors.grey
          .shade700;
    } else if (action == Constants.SUCCESS) {
      color = Colors.green
          .shade700;
    } else {
      color = Colors.grey
          .shade700;
    }
    return Platform.isAndroid
        ? TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    )
        : CupertinoButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<bool> checkIfModuleInstalled(String moduleName) async {
    bool isInstalled = false;
    await odoo.searchRead("ir.module.module", [
      ["name", "=", moduleName],
      ["state", "=", "installed"]
    ], []).then(
          (OdooResponse res) {
        if (!res.hasError()) {
          int length = List.from(res.getResult()).length;
          if (length > 0) {
            isInstalled = true;
          }
        } else {
          hideLoading();
          showMessage("warning" , res.getErrorMessage());
        }
      },
    );
    return isInstalled;
  }

  void showServerMessage() {
    hideLoading();
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctxt) {
          return AlertDialog(
            title: Text(
              "warning",
              style: const TextStyle(
                fontFamily: "Montserrat",
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            content: Text(
              "server_not_responding",
              style: const TextStyle(
                fontFamily: "Montserrat",
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  SharedPrefs.instance.clear();
                  pushAndRemoveUntil(const Login());
                },
                child: Text(
                  "ok",
                  style: const TextStyle(
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctxt) {
          return CupertinoAlertDialog(
            title: Text(
              "warning",
              style: const TextStyle(
                fontFamily: "Montserrat",
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            content: Text(
              "server_not_responding",
              style: const TextStyle(
                fontFamily: "Montserrat",
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () async {
                  SharedPrefs.instance.clear();
                  pushAndRemoveUntil(const Login());
                },
                child: Text(
                  "ok",
                  style: const TextStyle(
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }


  String? toUtc(DateTime? dateTime) {
    if (dateTime != null) {
      DateTime? utcDate = DateTime(dateTime.year, dateTime.month, dateTime.day,
          dateTime.hour, dateTime.minute, dateTime.second)
          .toUtc();
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(utcDate);
    } else {
      return null;
    }
  }

  String? toUtcString(String? dateTime) {
    if (dateTime != null) {
      DateTime dTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateTime);
      DateTime? utcDate = DateTime(dTime.year, dTime.month, dTime.day,
          dTime.hour, dTime.minute, dTime.second)
          .toUtc();
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(utcDate);
    } else {
      return null;
    }
  }

  String? formatDate(DateTime dateTime, String format) {
    return DateFormat(format).format(dateTime);
  }

  String? toLocalDateString(String? dateTime) {
    String result = "";
    if (dateTime != null && dateTime != "") {
      DateTime dTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateTime);
      DateTime utcDate = DateTime.utc(dTime.year, dTime.month, dTime.day,
          dTime.hour, dTime.minute, dTime.second);
      result = DateFormat('yyyy-MM-dd HH:mm:ss').format(utcDate.toLocal());
    }
    return result;
  }

  String? toLocalOnlyDateString(String? dateTime) {
    String result = "";
    if (dateTime != null && dateTime != "") {
      DateTime dTime;
      if(dateTime.contains(":"))
      {
        dTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateTime);
      }
      else
      {
        dTime = DateFormat("yyyy-MM-dd").parse(dateTime);
      }
      DateTime utcDate = DateTime.utc(dTime.year, dTime.month, dTime.day,
          dTime.hour, dTime.minute, dTime.second);
      result = DateFormat('yyyy-MM-dd').format(utcDate.toLocal());
    }
    return result;
  }


  Text setAppTitle(String title) {
    return Text(
        title,
        style: textRegularWhite20px
    );
  }

  static double dp(double val, int places) {
    num mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  String durationToString(int minutes) {
    if (minutes == 0) return "0m";
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0]}h ${parts[1]}m';
  }
  DateTime? buttonClickTime;

  bool isRedundantClick(DateTime currentTime) {
    if (buttonClickTime == null) {
      buttonClickTime = currentTime;
      return false;
    }
    if (currentTime
        .difference(buttonClickTime!)
        .inMilliseconds < 700) {
      return true;
    }
    buttonClickTime = currentTime;
    return false;
  }

  bool checkAuthentication() {
    if (!isLoggedIn()) {
      push(const Login());
      return false;
    }
    return true;
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  TimeOfDay stringToTimeOfDay(String tod) {
    final format = DateFormat.jm(); //"6:00 AM"
    return TimeOfDay.fromDateTime(format.parse(tod));
  }

  Widget buildProgressIndicator() {
    return Padding(
      padding: EdgeInsets.all(8.sp),
      child: Center(
        child: Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget customDropDownPrograms(BuildContext context, dynamic item) {
    return Container(
        padding: const EdgeInsets.all(0),
        child: (item == null)
            ? Text("Select Item",
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 14.sp,
                color: ColorConstants.greyColor))
            : Text(
          item.name!,
          style: ThemeService().getDarkTheme() ? textRegularWhite : poppinsRegular,
        ));
  }

  Widget customPopupItem(BuildContext context, dynamic item,bool isDisabled, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp),
      decoration: !isSelected ? null :
      BoxDecoration(
        border: Border.all(color: ColorConstants.backgroundColor),
        borderRadius: BorderRadius.circular(5.r),
        color: Colors.white,
      ),
      child: ListTile(
        selected: isSelected,
        title: Text(item.name!,style: poppinsRegular),
      ),
    );
  }

  Future<String?> networkImageToBase64(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;
    return (bytes != null ? base64Encode(bytes) : null);
  }

  // String convertCurrencySymbol(String? currency) {
  //   print("currency::::::::::::::"+ currency.toString());
  //   String symbol = "";
  //   if (currency != null || currency == "") {
  //     symbol = NumberFormat.compactSimpleCurrency(name: currency).currencySymbol;
  //   }
  //   print("symbol::::::::::::::"+ symbol.toString());
  //   return symbol;
  // }

  Center showEmptyList()
  {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(Images.noData),
            ]));
  }


}

