import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:my_artist_demo/app/models/user.dart';
import 'package:my_artist_demo/app/screens/splash/splashscreen_page.dart';
import 'package:my_artist_demo/app/theme/hive_initializer.dart';
import 'package:my_artist_demo/app/theme/theme.dart';
import 'package:my_artist_demo/app/theme/theme_controller.dart';
import 'package:my_artist_demo/app/utility/constant.dart';
import 'package:my_artist_demo/app/utility/shared_prefs.dart';
import 'package:my_artist_demo/app/utility/strings.dart';
import 'package:path_provider/path_provider.dart';
import 'base.dart';
import 'package:http/http.dart' as http;


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

String? selectedNotificationPayload;

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await openBox();
  await SharedPrefs.init();
  String? userData = SharedPrefs.instance.getString(Constants.USER_PREF);
  runApp(const App());
}
// Future<void> _configureLocalTimeZone() async {
//   tz.initializeTimeZones();
//   final String timeZone = await FlutterTimezone.getLocalTimezone();
//   tz.setLocalLocation(tz.getLocation(timeZone));
// }
class App extends StatefulWidget {
  const App({super.key});

  @override
  AppState createState() => AppState();
}

class AppState extends Base<App> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ThemeService().getDarkTheme() ? Colors.black : Colors.white,
      statusBarBrightness: ThemeService().getDarkTheme() ? Brightness.dark : Brightness.light,
      statusBarIconBrightness: ThemeService().getDarkTheme() ? Brightness.dark : Brightness.light,
    ));
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return
            GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: Strings.app_title,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: ThemeService().theme,
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: child!,
                );
              },
              home: const SplashScreenPage(),
              // onGenerateRoute: (settings) {
              //   if (settings.name!.startsWith('/uid/')) {
              //     print("settings.name!::::::::::::::::"+ settings.name!);
              //     // var id = settings.name!.substring(6);
              //     // return MaterialPageRoute(
              //     //   builder: (context) => BlogScreen(id: id),
              //     // );
              //   }
              //   return null;
              // },
              // isLoggedIn() ? const Home() : const Login(),
            );
        });
  }
}
