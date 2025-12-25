import 'dart:io';
import 'package:my_artist_demo/app/models/partners.dart';
import 'package:my_artist_demo/app/services/odoo_response.dart';
import 'package:my_artist_demo/app/utility/color_constants.dart';
import 'package:my_artist_demo/app/utility/images.dart';
import 'package:my_artist_demo/app/utility/strings.dart';
import 'package:my_artist_demo/app/widgets/custom_snackbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:my_artist_demo/app/widgets/custom_text_field.dart';
import 'package:my_artist_demo/base.dart';

import '../../utility/styles.dart' show textBold18px, textBoldWhite, textBoldWhite18px, textBoldPrimary18px, poppinsBold, textRegular16px;


class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends Base<EditProfilePage> {
  bool _progressBarActive = false;
  var fullAddress = "";
  String? base64String;
  String? imageURL = "";
  final _nameCtrl = TextEditingController();
  // final _phoneCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  // final _countryCtrl = TextEditingController();
  // final _stateCtrl = TextEditingController();
  // final _streetCtrl = TextEditingController();
  // final _street2Ctrl = TextEditingController();
  // final _zipCtrl = TextEditingController();
  // final _cityCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  String imagePath = "";
  File? galleryFile;
  File? cameraFile;
  bool imgSelected = false;
  final ImagePicker _picker = ImagePicker();
  // final List<CountrySelection> _countryList = [];
  // CountrySelection? _selectCountry;
  // final List<StateSelection> _stateList = [];
  // StateSelection? _selectState;

  @override
  void initState() {
    super.initState();
    getOdooInstance().then((odoo) {
      isNetworkConnected().then((isInternet) {
        if (!isInternet) {
          showMessage(Strings.msg_header_internerconnection,
              Strings.msg_body_internerconnection);
          return;
        }
        _getProfileData();
      });
    });
  }

  _getProfileData() {
    setState(() {
      _progressBarActive = true;
    });
    List<String> fields = [];
    fields = Partners.fields;
    fields.add("image_1920");
    odoo
        .searchRead(
            Strings.res_partner,
            [
              ["id", "=", getUser()!.partnerId],
            ],
            fields)
        .then(
      (OdooResponse res) {
        setState(() {
          _progressBarActive = false;
        });
        if (!res.hasError()) {
          setState(() {
            final result = res.getResult()[0];
            imageURL = "${getURL()}/web/content?model=res.partner&id=${getUser()!.partnerId}&field=image_1920&${getSession()}";
            Partners partners = Partners.fromJson(result,imageURL!);
            String name = partners.name!;
            String email = partners.email!;
            // String phone = partners.phone!;
            String mobile = partners.mobile!;
            // String street = partners.street!;
            // String street2 = partners.street2!;
            // String city = partners.city!;
            // String zip = partners.zip!;
            base64String = partners.base64String!;
            // int countryId = partners.countryId?.id ?? 0;
            // String country = partners.countryId?.name ?? "";
            // _selectCountry = CountrySelection(id: countryId, name: country);
            // String state = partners.stateId?.name ?? "";
            // int stateId = partners.stateId?.id ?? 0;
            // _selectState = StateSelection(id: stateId, name: state);
            _nameCtrl.text = name;
            _emailCtrl.text = email;
            // _countryCtrl.text = country;
            // _cityCtrl.text = city;
            // _streetCtrl.text = street;
            // _street2Ctrl.text = street2;
            // _zipCtrl.text = zip;
            // _stateCtrl.text = state;
            // _phoneCtrl.text = phone;
            _mobileCtrl.text = mobile;
          });
        }
        // _getCountry();
      },
    );
  }

