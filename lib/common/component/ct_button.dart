import 'package:flutter/material.dart';
import 'package:url_recognizer/common/component/ct_text.dart';
import 'package:url_recognizer/common/const/ct_colors.dart';

class CTButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color color;
  final double height;
  final double width;
  final double paddingHor;
  final double paddingVer;
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;

  const CTButton({
    Key? key,
    this.onPressed,
    required this.child,
    this.color = CTColors.trans,
    this.height = 45,
    this.width = 0,
    this.paddingHor = 0,
    this.paddingVer = 0,
    this.borderRadius = 100,
    this.borderWidth = 0,
    this.borderColor = CTColors.gray3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: child,
      style: TextButton.styleFrom(
        foregroundColor: CTColors.gray5,
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: paddingHor, vertical: paddingVer),
        minimumSize: Size(width, height),
        side: borderWidth == 0 ? null : BorderSide(width: borderWidth, color: borderColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  factory CTButton.wide({
    required String text,
    Color backgroundColor = CTColors.yellow,
    Widget? icon,
    double iconSpace = 0,
    required VoidCallback onPressed,
  }) {
    return CTButton(
      color: CTColors.yellow,
      borderRadius: 0,
      width: double.infinity,
      child: CTText(text, size: 16, weight: CTFontWeight.M),
      onPressed: onPressed,
    );
  }

  factory CTButton.dialog({
    String text = '',
    double width = double.infinity,
    Color color = CTColors.yellow,
    VoidCallback? onPressed,
  }) {
    return CTButton(
      width: width,
      color: color,
      onPressed: onPressed,
      child: CTText(text, size: 16, weight: CTFontWeight.M),
    );
  }

  factory CTButton.test({
    required VoidCallback onPressed,
  }) {
    return CTButton(
      width: 100,
      color: CTColors.gray3,
      onPressed: onPressed,
      child: CTText('테스트', size: 16, weight: CTFontWeight.M),
    );
  }
}
