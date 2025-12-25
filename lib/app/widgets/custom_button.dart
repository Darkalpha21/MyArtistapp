import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_artist_demo/app/utility/color_constants.dart';
import 'package:my_artist_demo/app/utility/styles.dart';


class CustomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String? btnTxt;
  final Color? backgroundColor;
  final int? textSize;
  const CustomButton({super.key, this.onTap, this.btnTxt, this.backgroundColor, this.textSize});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      // backgroundColor: Theme.of(context).primaryColor,
      backgroundColor: onTap == null ? ColorConstants.greyColor : backgroundColor ?? Theme.of(context).primaryColor,
      minimumSize: Size(MediaQuery.of(context).size.width, 50),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );

    return TextButton(
      onPressed: onTap,
      style: flatButtonStyle,
      child: Text(btnTxt??"",
          style:
          poppinsBold.copyWith(
            color: Colors.white,
            fontSize: 16.sp
          )),
    );
  }
}
