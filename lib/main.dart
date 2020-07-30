import './ui/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'ui/account/login_page.dart';
import 'ui/utils/app_theme.dart';
import 'ui/models/global.dart';
import 'ui/pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter(UserAdapter());
  userBox = await Hive.openBox('userBox');
  if (userBox.get('access_token') == null || userBox.get('access_token') == '')
    homeScreen = LoginPage();
  else
    homeScreen = Home();

  // Initialize Dio

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
