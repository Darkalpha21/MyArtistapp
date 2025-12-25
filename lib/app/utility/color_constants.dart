import 'package:flutter/material.dart';
import 'package:my_artist_demo/app/theme/theme_controller.dart';

class ColorConstants {
  //static Color colorPrimary = Colors.blue;
  static const Color colorPrimary = Color(0xFF125452);
  static const Color colorPrimaryDark = Color(0xFF930507);
  static const Color colorPrimaryLight = Color(0xFFf15e63);
  static const Color buttonBgColor = Color(0xFFFF8141);

  static Color gradient1 = const Color(0xFF6E1164);
  static Color gradient2 = const Color(0xFF251543);

  static Color colorAccent = const Color(0xFFED2B32);
  static Color colorAccentDarkTheme = const Color(0xFFFFAB91);
  static Color colorAccentDark = Colors.orange.shade700;
  static Color colorAccentLight = Colors.orange.shade200;

  static Color backgroundColor = const Color(0xFF121212);
  static Color darkAppBarColor = const Color(0xFF272727);
  static Color lightBlack = const Color(0xFF191919);
  static Color appGreen = const Color(0xFF125452);

  static Color blue = const Color(0xFFFF00FA);
  static Color button = HexColor("FF7BFB");
  static Color signInButton = HexColor("FF00FA");
  static Color signUpButton = const Color(0xFF696969);
  static Color white = HexColor("FFFFFF");
  static Color black = HexColor("000000");
  static const Color green = Color(0xFF60A7A1);
  static Color statusbar = const Color(0xFF351A3D);
  static Color grey = const Color(0xFFDCDCDC);
  static const Color background = Color(0xFFABEEF8);
  static Color topbar = const Color(0xFF142B4B);
  static Color lightblack = const Color(0xFF4C4C4C);
  static Color login_background = const Color(0xFF11CDF2);
  static Color greydark = const Color(0xFF939393);
  static Color table_header = const Color(0xFFABEDF9);
  static Color splash = HexColor("ADD8E6");
  static Color dotcolor = HexColor("ea992f");
  static Color red_dark = const Color(0xFFCC0000);
  static Color red_light = const Color(0xFFff4f30);
  static Color bgColor =  const Color(0xFFEFF5F5);
  // static Color bgColor =  const Color(0xFFF5F6F9);
  static Color android_blue_dark = const Color(0xFF0099CC);
  static Color android_green_dark = const Color(0xFF669900);
  static Color android_red_dark = const Color(0xFFCC0000);

  static Color colorLeaveApprove = const Color(0xFF669900);
  static Color colorLeaveDraft = const Color(0xFFF7C81D);
  static Color colorLeaveRefuse = const Color(0xFFff4444);
  static Color colorLeaveToApprove = const Color(0xFFF7941D);

  static Color themeColor = const Color(0xfff5a623);
  static Color primaryColor = const Color(0xff203152);
  static Color greyColor = const Color(0xffaeaeae);
  static Color greyColor2 = const Color(0xffE8E8E8);
  static Color lightSlateGrey = const Color(0xff778899);

  static Color dashboardtext = const Color(0xff848484);
  static const Color appgreen = Color(0xff00826f);

  static Color errorLightTheme = const Color(0xFFB00020);
  static Color errorDarkTheme = const Color(0xFFCF6679);

  static Color successLightTheme = const Color(0xFF007E33);
  static Color successDarkTheme = const Color(0xFF00C851);

  static Color warningLightTheme = const Color(0xFFFF8800);
  static Color warningDarkTheme = const Color(0xFFFFBB33);

  static const Color infoLightTheme = Color(0xFF0099CC);
  static const Color infoDarkTheme = Color(0xFF33B5E5);

  static Color matteBlack = const Color(0xFF28282B);

  static const Color loginGradientStart = Color(0xFFfbab66);
  static const Color loginGradientEnd = Color(0xFFf7418c);

  static const Color loginGradientStart2 = Color(0xFF26C6DA);
  static const Color loginGradientEnd2 = Color(0xFF3F51B5);

  static Color whiteScaffoldColor = const Color(0xfffafafb);
  static Color blackScaffoldColor = const Color(0xff292929);
  static Color lightTextColor = const Color(0xfff0f0f7);
  static Color darkTextColor = const Color(0xff464646);
  static  Color darkGrey = const Color(0xffb4b4c4);
  static Color lightGrey = const Color(0xfff0f0f7);
  static Color darkYellow = const Color(0xffFFCA83);
  static Color lightYellow = const Color(0xffFFF4E5);
  static Color redDark = const Color(0xFFCC0000);
  static Color darkPurple = const Color(0xff8280ff);
  static Color buttonTheme = const Color(0xFF6B67E1);

  static Color getGreyColor(BuildContext context) {
    return ThemeService().getDarkTheme() ? const Color(0xFF6f7275) : const Color(0xFFA0A4A8);
  }
  static Color getGreyBunkerColor(BuildContext context) {
    return ThemeService().getDarkTheme() ? const Color(0xFFE4E8EC) : const Color(0xFF25282B);
  }
  static Color getHintColor(BuildContext context) {
    return ThemeService().getDarkTheme() ? const Color(0xFF98a1ab) : const Color(0xFF52575C);
  }
  static const primaryGradient = LinearGradient(
    colors: [colorPrimary, colorPrimaryDark],
    stops: [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
