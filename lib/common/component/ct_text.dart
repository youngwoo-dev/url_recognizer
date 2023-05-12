import 'package:flutter/material.dart';
import 'package:url_recognizer/common/const/ct_colors.dart';

enum CTFontWeight {
  R, //regular
  M, //medium
  B, //bold
}

class _CTLetterSpacing {
  static double fromFontWeight(CTFontWeight fontWeight) {
    switch (fontWeight) {
      case CTFontWeight.R:
        return -0.05;
      case CTFontWeight.M:
        return -0.05;
      case CTFontWeight.B:
        return -0.03;
    }
  }
}

class CTText extends StatelessWidget {
  final String text;
  final double? size;
  final CTFontWeight? weight; //R, M, B
  final Color? color;
  final double? height;
  final TextDecoration? decoration;
  final TextAlign? align;
  final TextOverflow? overflow;
  final int? maxLines;

  const CTText(this.text,
      {Key? key, this.size, this.weight, this.color, this.height, this.decoration, this.align, this.overflow, this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      maxLines: maxLines,
      style: CTTextStyle(size: size, weight: weight, color: color, height: height, decoration: decoration, overflow: overflow),
    );
  }
}

TextStyle CTTextStyle({
  double? size,
  CTFontWeight? weight,
  Color? color,
  double? height,
  TextDecoration? decoration,
  TextOverflow? overflow,
}) {
  size = size ?? 14;
  weight = weight ?? CTFontWeight.R;
  color = color ?? CTColors.gray8;
  height = height ?? 1.3;

  double letterSpacing = size * _CTLetterSpacing.fromFontWeight(weight);
  return TextStyle(
    fontSize: size,
    letterSpacing: letterSpacing,
    height: height,
    fontFamily: 'NotoSans${weight.name}',
    color: color,
    decoration: decoration,
    overflow: overflow,
  );
}