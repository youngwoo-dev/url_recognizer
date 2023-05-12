import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_recognizer/common/component/ct_text.dart';
import 'package:url_recognizer/common/const/ct_colors.dart';
import 'package:url_recognizer/common/utils/ct_string.dart';

enum CTTextFieldType {
  password,
  cost,
  expireDate,
  multiline,
  email,
  barcode,
}

class CTTextField extends StatelessWidget {
  final double left;
  final double right;
  final double top;
  final double bottom;
  final CTTextFieldType? type;
  final String? hint;
  final int? minLine;
  final TextEditingController? controller;
  final Icon? prefixIcon;
  final TextAlign? textAlign;
  final ValueChanged<String>? onChanged;
  final bool autofocus;

  const CTTextField({
    Key? key,
    this.left = 36,
    this.right = 36,
    this.top = 12,
    this.bottom = 0,
    this.type,
    this.hint,
    this.minLine,
    this.controller,
    this.prefixIcon,
    this.textAlign,
    this.onChanged,
    this.autofocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CTColors.white,
      margin: EdgeInsets.only(left: left, right: right, top: top, bottom: bottom),
      child: TextField(
          obscureText: type == CTTextFieldType.password,
          obscuringCharacter: '·',
          autofocus: autofocus,
          controller: controller,
          textAlign: textAlign ?? TextAlign.start,
          keyboardType: _getKeyboardInputType(type),
          inputFormatters: _getInputFormatters(type),
          minLines: (type == CTTextFieldType.multiline) ? ((minLine == null) ? 4 : minLine) : null,
          maxLines: (type == CTTextFieldType.multiline) ? 10000 : 1,
          style: CTTextStyle(size: 15),
          onChanged: onChanged,
          cursorColor: CTColors.yellow,
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            hintText: hint,
            errorStyle: CTTextStyle(size: 14, color: CTColors.red7),
            hintStyle: CTTextStyle(size: 15, color: CTColors.gray5),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: (type == CTTextFieldType.multiline) ? 14 : 15,
            ),
            enabledBorder: border(width: 1, color: CTColors.gray3),
            focusedBorder: border(width: 2, color: CTColors.yellow),
            errorBorder: border(width: 2, color: CTColors.red6),
            focusedErrorBorder: border(width: 2, color: CTColors.red6),
          )),
    );
  }

  OutlineInputBorder border({required double width, required Color color}) {
    return OutlineInputBorder(
      borderSide: BorderSide(width: width, color: color),
      borderRadius: BorderRadius.circular(type == CTTextFieldType.multiline ? 20 : 50),
    );
  }

  TextInputType? _getKeyboardInputType(CTTextFieldType? type) {
    if (type == CTTextFieldType.cost || type == CTTextFieldType.expireDate)
      return TextInputType.numberWithOptions(signed: false, decimal: false);
    if (type == CTTextFieldType.email) return TextInputType.emailAddress;
  }

  List<TextInputFormatter>? _getInputFormatters(CTTextFieldType? type) {
    if (type == CTTextFieldType.cost) return [CostTextFormatter()];
    if (type == CTTextFieldType.expireDate) return [DateTextFormatter()];
    if (type == CTTextFieldType.barcode) return [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_-]'))];
  }
}
