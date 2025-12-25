import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:my_artist_demo/app/screens/auth/login.dart';
import 'package:my_artist_demo/app/utility/images.dart';
import 'package:my_artist_demo/base.dart';


class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  SplashScreenPageState createState() => SplashScreenPageState();
}

class SplashScreenPageState extends Base<SplashScreenPage> {
  AppUpdateInfo? _updateInfo;

  Future<void> _checkFirstTime() async {
    getOdooInstance().then((odoo) {
      if (getUser() != null) {
        Timer(
            const Duration(seconds: 2),
                () =>
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                             Login() )
                            )
                            );
      }
      else {
        Timer(
            const Duration(seconds: 2),
                () =>
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (BuildContext context) =>  Login())));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if(Platform.isAndroid)
    {
      InAppUpdate.checkForUpdate().then((info) {
        setState(() {
          _updateInfo = info;
        });
        if(_updateInfo?.updateAvailability ==
            UpdateAvailability.updateAvailable)
        {
          InAppUpdate.performImmediateUpdate()
              .catchError((e) => e.toString());
        }
        else
        {
          _checkFirstTime();
        }
      }).catchError((e) {
        // print("_updateInfo444444444444:::::::::::");
        // showSnack(e.toString());
        // print("e.toString():::::::::::"+ e.toString());
        _checkFirstTime();
      });
    }
    else
    {
      _checkFirstTime();
    }
    // _checkFirstTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          Images.logo,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
      ),
    );
  }
}
