import 'package:flutter/material.dart';

class AppTheme {
  AppTheme() {
    getThemeData();
  }
  getThemeData() {
    return ThemeData(
        primaryColor: Color(0xFFE72744),
        appBarTheme: AppBarTheme(
          color: Colors.deepPurple[900],
          elevation: 1,
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFFE72744),
          height: 42.0,
          disabledColor: Colors.red[300],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          textTheme: ButtonTextTheme.primary,
        ));
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
