import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_artist_demo/app/utility/color_constants.dart';
import 'package:my_artist_demo/app/utility/styles.dart';


class CustomTextInputField extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final Color? fillColor;
  final int? maxLines;
  final bool? isPassword;
  final bool? isCountryPicker;
  final bool? isShowBorder;
  final bool? isIcon;
  final bool? isShowSuffixIcon;
  final bool? isShowPrefixIcon;
  final VoidCallback? onTap;
  final ValueChanged? onChanged;
  final VoidCallback? onSuffixTap;
  final String? suffixIconUrl;
  final String? prefixIconUrl;
  final bool? isSearch;
  final Function? onSubmit;
  final bool? isEnabled;
  final TextCapitalization? capitalization;
  final bool? readOnly;
  final bool? autofocus;
  final bool? isMobile;
  final bool? isEmail;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextInputField(
      {Key? key, this.hintText = 'Write something...',
      this.controller,
      this.focusNode,
      this.nextFocus,
      this.isEnabled = true,
      this.inputType = TextInputType.text,
      this.inputAction = TextInputAction.next,
      this.maxLines = 1,
      this.onSuffixTap,
      this.fillColor,
      this.onSubmit,
      this.onChanged,
      this.capitalization = TextCapitalization.none,
      this.isCountryPicker = false,
      this.isShowBorder = false,
      this.isShowSuffixIcon = false,
      this.isShowPrefixIcon = false,
      this.onTap,
      this.isIcon = false,
      this.isPassword = false,
      this.suffixIconUrl,
      this.prefixIconUrl,
      this.isSearch = false,
      this.readOnly = false,
        this.autofocus = false,
        this.isMobile = false,
        this.isEmail = false,
        this.inputFormatters
      }) : super(key: key);

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextInputField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return
      TextFormField(
      autofillHints: widget.isMobile! ? const <String>[AutofillHints.telephoneNumber] : widget.isEmail! ? const <String>[AutofillHints.email] : null,
      maxLines: widget.maxLines,
      controller: widget.controller,
      focusNode: widget.focusNode,
      style:
      poppinsRegular,
      // Theme.of(context).textTheme.displayMedium!.copyWith(
      //     color: Theme.of(context).textTheme.bodyText2!.color,
      //     fontSize: Dimensions.FONT_SIZE_DEFAULT),
      textInputAction: widget.inputAction,
      keyboardType: widget.inputType,
      cursorColor: ColorConstants.colorPrimary,
      textCapitalization: widget.capitalization!,
      enabled: widget.isEnabled,
      autofocus: widget.autofocus!,
      //onChanged: widget.isSearch ? widget.languageProvider.searchLanguage : null,
      obscureText: widget.isPassword! ? _obscureText : false,
      inputFormatters: widget.inputFormatters != null ? widget.inputFormatters! :
      widget.inputType == TextInputType.phone
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp('[0-9+]')),
              LengthLimitingTextInputFormatter(14),
            ]
          : null,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 16.sp, horizontal: 22.sp),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.sp),
          borderSide: const BorderSide(style: BorderStyle.none, width: 0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ColorConstants.colorPrimary),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ColorConstants.colorPrimary),
        ),
        isDense: true,
        hintText: widget.hintText,
        fillColor: widget.fillColor ?? Colors.white,
        hintStyle: Theme.of(context).textTheme.displayMedium!.copyWith(
            fontSize: 12.sp,
            color: ColorConstants.grey),
        filled: true,
        prefixIcon: widget.isShowPrefixIcon!
            ? Padding(
                padding: EdgeInsets.only(
                    left: 20.sp,
                    right: 10.sp),
                child: Image.asset(widget.prefixIconUrl!),
              )
            : const SizedBox.shrink(),
        prefixIconConstraints: BoxConstraints(minWidth: 23.w, maxHeight: 20.h),
        suffixIcon: widget.isShowSuffixIcon!
            ? widget.isPassword!
                ? IconButton(
                    icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Theme.of(context).hintColor),
                    onPressed: _toggle)
                : widget.isIcon!
                    ? IconButton(
                        onPressed: widget.onSuffixTap,
                        icon: Image.asset(
                          widget.suffixIconUrl!,
                          width: 15.w,
                          height: 15.h,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      )
                    : null
            : null,
      ),
      onTap: widget.onTap,
      onFieldSubmitted: (text) => widget.nextFocus != null
          ? FocusScope.of(context).requestFocus(widget.nextFocus)
          : widget.onSubmit!(text),
        onChanged: widget.onChanged,
      readOnly: widget.readOnly!,
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
