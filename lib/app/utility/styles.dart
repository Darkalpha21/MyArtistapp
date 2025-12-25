import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_artist_demo/app/theme/theme_controller.dart';
import 'package:my_artist_demo/app/utility/color_constants.dart';

String fontNameBold = 'PoppinsBold';
String fontNameRegular = 'Poppins';

var poppinsRegular = TextStyle(
  fontFamily: fontNameRegular,
  fontSize: 14.sp
);
var poppinsBold = TextStyle(
  fontFamily: fontNameBold,
  fontSize: 14.sp,
);
var texBoldBlack = poppinsBold.copyWith(
    color: Colors.black
);

var textRegularBlack = poppinsRegular.copyWith(
  color: Colors.black
);
var textRegularWhite12px = poppinsRegular.copyWith(
    color: Colors.white,
  fontSize: 12.sp
);
var textRegularWhite= poppinsRegular.copyWith(
    color: Colors.white,
);
var textBoldRed = poppinsBold.copyWith(
  color: ColorConstants.android_red_dark,
);
var textBoldRed12px = poppinsBold.copyWith(
  color: ColorConstants.android_red_dark,
  fontSize: 12.sp
);
var textBoldRed18px = poppinsBold.copyWith(
  color: ColorConstants.android_red_dark,
  fontSize: 18.sp
);
var textBoldRed16px = poppinsBold.copyWith(
    color: ColorConstants.android_red_dark,
    fontSize: 16.sp
);
var textBoldGreen = poppinsBold.copyWith(
  color: ColorConstants.android_green_dark,
);
var textBoldGreen12px = poppinsBold.copyWith(
  color: ColorConstants.android_green_dark,
    fontSize: 12.sp
);
var textBoldDarkBlue = poppinsBold.copyWith(
  color: ColorConstants.primaryColor,
);
var textBoldDarkBlue12px = poppinsBold.copyWith(
  color: ColorConstants.primaryColor,
  fontSize: 12.sp
);
var textBoldGreen18px = poppinsBold.copyWith(
  color: ColorConstants.android_green_dark,
  fontSize: 18.sp
);
var textBoldGreen16px = poppinsBold.copyWith(
    color: ColorConstants.android_green_dark,
    fontSize: 16.sp
);
var textBold18px = poppinsBold.copyWith(
  fontSize: 18.sp,
);
var textBold22px = poppinsBold.copyWith(
  fontSize: 22.sp,
);
var textBold26px = poppinsBold.copyWith(
  fontSize: 26.sp,
);
var textRegularPrimary =
poppinsRegular.copyWith(color: ColorConstants.colorPrimary);
var textBoldBlack22px =
poppinsBold.copyWith(fontSize: 22.sp, color: Colors.black);
var textBoldWhite18px =
poppinsBold.copyWith(fontSize: 18.sp, color: Colors.white);
var textBoldWhite =
poppinsBold.copyWith(color: Colors.white);
var textBoldWhite16px =
poppinsBold.copyWith(fontSize: 16.sp, color: Colors.white);
var textBoldWhite12px =
poppinsBold.copyWith(fontSize: 12.sp, color: Colors.white);
var textBoldWhite10px =
poppinsBold.copyWith(fontSize: 10.sp, color: Colors.white);
var textBoldWhite22px =
poppinsBold.copyWith(fontSize: 22.sp, color: Colors.white);

var textBold20px = poppinsBold.copyWith(
  fontSize: 20.sp,
);
var textBoldBlack18px = poppinsBold.copyWith(
    fontSize: 18.sp,
    color: Colors.black
);
var textBoldBlack = poppinsBold.copyWith(
    color: Colors.black
);

var textBold16px = poppinsBold.copyWith(
  fontSize: 16.sp,
);
var textBoldBlack16px = poppinsBold.copyWith(
  fontSize: 16.sp,
  color: Colors.black
);
var textBold12px = poppinsBold.copyWith(fontSize: 12.sp);

var textRegular12px = poppinsRegular.copyWith(
  fontSize: 12.sp,
);
var textRegularGrey12px = poppinsRegular.copyWith(
  fontSize: 12.sp,
  color: Colors.grey
);

var textRegularBlackScaffold12px = poppinsRegular.copyWith(
    fontSize: 12.sp,
    color: ColorConstants.blackScaffoldColor
);
var textRegular10px = poppinsRegular.copyWith(
  fontSize: 10.sp,
);
var textBold10px = poppinsBold.copyWith(
  fontSize: 10.sp,
);
var textBoldRed10px = poppinsBold.copyWith(
  fontSize: 10.sp,
  color: ColorConstants.android_red_dark
);

var textRegularWhite10px = poppinsRegular.copyWith(
  fontSize: 10.sp,
  color: Colors.white
);
var textRegularBlack12px = poppinsRegular.copyWith(
  fontSize: 12.sp,
  color: Colors.black
);
var textBoldBlack12px = poppinsBold.copyWith(
    fontSize: 12.sp,
    color: Colors.black
);
var textBoldWhite17px = poppinsBold.copyWith(
  fontSize: 17.sp,
  color: Colors.white
);
var textBoldWhite20px = poppinsBold.copyWith(
    fontSize: 20.sp,
    color: Colors.white
);
var textRegularGrey = poppinsRegular.copyWith(
    color: Colors.grey
);

var textRegularGrey16px = poppinsRegular.copyWith(
    color: Colors.grey,
  fontSize: 16.sp
);
var textRegular18px = poppinsRegular.copyWith(
    fontSize: 18.sp
);

var textRegularWhite16px = poppinsRegular.copyWith(
fontSize: 16.sp,
  color: Colors.white
);

var textRegularWhite20px = poppinsRegular.copyWith(
    fontSize: 20.sp,
    color: Colors.white
);

var textRegular16px = poppinsRegular.copyWith(
    fontSize: 16.sp
);

var textBoldPrimary18px = poppinsBold.copyWith(
    fontSize: 20.sp,
    color: ColorConstants.colorPrimary
);
var textBoldPrimary = poppinsBold.copyWith(
    color: ColorConstants.colorPrimary
);
var textBoldPrimary16px = poppinsBold.copyWith(
    color: ColorConstants.colorPrimary,
  fontSize: 16.sp
);
var textBoldPrimary12px = poppinsBold.copyWith(
    color: ColorConstants.colorPrimary,
  fontSize: 12.sp
);
var textBoldBlue16px = poppinsBold.copyWith(
    fontSize: 15.sp,
    color: ColorConstants.android_blue_dark
);
TextStyle get titleStyle {
  return  poppinsBold.copyWith(
      fontSize: 16.sp,
      color: ThemeService().getDarkTheme() ? Colors.white : Colors.black
  );
}

TextStyle get inputTextStyle {
  return  poppinsRegular.copyWith(
      color: ThemeService().getDarkTheme() ? Colors.white : Colors.black
  );
}