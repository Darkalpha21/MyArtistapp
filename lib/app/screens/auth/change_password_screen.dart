import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_artist_demo/app/services/odoo_response.dart';
import 'package:my_artist_demo/app/theme/theme_controller.dart';
import 'package:my_artist_demo/app/utility/color_constants.dart';
import 'package:my_artist_demo/app/utility/styles.dart';
import 'package:my_artist_demo/app/widgets/custom_app_bar.dart';
import 'package:my_artist_demo/app/widgets/custom_button.dart';
import 'package:my_artist_demo/app/widgets/custom_snackbar.dart';
import 'package:my_artist_demo/app/widgets/custom_text_field.dart';
import 'package:my_artist_demo/base.dart';

class ChangePasswordScreen extends StatefulWidget {

  const ChangePasswordScreen({super.key});

  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends Base<ChangePasswordScreen> {
  final bool _isLoading = false;
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ThemeService().getDarkTheme() ? null : ColorConstants.bgColor,
        key: scaffoldKey,
        appBar: const CustomAppBar(title: "Change Password"),
        body: Padding(
          padding: EdgeInsets.all(10.sp),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              CustomTextField(
                title:"Old Password *",
                hintText: "Name",
                  isPassword: true,
                inputAction: TextInputAction.next,
                controller: _oldPasswordController,
                  isShowSuffixIcon:true
              ),
              SizedBox(height: 16.h),
              

              CustomTextField(
                title: "Password *",
                  hintText: "Password",
                  isPassword: true,
                  inputAction: TextInputAction.next,
                  controller: _newPasswordController,
                  isShowSuffixIcon:true
              ),
              SizedBox(height: 16.h),

              CustomTextField(
                title: "Confirm Password *",
                  hintText: "Confirm Password",
                  isPassword: true,
                  inputAction: TextInputAction.next,
                  controller: _confirmPassController,
                  isShowSuffixIcon:true
              ),
    
              SizedBox(height: 30.h),

            ],
          ),
        ),

    bottomNavigationBar:

      Wrap(
        children: [
          _isLoading
              ? const Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    ColorConstants.colorPrimary)),
          )
              :
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
            child: ElevatedButton(
              onPressed: ()
              {
                String oldPassword = _oldPasswordController.text.trim();
                String newPassword = _newPasswordController.text.trim();
                String cPassword = _confirmPassController.text.trim();
                if (oldPassword.isEmpty) {
                  showCustomSnackBar("Enter Your Old Password", context);
                } 
                else if (newPassword.isEmpty) {
                  showCustomSnackBar("Enter Your New Password", context);
                }
                else if (cPassword.isEmpty) {
                  showCustomSnackBar("Enter Your Confirm Password", context);
                }
                else
                {
                  changePassword();
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: ThemeService().getDarkTheme() ? Colors.white : ColorConstants.appGreen,
                padding: EdgeInsets.all(12.sp),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Text(
                  'Submit',
                  style: ThemeService().getDarkTheme() ? textBoldGreen18px : textBoldWhite18px
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getOdooInstance();
  }
  
  changePassword() {
   showLoading();
    isNetworkConnected().then((isInternet) {
      if (isInternet) {
        Map<String, dynamic> values = {};
        values["old_password"] = _oldPasswordController.text;
        values["user_id"] = getUser()!.uid;
        values["new_password"] = _newPasswordController.text;
        values["confirm_password"] = _confirmPassController.text;
        odoo.callChangePassword(values).then((OdooResponse res) {
          hideLoading();
          if (!res.hasError()) {
            if (res.getResult()["status"] == true)
            {
              showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
                  isDismissible: true,
                  builder: (BuildContext context) {
                    return
                      Container(
                        padding: EdgeInsets.all(10.sp),
                        height: 240.h,
                        color: ColorConstants.white,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 10.h,
                              ),
                              Center(
                                  child: Text(
                                    res.getResult()["message"] ,
                                    style: textBoldBlack,
                                    maxLines: 6,
                                  )),

                              SizedBox(
                                height: 10.h,
                              ),

                              CustomButton(
                                onTap: () {
                                  // Navigator.pop(context);
                                  redirectLogin();
                                },
                                btnTxt: "Ok",
                                backgroundColor: ColorConstants.colorPrimary,

                              ),
                            ]),
                      )
                    ;
                  }
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


}
