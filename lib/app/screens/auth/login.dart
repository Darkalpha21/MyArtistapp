import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:my_artist_demo/app/models/user.dart';
import 'package:my_artist_demo/app/screens/auth/reset_passwordpage.dart';
import 'package:my_artist_demo/app/screens/auth/sign_upscreen.dart';
import 'package:my_artist_demo/app/screens/home/home.dart';
import 'package:my_artist_demo/app/services/odoo_api.dart';
import 'package:my_artist_demo/app/services/odoo_response.dart';
import 'package:my_artist_demo/app/theme/theme_controller.dart';
import 'package:my_artist_demo/app/utility/color_constants.dart';
import 'package:my_artist_demo/app/utility/constant.dart';
import 'package:my_artist_demo/app/utility/images.dart';
import 'package:my_artist_demo/app/utility/styles.dart';
import 'package:my_artist_demo/app/widgets/custom_text_field.dart';
import 'package:my_artist_demo/base.dart';


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
  final List<String> _dbList = [];
  bool isCorrectURL = false;
  bool isDBFilter = false;

  String? _email;
  String? _pass;
  late String odooURL;


  void _login() async {
    bool isInternet = await isNetworkConnected();
    if (!isInternet) return;

    showLoading();

    odoo.authenticate(_email, _pass, _selectedDb).then((OdooResponse res) {
      if (!res.hasError()) {
        User user = User.fromJson(res.getResult());

        if (user.uid != 0) {
          odoo.callGroup(user.uid!).then((OdooResponse res) async {
            hideLoading();
            if (!res.hasError()) {
               pushAndRemoveUntil(Home());
            }
          });
        } else {
          hideLoading();
          showMessage("Error", res.getErrorMessage());
        }
      } else {
        hideLoading();
        showMessage(
          "Authentication Failed",
          "Please Enter Valid Email or Password",
        );
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
        showMessage('warning', "Invalid URL");
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
    _checkURL();
  }
  @override
  void initState() {
    super.initState();
    // _getPushToken();
    // initUniLinks();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getOdooInstance().then((odoo) {
        _checkFirstTime();
      });
    });
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
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                SizedBox(height: 40.h),

                /// LOGO
                Center(
                  child: Image.asset(
                    Images.logo,
                    height: 130.h,
                    width: 130.w,
                  ),
                ),

                SizedBox(height: 35.h),

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

                _buildShadowBox(_buildEmailField()),
                SizedBox(height: 18.h),
                _buildShadowBox(_buildPasswordField()),

                SizedBox(height: 10.h),

                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      Get.to( () => const ResetPasswordPage(),
                      );
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

                _buildLoginButton(),

                SizedBox(height: 26.h),

                _buildRegisterText(),

                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildShadowBox(Widget child) {
    return Container(
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
      child: child,
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
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: _loginPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstants.appGreen,
          padding: EdgeInsets.all(12.sp),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        child: Text('Log In', style: textBoldWhite18px),
      ),
    );
  }

  Widget _buildRegisterText() {
    return Center(
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
              Get.to(
                  () => SignUpScreen(), );
            },
            child: Text(
              "Sign Up Now",
              style: textBoldGreen16px.copyWith(fontSize: 15.sp),
            ),
          ),
        ],
      ),
    );
  }


  void _loginPressed() {
    _email = _emailController.text.trim();
    _pass = _passController.text.trim();

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
}