  PreferredSizeWidget buildBar(BuildContext context) {
    var appBarTitle = Text("Edit Profile", style: textBold18px);

    return AppBar(
      title: appBarTitle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = CustomTextField(hintText: 'Name *', controller: _nameCtrl);

    final email = CustomTextField(
        inputType: TextInputType.emailAddress,
        hintText: 'Email *',
        controller: _emailCtrl);



    final mobile = CustomTextField(
        isMobile: true, hintText: 'Mobile', controller: _mobileCtrl);

    final registerButton = Container(
      padding: EdgeInsets.all(10.sp),
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.r),
          ),
          backgroundColor: ColorConstants.colorPrimary,
          padding: EdgeInsets.all(16.sp),
        ),
        onPressed: () {
          if (_nameCtrl.text.isEmpty) {
            showMessage("Validation Error", "Name is required!");
            return;
          }
          if (_emailCtrl.text.isEmpty) {
            showMessage("Validation Error", "Email is required!");
            return;
          }
          updateToProfile();
        },
        child: Text('Update Profile', style: textBoldWhite18px),
      ),
    );



    final upperHeader = Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.all(15.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            imgSelected
                ? Container(
                    width: 150.w,
                    height: 150.h,
                    padding: EdgeInsets.all(10.sp),
                    margin: EdgeInsets.all(25.sp),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // borderRadius: BorderRadius.circular(75),
                      color: Colors.white10,
                      border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 2.w,
                      ),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: FileImage(File(imagePath)),
                      ),
                    ),
                  )
                : imageURL != null
                    ? SizedBox(
                        width: 150.w,
                        height: 150.h,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(75.r),
                          child: CachedNetworkImage(
                            imageUrl: imageURL!,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Image.asset(Images.customer),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : CircleAvatar(
                        radius: 30.r,
                        backgroundColor: ColorConstants.colorPrimary,
                        child: ClipOval(
                          child: Text(
                              _nameCtrl.text +
                                  _nameCtrl.text.substring(
                                      _nameCtrl.text.indexOf(" ") + 1)[0],
                              style: textBoldWhite),
                        ),
                      ),
            SizedBox(
              height: 10.h,
            ),
            InkWell(
              onTap: () {
                attachFile();
              },
              child: Text(
                'Edit Photo',
                style: textBoldPrimary18px,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );

    Widget loadingIndicator = _progressBarActive
        ? const Center(child: CircularProgressIndicator())
        : Container();

    return Scaffold(
      appBar: buildBar(context),
      body: Stack(children: <Widget>[
        Column(children: <Widget>[
          Expanded(
            child: ListView(children: <Widget>[
              upperHeader,
              Padding(
                padding: EdgeInsets.all(16.sp),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Name *", style: poppinsBold),
                            SizedBox(height: 5.h),
                            name,
                            SizedBox(height: 20.h),
                            Text("Email *", style: poppinsBold),
                            SizedBox(height: 5.h),
                            email,
                            SizedBox(height: 20.h),
                            // Text("Phone", style: poppinsBold),
                            // SizedBox(height: 5.h),
                            // phone,
                            // SizedBox(height: 20.h),
                            Text("Mobile", style: poppinsBold),
                            SizedBox(height: 5.h),
                            mobile,
                            SizedBox(height: 20.h),

                            SizedBox(height: 20.h),
                          ]),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ]),
          ),
          registerButton,
        ]),
        Align(
          alignment: FractionalOffset.center,
          child: loadingIndicator,
        ),
      ]),
    );
  }

  updateToProfile() async {
    // setState(() {
    //   _progressBarActive = true;
    // });
    showLoading();
    if (base64String == null) {
      if (imageURL != "") {
        base64String = await networkImageToBase64(imageURL!);
      }
    }
    Map<String, dynamic> values = {};
    values["name"] = _nameCtrl.text;
    values["email"] = _emailCtrl.text;
    if (_mobileCtrl.text.isNotEmpty) {
      values["mobile"] = _mobileCtrl.text;
    }
    values["partner_id"] = user!.partnerId;


    if (base64String != null) {
      values["image_1920"] = base64String;
    }
    odoo.callUpdateProfile(values).then((OdooResponse res) async {
      if (!res.hasError()) {
        if (res.getResult()["status"] == true) {
          hideLoading();
          showCustomSnackBar(res.getResult()["message"], context,isError: false);
          _sendDataBack(context);
        } else {
          hideLoading();
          showMessage("Alert", res.getResult()["message"]);
        }
      } else {
        hideLoading();
        showMessage("Error", res.getErrorMessage());
      }
    });
  }

  imageSelectorGallery() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    galleryFile = File(pickedFile!.path);
    setState(() {
      imgSelected = true;
      imagePath = galleryFile!.path;
      base64String = base64Encode(galleryFile!.readAsBytesSync());
    });
  }

  imageSelectorCamera() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );
    cameraFile = File(pickedFile!.path);
    setState(() {
      imgSelected = true;
      imagePath = cameraFile!.path;
      base64String = base64Encode(cameraFile!.readAsBytesSync());
    });
  }

  attachFile() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
          title: Text("Attach File", style: textBold18px),
          message: Text("Choose Images from", style: textRegular16px),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text("Gallery", style: textBold18px),
              onPressed: () {
                Navigator.pop(context, 'Gallery');
                imageSelectorGallery();
              },
            ),
            CupertinoActionSheetAction(
              child: Text("Camera", style: textBold18px),
              onPressed: () {
                Navigator.pop(context, 'Camera');
                imageSelectorCamera();
              },
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
            child: Text("Cancel", style: textBold18px),
          )),
    );
  }

  void _sendDataBack(BuildContext context) {
    Navigator.pop(context, "1");
  }


}
