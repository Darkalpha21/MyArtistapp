import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_artist_demo/app/theme/hive_initializer.dart';

class ThemeService extends GetxController {
  final _key = 'isDarkMode';
  final _themeBox = boxList[0];
  RxBool isDark = false.obs;
  // NotificationService? notificationService;

  ThemeMode get theme => getDarkTheme() ? ThemeMode.dark : ThemeMode.light;

  bool getDarkTheme() => _themeBox.get(_key) ?? false;

  _saveThemeToBox(bool isDarkMode) => _themeBox.put(_key, isDarkMode);

  void switchTheme() {
    isDark = getDarkTheme().obs;
    Get.changeThemeMode(getDarkTheme() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!getDarkTheme());
    // notificationService = NotificationService();
    // notificationService!.initNotification();
    update();
    // notificationService!.displayNotification(
    //   title: "Theme Changed",
    //   body: ThemeService().getDarkTheme()
    //       ? "Dark Theme activated."
    //       : "Light Theme activated",
    // );
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ThemeService().getDarkTheme() ? Colors.black : Colors.white,
      statusBarBrightness: ThemeService().getDarkTheme() ? Brightness.dark : Brightness.light,
      statusBarIconBrightness: ThemeService().getDarkTheme() ? Brightness.dark : Brightness.light,
    ));
  }
}