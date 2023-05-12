import 'package:flutter/material.dart';
import 'package:url_recognizer/common/const/ct_colors.dart';

class CTLayout extends StatelessWidget {
  final Widget body;
  final String? title;
  final Widget? titleMenu;
  final showScreenHeader = true;
  final bool safeAreaTop;
  final bool safeAreaBottom;
  final bool isLoading;
  final Widget? bottomNavigationBar;

  CTLayout({
    required this.body,
    this.title,
    this.titleMenu,
    this.safeAreaTop = true,
    this.safeAreaBottom = true,
    this.isLoading = false,
    this.bottomNavigationBar,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0, backgroundColor: CTColors.black),
      body: Stack(
        children: [
          SafeArea(
            bottom: safeAreaBottom,
            top: safeAreaTop,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: body),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}