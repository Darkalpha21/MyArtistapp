import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_artist_demo/utility/color_constants.dart';
import 'package:my_artist_demo/utility/styles.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: fontNameRegular,
    scaffoldBackgroundColor: ColorConstants.bgColor,
    cardColor: Colors.white,
    // textTheme start here --
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 23,
        fontWeight: FontWeight.bold,
        color: ColorConstants.darkTextColor,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        color: ColorConstants.darkTextColor,
      ),
      titleSmall: TextStyle(
        fontSize: 15,
        color: ColorConstants.darkTextColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 17,
        color: ColorConstants.darkTextColor,
      ),
      bodySmall: TextStyle(
        fontSize: 15,
        color: ColorConstants.darkTextColor,
      ),
    ),
    // -----------------------

    iconTheme: IconThemeData(color: ColorConstants.darkTextColor),
    cupertinoOverrideTheme: CupertinoThemeData(
      textTheme: CupertinoTextThemeData(
        dateTimePickerTextStyle:
            TextStyle(color: ColorConstants.darkTextColor, fontSize: 20),
        pickerTextStyle:
            TextStyle(color: ColorConstants.darkTextColor, fontSize: 15),
      ),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: ColorConstants.whiteScaffoldColor,
      elevation: 0,
      toolbarHeight: 80,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      iconTheme: IconThemeData(color: ColorConstants.blackScaffoldColor),
      titleTextStyle: TextStyle(
        fontSize: 23,
        fontWeight: FontWeight.bold,
        color: ColorConstants.darkTextColor,
      ),
    ),
  );
  static final darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily:fontNameRegular,
    scaffoldBackgroundColor: ColorConstants.blackScaffoldColor,
    // textTheme start here --
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 23,
        fontWeight: FontWeight.bold,
        color: ColorConstants.lightTextColor,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        color: ColorConstants.darkTextColor,
      ),
      titleSmall: TextStyle(
        fontSize: 15,
        color: ColorConstants.lightTextColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 17,
        color: ColorConstants.lightTextColor,
      ),
      bodySmall: TextStyle(
        fontSize: 15,
        color: ColorConstants.darkTextColor,
      ),
    ),
    // -----------------------

    iconTheme: IconThemeData(color: ColorConstants.darkGrey),

    cupertinoOverrideTheme: CupertinoThemeData(
      textTheme: CupertinoTextThemeData(
        dateTimePickerTextStyle:
            TextStyle(color: ColorConstants.lightTextColor, fontSize: 20),
        pickerTextStyle:
            TextStyle(color: ColorConstants.lightTextColor, fontSize: 15),
      ),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: ColorConstants.blackScaffoldColor,
      elevation: 0,
      toolbarHeight: 80,
      iconTheme: IconThemeData(color: ColorConstants.white),
      titleTextStyle: TextStyle(
        fontSize: 23,
        fontWeight: FontWeight.bold,
        color: ColorConstants.lightTextColor,
      ), systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
  );
}
