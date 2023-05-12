import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CTString {
  static String trim(String string) {
    // '   aa     bb   cc    ' -> 'aa bb cc'
    var value = string.replaceAll(RegExp(r'\s+'), ' ');
    value = value.replaceAll(RegExp(r'^\s+'), '');
    value = value.replaceAll(RegExp(r'\s+$'), '');
    return value;
  }

  /// '   aa     bb   cc    ' -> 'abc'
  static String removeSpace(String string) {
    var value = string.replaceAll(RegExp(r'\s+'), '');
    return value;
  }


  ///'12,345,678' -> 12345678
  static int? costStringToInt(String string) {
    return int.tryParse(string.replaceAll(',', ''));
  }

  /// '20121231' -> true
  static bool isValidDate(int num) {
    if (num == 99999999) return true;
    var value = num.toString();
    if (value.length != 8 || !isNumber(value)) return false;
    var parsedDate = DateTime.parse(value);
    var formattedDate = DateFormat('yyyyMMdd', 'en_US').format(parsedDate);
    if (value == formattedDate) return true;
    return false;
  }

  ///'1234' -> true
  static bool isNumber(String string) {
    var value = string.replaceAll(RegExp(r'[^0-9]'), '');
    if (string == value) return true;
    return false;
  }

  ///12345 -> '12,345'
  static String intToCostString(int num) {
    return NumberFormat(',###').format(num);
  }

  ///20231203 -> '2023년 12월 03일'
  static String intToDateString(int num) {
    try {
      if (num == 99999999) return '';
      var numString = num.toString();
      var year = numString.substring(0, 4);
      var month = numString.substring(4, 6);
      var day = numString.substring(6, 8);
      return '$year년 $month월 $day일';
    } catch (error, stackTrace) {
      return '';
    }
  }

  ///'2023년 12월 03일' -> 20231203
  static int dateStringToInt(String string) {
    return int.tryParse(string.replaceAll(RegExp(r'[^0-9]'), '')) ?? 99999999;
  }

  /// 'a,b,c' -> ['a', 'b', 'c']
  static List<String> stringToList(String string) {
    if (string.isEmpty) return [];
    return string.split(',');
  }

  ///DateTime -> 2020.12.31 14:23
  static String dateDisplayString(DateTime? time) {
    if(time == null) return "";
    return DateFormat('yyyy-MM-dd HH:mm', 'en_US').format(time);
  }
}

class DateTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String dash = '--------';
    String yyyyMMddOld = oldValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    String yyyyMMdd = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    String stringMode =
        (oldValue.text.length > newValue.text.length) ? 'delete' : 'add'; // 문자열에 관한거
    int manipulatedOldValueOffset = (Platform.isIOS && stringMode == 'delete')
        ? oldValue.selection.baseOffset + 1
        : oldValue.selection.baseOffset;
    String mode = 'add';
    if (yyyyMMddOld.length < yyyyMMdd.length)
      mode = 'add';
    else if (yyyyMMddOld.length > yyyyMMdd.length)
      mode = 'delete';
    else {
      //글자가 있는거중 제일 끝으로
      int newSelection = newValue.selection.baseOffset;
      if (newSelection > getLastCursorPosition(yyyyMMdd))
        newSelection = getLastCursorPosition(yyyyMMdd);
      return newValue.copyWith(
          text: oldValue.text,
          selection: TextSelection(baseOffset: newSelection, extentOffset: newSelection));
    }
    int length = yyyyMMdd.length;
    if (length > 8) {
      yyyyMMdd = yyyyMMdd.substring(0, 8);
      length = 8;
    }
    int year = 0;
    int month = 0;
    if (length >= 4) {
      year = int.parse(yyyyMMdd.substring(0, 4));
      if (year < 2000)
        yyyyMMdd = '2000' + yyyyMMdd.substring(4, length);
      else if (year >= 2100) yyyyMMdd = '2099' + yyyyMMdd.substring(4, length);
    }
    if (length >= 6) {
      month = int.parse(yyyyMMdd.substring(4, 6));
      if (month < 1)
        yyyyMMdd = yyyyMMdd.substring(0, 4) + '01' + yyyyMMdd.substring(6, length);
      else if (month > 12)
        yyyyMMdd = yyyyMMdd.substring(0, 4) + '12' + yyyyMMdd.substring(6, length);
    }
    if (length >= 8) {
      int day = int.parse(yyyyMMdd.substring(6, 8));
      int lastDay = DateTime(year, month + 1, 0).day;
      if (day < 1)
        yyyyMMdd = yyyyMMdd.substring(0, 6) + '01';
      else if (day > lastDay) yyyyMMdd = yyyyMMdd.substring(0, 6) + lastDay.toString();
    }
    String yyyyMMddDash = yyyyMMdd + dash.substring(0, 8 - length); //20221---
    String output =
        '${yyyyMMddDash.substring(0, 4)}년 ${yyyyMMddDash.substring(4, 6)}월 ${yyyyMMddDash.substring(6, 8)}일';
    int newSelection = getNextCursorPosition(mode, manipulatedOldValueOffset, yyyyMMdd);
    return newValue.copyWith(
        text: output,
        selection: TextSelection(baseOffset: newSelection, extentOffset: newSelection));
  }

  int getNextCursorPosition(String mode, int oldSelection, String yyyyMMdd) {
    int newSelection = 0;
    if (mode == 'add') {
      newSelection = oldSelection + 1;
      if (oldSelection == 3)
        newSelection = 6;
      else if (oldSelection == 4 || oldSelection == 5 || oldSelection == 6)
        newSelection = 7;
      else if (oldSelection == 7)
        newSelection = 10;
      else if (oldSelection == 8 || oldSelection == 9 || oldSelection == 10) newSelection = 11;
    } else if (mode == 'delete') {
      newSelection = oldSelection - 1;
      if (oldSelection == 7 || oldSelection == 6 || oldSelection == 5)
        newSelection = 4;
      else if (oldSelection == 11 || oldSelection == 10 || oldSelection == 9) newSelection = 8;
    }
    //커서가 위치할 수 있는 마지막 위치
    int availableCursorPosition = 0;
    if (yyyyMMdd.length <= 3)
      availableCursorPosition = yyyyMMdd.length;
    else if (yyyyMMdd.length <= 5)
      availableCursorPosition = yyyyMMdd.length + 2;
    else
      availableCursorPosition = yyyyMMdd.length + 4;
    if (newSelection > availableCursorPosition) newSelection = availableCursorPosition;
    return newSelection;
  }

  int getLastCursorPosition(String yyyyMMdd) {
    int lastCursorPosition = 0;
    if (yyyyMMdd.length <= 4)
      lastCursorPosition = yyyyMMdd.length;
    else if (yyyyMMdd.length <= 6)
      lastCursorPosition = yyyyMMdd.length + 2;
    else
      lastCursorPosition = yyyyMMdd.length + 4;
    return lastCursorPosition;
  }
}

class CostTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String costOld = oldValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    String cost = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    String stringMode = 'add'; // 문자열에 관한거
    String numberMode = 'add'; // 숫자 그 자체에 관한거
    if (cost.length == 0) {
      return newValue.copyWith(text: '', selection: TextSelection(baseOffset: 0, extentOffset: 0));
    }
    if (oldValue.text.length > newValue.text.length) stringMode = 'delete';
    if (costOld.length > cost.length) numberMode = 'delete';
    int manipulatedOldValueOffset = (Platform.isIOS && stringMode == 'delete')
        ? oldValue.selection.baseOffset + 1
        : oldValue.selection.baseOffset;

    if (costOld.length == cost.length) {
      if (stringMode == 'add') {
        return newValue.copyWith(
            text: oldValue.text,
            selection: TextSelection(
                baseOffset: manipulatedOldValueOffset, extentOffset: manipulatedOldValueOffset));
      } else {
        return newValue.copyWith(
            text: oldValue.text,
            selection: TextSelection(
                baseOffset: newValue.selection.baseOffset,
                extentOffset: newValue.selection.baseOffset));
      }
    }
    var formatter = NumberFormat(',###');
    String output = formatter.format(int.parse(cost));
    int newSelection =
        getNextCursorPosition(numberMode, manipulatedOldValueOffset, oldValue.text, output);
    return newValue.copyWith(
        text: output,
        selection: TextSelection(baseOffset: newSelection, extentOffset: newSelection));
  }

  int getNextCursorPosition(String mode, int oldSelection, String oldValud, String newValue) {
    int reverseNewSelection = 0;
    int reverseOldSelection = oldValud.length - oldSelection;
    if (mode == 'add') {
      reverseNewSelection = reverseOldSelection;
    } else if (mode == 'delete') {
      reverseNewSelection = reverseOldSelection;
      if (reverseOldSelection % 4 == 3) reverseNewSelection = reverseOldSelection + 1;
    }
    int newSelection = newValue.length - reverseNewSelection;
    if (newSelection < 0) newSelection = 0;
    return newSelection;
  }
}
