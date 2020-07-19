import 'package:flutter/material.dart';
import 'ui/account/login_page.dart';
import 'ui/models/app_theme.dart';
import 'ui/models/global.dart';
import 'ui/pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSharedPreferences();
  // if (storedUserDataHandler.getString('token') == null ||
  //     storedUserDataHandler.getString('token') == '')
  //   homeScreen = LoginPage();
  // else {
  //   homeScreen = Home();
  // }

  homeScreen = Home();

  runApp(MaterialApp(
    title: "eDastavej",
    theme: AppTheme().getThemeData(),
    home: homeScreen,
    builder: (context, child) {
      return ScrollConfiguration(
        behavior: MyBehavior(),
        child: child,
      );
    },
    debugShowCheckedModeBanner: false,
  ));
}
