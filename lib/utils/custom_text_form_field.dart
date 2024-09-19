import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';


class CustomTextFormField extends StatefulWidget {
  CustomTextFormField({
    Key? key,
    this.filled,
    this.fillColor,
    this.textEditingController,
    this.obscureText = false,
    this.textInputAction = TextInputAction.done,
    this.keyboardType = TextInputType.text,
    this.labelText,
    this.hintText,
    this.errorText,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.focusNode,
    this.nextFocusNode,
    this.isReadOnly = false,
    this.onTap,
    this.minLines,
    this.maxLines,
    this.suffixIcon,
    this.prefixIcon,
    this.underline = false,
    this.inputFormatters,
    this.heading,
    this.hintColor,
    this.isRequired = true,
    this.onTapOutside,
    this.textCapitalization,
    this.note,
    this.infoView,
    this.onInfoTap,
    this.maxLength,
  }) : super(key: key);

  //
  final bool? filled;
  final Color? fillColor;
  final TextEditingController? textEditingController;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;

  //
  final String? labelText;
  final String? heading;
  final String? hintText;
  final String? errorText;
  final String? note;

  final Function(String)? onChanged;
  final Function? onFieldSubmitted;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  bool isReadOnly = false;
  final Function()? onTap;
  final int? minLines;
  final int? maxLines;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final Color? hintColor;
  final bool? infoView;
  final Function()? onInfoTap;
  final bool underline;
  final TextCapitalization? textCapitalization;
  bool isRequired = true;
  Function(PointerDownEvent)? onTapOutside;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeading(),
        SizedBox(height: 6.h),
        _buildInputField(),
        SizedBox(height: 6.h),
        _buildErrorText(),
      ],
    );
  }

  Widget _buildErrorText() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.errorText.isNotEmptyAndNotNull
            ? Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.error,
              size: 14.sp,
              color: Color(0xFFBA0E00),
            ),
            SizedBox(
              width: 6.w,
            ),
            Text(
              widget.errorText ?? "",
              textAlign: TextAlign.left,
              maxLines: 2,
              style: GoogleFonts.inter(
                color: Color(0xFFBA0E00),
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ).w(context.percentWidth * 85)
          ],
        ).w(context.percentWidth * 93)
            : SizedBox(),
      ],
    );
  }

  Widget _buildHeading() {
    if (widget.heading.isNotEmptyAndNotNull) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: widget.heading,
                  style: GoogleFonts.inter(
                    color: Theme.of(context).textTheme.titleLarge!.color,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

        ],
      );
    } else {
      return SizedBox();
    }
  }

  Widget _buildInputField() {
    return Container(
      width: 375.w,
      decoration: ShapeDecoration(
        color: widget.errorText.isNotEmptyAndNotNull
            ? Theme.of(context).cardColor
            : Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: widget.errorText.isNotEmptyAndNotNull
              ? BorderSide(
              width: 2.w, color: Color(0xFFA31909), strokeAlign: -1)
              : BorderSide.none,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              textCapitalization:
              widget.textCapitalization ?? TextCapitalization.none,
              cursorRadius: Radius.elliptical(10.r, 10.r),
              onTapOutside: widget.onTapOutside,
              inputFormatters: widget.inputFormatters,
              maxLength: widget.maxLength,
              decoration: InputDecoration(
                suffix: widget.suffixIcon != null
                    ? null
                    : widget.focusNode != null &&
                    widget.focusNode!.hasFocus &&
                    !(widget.obscureText) &&
                    (!widget.isReadOnly)
                    ? Icon(
                  Icons.clear_rounded,
                  size: 18.sp,
                  color:
                  Theme.of(context).textTheme.titleSmall!.color,
                ).onInkTap(() {
                  widget.textEditingController?.clear();
                })
                    : null,
                hintMaxLines: 1,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                // errorText: widget.errorText,
                filled: widget.fillColor != null,
                fillColor: widget.fillColor,
                suffixIcon: widget.suffixIcon ?? _getSuffixWidget(),
                errorMaxLines: 1,
                counterText: '',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.r,
                  vertical: 16.r,
                ),
                hintText: widget.labelText ?? widget.hintText,
                prefixIcon: widget.prefixIcon,
                hintStyle: GoogleFonts.inter(
                  color: widget.hintColor ??
                      Theme.of(context).textTheme.bodySmall!.color,
                  fontWeight: FontWeight.w500,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2.r,
                    color: context.textTheme.bodySmall!.color!,
                    strokeAlign: BorderSide.strokeAlignInside,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              onFieldSubmitted: (data) {
                if (widget.onFieldSubmitted != null) {
                  widget.onFieldSubmitted!(data);
                } else {
                  FocusScope.of(context).requestFocus(widget.nextFocusNode);
                }
              },
              autofocus: widget.focusNode?.hasFocus ?? false,
              autovalidateMode: AutovalidateMode.always,
              cursorOpacityAnimates: true,
              obscureText: (widget.obscureText) ? !makePasswordVisible : false,
              onTap: widget.onTap,
              readOnly: widget.isReadOnly ?? false,
              controller: widget.textEditingController,
              validator: widget.validator,
              focusNode: widget.focusNode,
              style: GoogleFonts.inter(
                color: Theme.of(context).textTheme.titleMedium!.color,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
              onChanged: widget.onChanged,
              textInputAction: widget.textInputAction,
              keyboardType: widget.keyboardType,
              textAlignVertical: TextAlignVertical.center,
              minLines: widget.minLines,
              maxLines: widget.obscureText ? 1 : widget.maxLines,
            ),
          ),
        ],
      ),
    );
  }

  //check if it's password input
  bool makePasswordVisible = false;
  _getSuffixWidget() {
    if (widget.obscureText) {
      return ButtonTheme(
        minWidth: 30.w,
        height: 30.h,
        padding: EdgeInsets.all(0),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.all(0),
          ),
          onPressed: () {
            setState(() {
              makePasswordVisible = !makePasswordVisible;
            });
          },
          child: Icon(
            (!makePasswordVisible)
                ? Icons.visibility_off
                : Icons.visibility,
            color: Theme.of(context).textTheme.titleLarge!.color,
          ),
        ),
      );
    } else {
      return null;
    }
  }
}
