import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_artist_demo/app/theme/theme_controller.dart';
import 'package:my_artist_demo/app/utility/color_constants.dart';
import 'package:my_artist_demo/app/utility/styles.dart';
import 'package:my_artist_demo/app/widgets/marquee_widget.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final bool? isBackButtonExist;
  final Function? onBackPressed;
  final List<Widget>? actions;
  final Widget? titleWidget;
  final TabBar? bottom;

  const CustomAppBar({super.key, this.title, this.leading, this.isBackButtonExist = true, this.onBackPressed, this.actions, this.titleWidget,
    this.bottom,});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // backgroundColor: isDarkTheme! ?  null : ColorConstants.white,
      title:
          title != null ?
          MarqueeWidget(
          direction: Axis.horizontal,
        child:
      Text(title!, style: poppinsBold.copyWith(fontSize: 16.sp, color:
      ThemeService().getDarkTheme() ?  Colors.white : ColorConstants.black)
      )) : titleWidget,
      // centerTitle: true,
      leading:
      leading ?? (isBackButtonExist! ? IconButton(
        icon: Icon(Icons.arrow_back, color: ThemeService().getDarkTheme() ?  Colors.white :Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ) : const SizedBox()),
      elevation: 0,
      actions:actions,
        bottom: bottom
      // systemOverlayStyle: themeProvider.darkTheme ? SystemUiOverlayStyle.dark: SystemUiOverlayStyle.light,
    );
  }

  @override
  Size get preferredSize => Size(double.maxFinite, 50.sp);
}
