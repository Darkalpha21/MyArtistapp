import 'package:my_artist_demo/app/services/odoo_response.dart';
import 'package:my_artist_demo/app/utility/color_constants.dart';
import 'package:my_artist_demo/app/utility/styles.dart';
import 'package:my_artist_demo/app/widgets/custom_text_field.dart';
import 'package:my_artist_demo/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  ResetPasswordPageState createState() => ResetPasswordPageState();
}

class ResetPasswordPageState extends Base<ResetPasswordPage> {
  bool _progressBarActive = false;
  String email = "";
  final _emailCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final emailField = CustomTextField(
      title: "Email *",
      hintText: "Email",
      inputAction: TextInputAction.next,
      inputType: TextInputType.emailAddress,
      controller: _emailCtrl,
    );

    final confirmButton = SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstants.colorPrimary,
          padding: EdgeInsets.symmetric(vertical: 16.sp),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        onPressed: () {
          if (_emailCtrl.text.isEmpty) {
            showMessage("Validation Error", "Email is required!");
            return;
          }
          resetPassword();
        },
        child: Text(
          'Confirm',
          style: textBoldWhite18px,
        ),
      ),
    );

    Widget loadingIndicator = _progressBarActive
        ? Center(
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
            )
          ],
        ),
        child: const CircularProgressIndicator(),
      ),
    )
        : Container();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F7), // soft background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text("Reset Password", style: textBold18px),
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 24.h),
            children: [
              Container(
                padding: EdgeInsets.all(18.sp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 2),
                      blurRadius: 5,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    emailField,
                    SizedBox(height: 28.h),
                    confirmButton,
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: loadingIndicator,
          ),
        ],
      ),
    );
  }

  // ------------------------------
  // DO NOT MODIFY — YOUR LOGIC
  // ------------------------------
  resetPassword() {
    setState(() {
      _progressBarActive = true;
    });
    email = _emailCtrl.text.toString();
    Map<String, dynamic> values = {};
    values["login"] = email;
    isNetworkConnected().then((isInternet) {
      if (isInternet) {
        odoo.callResetPassword(values).then((OdooResponse res) {
          setState(() {
            _progressBarActive = false;
          });
          if (!res.hasError()) {
            if (res.getResult()["reset_result"] == true) {
              showMessage("Successful", res.getResult()["disp_msg"]);
            } else {
              showMessage("Alert", res.getResult()["disp_msg"]);
            }
          } else {
            showMessage("Error", res.getErrorMessage());
          }
        });
      }
    });
  }
}
