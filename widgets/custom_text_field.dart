import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_artist_demo/theme/theme_controller.dart';
import 'package:my_artist_demo/utility/color_constants.dart';
import 'package:my_artist_demo/utility/styles.dart';

class CustomTextField extends StatefulWidget {
  final String? title;
  final String? hintText;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final String? labelText;
  final TextStyle? labelStyle;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final Color? fillColor;
  final int? maxLines;
  final int? minLines;
  final bool? isPassword;
  final bool? isCountryPicker;
  final bool? isShowBorder;
  final bool? isIcon;
  final bool? isShowSuffixIcon;
  final bool? isShowPrefixIcon;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
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
  final bool? isDense;

  const CustomTextField(
      {super.key, this.hintText,
        this.title,
        this.hintStyle,
        this.style,
        this.labelText,
        this.labelStyle,
      this.controller,
      this.focusNode,
      this.nextFocus,
      this.isEnabled = true,
        this.inputFormatters,
        this.prefixIcon,
        this.suffixIcon,
      this.inputType = TextInputType.text,
      this.inputAction = TextInputAction.next,
      this.maxLines = 1,
        this.minLines = 1,
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
        this.isDense = true
      });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      widget.title != null ? Text(
      widget.title!,
        style: poppinsBold.copyWith(
            color: ThemeService().getDarkTheme() ? Colors.white : ColorConstants.colorPrimary
        ),
      ) : const SizedBox(),
    widget.title != null ?  SizedBox(
    height: 8.h,
    ) : const SizedBox(),
      TextFormField(
      autofillHints: widget.isMobile! ? const <String>[AutofillHints.telephoneNumber] : widget.isEmail! ? const <String>[AutofillHints.email] : null,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      controller: widget.controller,
      focusNode: widget.focusNode,
      style: widget.style != null ? widget.style! :
      ThemeService().getDarkTheme() ? textRegularWhite :poppinsRegular,
      textInputAction: widget.inputAction,
      keyboardType: widget.inputType,
      cursorColor: ColorConstants.colorPrimary,
      textCapitalization: widget.capitalization!,
      enabled: widget.isEnabled,
      autofocus: widget.autofocus!,
      //onChanged: widget.isSearch ? widget.languageProvider.searchLanguage : null,
      obscureText: widget.isPassword! ? _obscureText : false,
      inputFormatters:widget.inputFormatters != null ? widget.inputFormatters! : widget.inputType == TextInputType.phone
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp('[0-9+]')),
              LengthLimitingTextInputFormatter(14),
            ]
          : null,

      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(5.sp, 5.sp, 5.sp, 5.sp),
        // border: UnderlineInputBorder(
        //   borderRadius: BorderRadius.circular(10.sp),
        //   borderSide: const BorderSide(style: BorderStyle.none, width: 0),
        // ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ThemeService().getDarkTheme() ? Colors.white : ColorConstants.colorPrimary),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ThemeService().getDarkTheme() ? Colors.white24 : ColorConstants.black),
        ),
        isDense: widget.isDense,
        hintText: widget.hintText,
        // fillColor: widget.fillColor ?? Colors.white,
        hintStyle: widget.hintStyle ?? Theme.of(context).textTheme.displayMedium!.copyWith(
            fontSize: 14.sp,
            color: ColorConstants.greyColor),
        labelText: widget.labelText,
        labelStyle: widget.labelStyle ?? Theme.of(context).textTheme.displayMedium!.copyWith(
            fontSize: 14.sp,
            color: ColorConstants.greyColor),
        // filled: true,
        prefixIcon:
        widget.prefixIcon != null ?widget.prefixIcon! :
        widget.isShowPrefixIcon!
            ? Padding(
                padding: EdgeInsets.only(
                    left: 18.sp,
                    right: 8.sp),
                child:
                Image.asset(widget.prefixIconUrl!),
              )
            : null,
        prefixIconConstraints: BoxConstraints(minWidth: 23.w, maxHeight: 20.h),
        suffixIconConstraints: BoxConstraints(minHeight: 30.w, maxHeight: 30.h,minWidth: 30.w, maxWidth: 30.h),
        suffixIcon:
        widget.suffixIcon != null ? widget.suffixIcon! :
        widget.isShowSuffixIcon!
            ? widget.isPassword!
                ? IconButton(
                    icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: ThemeService().getDarkTheme() ? Colors.white : ColorConstants.colorPrimary),
                    onPressed: _toggle)
                : widget.isIcon!
                    ? IconButton(
                        onPressed: widget.onSuffixTap,
                        icon: Image.asset(
                          widget.suffixIconUrl!,
                          width: 10.w,
                          height: 10.h,
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
    )
    ])
    ;
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
