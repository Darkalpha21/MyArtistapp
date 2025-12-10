import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_artist_demo/base.dart';
import 'package:my_artist_demo/models/user.dart';
import 'package:my_artist_demo/services/odoo_api.dart';
import 'package:my_artist_demo/services/odoo_response.dart';
import 'package:my_artist_demo/theme/theme_controller.dart';
import 'package:my_artist_demo/utility/color_constants.dart';
import 'package:my_artist_demo/utility/constant.dart';
import 'package:my_artist_demo/utility/images.dart';
import 'package:my_artist_demo/utility/styles.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends Base<Login> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  String? _selectedDb;
  String _selectedProtocal = "http";
  final List<String> _dbList= [];
  List dynamicList = [];
  bool isCorrectURL = false;
  bool isDBFilter = false;
  String? _email;
  String? _pass;
  late String odooURL;
  String fcmToken = "";
  StreamSubscription? _sub;

  _login() {
    isNetworkConnected().then((isInternet) {
      if (isInternet) {
        showLoading();
        odoo.authenticate(_email, _pass, _selectedDb).then(
              (OdooResponse res) {
            if (!res.hasError()) {
              User user = User.fromJson(res.getResult());
              if (user.uid != 0) {
                odoo.callGroup(user.uid!).then((OdooResponse res) async {
                  hideLoading();
                  if (!res.hasError()) {
                    // pushAndRemoveUntil(const Home());
                  }
                });
              } else {
                showMessage("Error", res.getErrorMessage());
              }
            } else {
              showMessage("Authentication Failed",
                  "Please Enter Valid Email or Password");
            }
          },
        );
      } else {
        showMessage("Warning", res.getErrorMessage());
      }
    });
  }

  _checkURL() {
    showLoading();
    odoo = Odoo(url: odooURL);
    odoo.getDatabases().then((OdooResponse res) {
      hideLoading();
      if (!res.hasError()) {
        isCorrectURL = true;
        List dynamicList = res.getResult() as List;
        for (var db in dynamicList) {
          _dbList.add(db);
        }
        setState(() {
          _selectedDb = _dbList[0];
          if (_dbList.length == 1) {
            isDBFilter = true;
          } else {
            isDBFilter = false;
          }
        });
      }
    }).catchError(
          (e) {
        hideLoading();
        showMessage("Warning", "Invalid URl")
      },
    );
  }

  _checkFirstTime() {
    if (getURL() != "") {
      odooURL = getURL();
    } else {
      odooURL = Constants.SERVER_URL;
    }
    saveOdooUrl(odooURL);
    _checkFirstTime();
  }

  @override
  void initState() {
    super.activate();
    _getPushToken();
    WidgetsBinding.instance.addPostFrameCallback((_)) async {
      getOdooInstance().then((odoo));
          _checkFirstTime();
    });
  }
  );
}

@override
void dispose() {
  super.dispose();
}

@override
Widget build(BuildContext context) {
  return AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle(
      statusBarColor:
      ThemeService().getDarkTheme() ? Colors.black : Colors.white,
      statusBarIconBrightness: ThemeService().getDarkTheme()
          ? Brightness.light
          : Brightness.dark,
    ),
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: ThemeService().getDarkTheme()
              ? [const Color(0xff3D3C3A), const Color(0xff3D3C3A)]
              : [const Color(0xffffffff), const Color(0xffffffff)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: null,
        floatingActionButtonLocation: null,

        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              SizedBox(height: 40.h),

              /// ===== LOGO =====
              Center(
                child: Image.asset(
                  Images.logo,
                  height: 130.h,
                  width: 130.w,
                ),
              ),

              SizedBox(height: 35.h),

              /// ===== Login Title =====
              Center(
                child: Text(
                  "Login",
                  style: poppinsBold.copyWith(
                    fontSize: 24.sp,
                    color: ThemeService().getDarkTheme()
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),

              SizedBox(height: 25.h),

              /// ===== Email Field =====
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                      color: Colors.black.withOpacity(0.08),
                    ),
                  ],
                ),
                child: _buildEmailField(),
              ),

              SizedBox(height: 18.h),

              /// ===== Password Field =====
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                      color: Colors.black.withOpacity(0.08),
                    ),
                  ],
                ),
                child: _buildPasswordField(),
              ),

              SizedBox(height: 10.h),

              /// ===== Forgot Password =====
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    // Get.to(() => const ResetPasswordPage(),
                    //     transition: Transition.downToUp);
                  },
                  child: Text(
                    "Forgot Password?",
                    style: poppinsBold.copyWith(
                      fontSize: 13.sp,
                      decoration: TextDecoration.underline,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 32.h),

              /// ===== Login Button =====
              _buildLoginButton(),

              SizedBox(height: 26.h),

              /// ===== Register Section =====
              Center(
                child: Wrap(
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: poppinsRegular.copyWith(
                        color: ThemeService().getDarkTheme()
                            ? Colors.white70
                            : Colors.black87,
                        fontSize: 14.sp,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Get.to(() => const SignUpScreen(),
                        //     transition: Transition.downToUp);
                      },
                      child: Text(
                        "Sign Up Now",
                        style: textBoldGreen16px.copyWith(
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildEmailField() {
  return CustomTextField(
    title: "Email *",
    hintText: "Email",
    inputAction: TextInputAction.next,
    inputType: TextInputType.emailAddress,
    controller: _emailController,
  );
}

Widget _buildPasswordField() {
  return CustomTextField(
    title: "Password *",
    hintText: "Password",
    inputAction: TextInputAction.done,
    isPassword: true,
    isShowSuffixIcon: true,
    controller: _passController,
  );
}

Widget _buildLoginButton() {
  return SizedBox(
    width: MediaQuery
        .of(context)
        .size
        .width,
    child: ElevatedButton(
      onPressed: _loginPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorConstants.appGreen,
        padding: EdgeInsets.all(12.sp),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
      child: Text('Log In',
          style: textBoldWhite18px),
    ),
  );
}

Widget _buildRegisterButton() {
  return Container(
    width: MediaQuery
        .of(context)
        .size
        .width,
    padding: EdgeInsets.symmetric(vertical: 16.sp),
    child: ElevatedButton(
      onPressed: () {
        // push(const SignUpScreen());
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: ThemeService().getDarkTheme()
            ? Colors.white
            : ColorConstants.primaryColor,
        padding: EdgeInsets.all(12.sp),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
      child: Text('Sign Up',
          style: ThemeService().getDarkTheme()
              ? textBoldGreen18px
              : textBoldWhite18px),
    ),
  );
}

void _loginPressed() {
  _email = _emailController.text;
  _pass = _passController.text;

  if (_email!.isEmpty) {
    showMessage("Validation Error", "Email is required!");
    return;
  }
  if (_pass!.isEmpty) {
    showMessage("Validation Error", "Password is required!");
    return;
  }
  _login();
}

bool _isValidUrl() {
  return _urlController.text.isNotEmpty;
}
}
