import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_artist_demo/app/helper/email_checker.dart';
import 'package:my_artist_demo/app/models/groups.dart';
import 'package:my_artist_demo/app/models/user.dart';
import 'package:my_artist_demo/app/services/odoo_response.dart';
import 'package:my_artist_demo/app/theme/theme_controller.dart';
import 'package:my_artist_demo/app/utility/color_constants.dart';
import 'package:my_artist_demo/app/utility/constant.dart';
import 'package:my_artist_demo/app/utility/images.dart';
import 'package:my_artist_demo/app/utility/intl_phone_field/intl_phone_field.dart';
import 'package:my_artist_demo/app/utility/shared_prefs.dart';
import 'package:my_artist_demo/app/utility/styles.dart';
import 'package:my_artist_demo/app/widgets/custom_app_bar.dart';
import 'package:my_artist_demo/app/widgets/custom_snackbar.dart';
import 'package:my_artist_demo/app/widgets/custom_text_field.dart';
import 'package:my_artist_demo/base.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
   SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends Base<SignUpScreen> {
  final bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  int maxLength = 0;
  String base64String = "";
  late String _selectedDb = "";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeService().getDarkTheme()
          ? Colors.black
          : ColorConstants.bgColor.withOpacity(0.95),

      key: scaffoldKey,
      appBar: const CustomAppBar(title: "Sign Up"),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [

            // Removed Photo Section Completely

            CustomTextField(
              title: "Name *",
              hintText: "Name",
              inputAction: TextInputAction.next,
              inputType: TextInputType.text,
              controller: _nameController,
            ),
            SizedBox(height: 20.h),

            CustomTextField(
              title: "Email *",
              hintText: "Email",
              inputAction: TextInputAction.next,
              inputType: TextInputType.emailAddress,
              controller: _emailController,
            ),
            SizedBox(height: 20.h),

            Text(
              "Mobile",
              style: poppinsBold.copyWith(
                color: ThemeService().getDarkTheme()
                    ? Colors.white
                    : ColorConstants.colorPrimary,
              ),
            ),
            SizedBox(height: 8.h),

            IntlPhoneField(
              onChanged: (phone) {
                setState(() {
                  _mobileController.text = phone.completeNumber;
                  maxLength = phone.maxLength;
                });
              },
              onCountryChanged: (country) {
                maxLength = country.minLength;
              },
              textInputAction: TextInputAction.next,
              initialCountryCode: 'IN',
              dropdownImage: Images.downArrow,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9+()]')),
                LengthLimitingTextInputFormatter(20),
              ],
              style: poppinsBold.copyWith(
                color: ThemeService().getDarkTheme()
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            SizedBox(height: 20.h),

            CustomTextField(
              title: "Password *",
              hintText: "Password",
              isPassword: true,
              inputAction: TextInputAction.next,
              controller: _passController,
              isShowSuffixIcon: true,
            ),
            SizedBox(height: 20.h),

            CustomTextField(
              title: "Confirm Password *",
              hintText: "Confirm Password",
              isPassword: true,
              inputAction: TextInputAction.done,
              controller: _confirmPassController,
              isShowSuffixIcon: true,
            ),

            SizedBox(height: 40.h),
          ],
        ),
      ),

      bottomNavigationBar: Wrap(
        children: [
          _isLoading
              ? const Center(
            child: CircularProgressIndicator(
              valueColor:
              AlwaysStoppedAnimation<Color>(ColorConstants.colorPrimary),
            ),
          )
              : Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
            child: ElevatedButton(
              onPressed: () {
                String name = _nameController.text.trim();
                String email = _emailController.text.trim();
                String mobile = _mobileController.text.trim();
                String password = _passController.text.trim();
                String cPassword = _confirmPassController.text.trim();

                if (name.isEmpty) {
                  showCustomSnackBar("Enter Name", context);
                } else if (email.isEmpty) {
                  showCustomSnackBar("Enter Email Address", context);
                } else if (EmailChecker.isNotValid(email)) {
                  showCustomSnackBar("Enter Valid Email", context);
                } else if (mobile.isEmpty) {
                  showCustomSnackBar("Enter Mobile Number", context);
                } else if (mobile.length < maxLength) {
                  showCustomSnackBar(
                      "Mobile Number is not valid digits", context);
                } else if (password.isEmpty) {
                  showCustomSnackBar("Enter Password", context);
                } else if (cPassword.isEmpty) {
                  showCustomSnackBar("Enter Confirm Password", context);
                } else {
                  registerUser();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeService().getDarkTheme()
                    ? Colors.white
                    : ColorConstants.appGreen,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'Sign Up',
                style: ThemeService().getDarkTheme()
                    ? textBoldGreen18px
                    : textBoldWhite18px,
              ),
            ),
          ),
        ],
      ),
    );
  }
  void registerUser() {
    showLoading();
    isNetworkConnected().then((isInternet) {
      if (isInternet) {
        odoo.callRegister(
            _nameController.text, _emailController.text, _passController.text,
            _mobileController.text, base64String
        ).then((OdooResponse res) {
          if (!res.hasError()) {
            if (res.getResult()["status"] == true)
            {
              // showMessage("Successful", "Registration Successfully");
              odoo.getDatabases().then((OdooResponse res) {
                if (!res.hasError()) {
                  List dynamicList = res.getResult() as List;
                  List<String> dbList = [];
                  for (var db in dynamicList) {
                    dbList.add(db);
                  }
                  _selectedDb = dbList[0];
                  _login();
                }
              }).catchError(
                    (e) {
                  hideLoading();
                  showMessage('warning' , "Invalid URL");
                },
              );
            }
            else
            {
              showMessage("Alert", res.getResult()["message"]);
            }
          } else {
            showMessage("Error", res.getErrorMessage());
          }
        });
      }
    });
  }

  void _login() {
    odoo.authenticate(_emailController.text, _passController.text, _selectedDb).then(
          (OdooResponse res) {
        hideLoading();
        if (!res.hasError()) {
          User user = User.fromJson(res.getResult());
          if (user.uid != 0) {
            odoo.callGroup(user.uid!).then((OdooResponse res) {
              hideLoading();
              if (!res.hasError()) {
                user.groups = Groups.fromJson(res.getResult()['groups']);
                saveUser(json.encode(user));
                SharedPrefs.instance.setString(Constants.DB, _selectedDb);
                // pushAndRemoveUntil(const Home());
              } else {
                showMessage("Error", res.getErrorMessage());
              }
            });
          } else {
            showMessage("Authentication Failed",
                "Please Enter Valid Email or Password");
          }
        } else {
          showMessage("Warning", res.getErrorMessage());
        }
      },
    );
  }
}

