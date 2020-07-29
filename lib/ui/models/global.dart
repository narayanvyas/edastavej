import 'dart:io';
import 'package:dio/dio.dart';
import 'package:edatavejapp/ui/models/config.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'user_model.dart';

//Variables
var homeScreen;
bool loadingIndicator = false;
BuildContext scaffoldContext;
File profileImage;
Pattern pattern =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
RegExp regex = RegExp(pattern);
String name, email;

User currentUser = User();
Box userBox;

BaseOptions options = BaseOptions(
  baseUrl: apiBaseUrl,
  connectTimeout: 5000,
  receiveTimeout: 3000,
);
Dio dio = Dio(options);

String logoBase64 = "";

getFirstAndLastName(String name) {
  List<String> nameList = name.split(" ");
  String firstName = '', lastName = '';
  nameList.removeWhere((element) => element.length == 0);
  if (nameList.length == 1) {
    firstName = name;
    lastName = '';
  } else if (nameList.length == 2) {
    firstName = nameList[0];
    lastName = nameList[1];
  } else {
    firstName = nameList[0];
    for (int i = 1; i < nameList.length - 1; i++) {
      firstName = "$firstName " "${nameList[i]}";
    }
    lastName = nameList[nameList.length - 1];
  }
  return {'firstName': firstName, 'lastName': lastName};
}

//Methods
displaySnackBar(String msg, GlobalKey<ScaffoldState> _scaffoldKey,
    [Color color = Colors.black87]) {
  final snackBar = SnackBar(
    content: Text(msg),
    backgroundColor: color,
    duration: Duration(milliseconds: 1500),
  );
  _scaffoldKey.currentState.showSnackBar(snackBar);
}

shareText(
    String title, String text, String linkUrl, String chooserTitle) async {
  // await FlutterShare.share(
  //     title: title, text: text, linkUrl: linkUrl, chooserTitle: chooserTitle);
}

String getTimeStamp() {
  var currentTime = DateTime.now();
  String timeStamp =
      "${currentTime.day}${currentTime.month}${currentTime.year}${currentTime.hour}${currentTime.minute}${currentTime.second}${currentTime.microsecond}";
  return timeStamp;
}

// Validators
String validateName(String value) {
  if (value.length < 3)
    return "Name must be of more than 2 charater";
  else
    return null;
}

String validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value))
    return "Please Enter Valid Email Address";
  else
    return null;
}

String validatePassword(String value) {
  if (value.length < 8)
    return "Password must be 8 characters long";
  else
    return null;
}

String validateProductTitle(String value) {
  if (value.length < 3)
    return "Product title must be of more than 2 charater";
  else
    return null;
}

String validateMobile(String value) {
  if (value.length != 10)
    return "Please Enter Valid Mobile Number";
  else
    return null;
}

void validateNameLength(BuildContext context,
    GlobalKey<ScaffoldState> _scaffoldKey, String message) {
  displaySnackBar(message, _scaffoldKey, Colors.brown);
}

// Payment Credentials

// PayTM
const PAYMENT_URL =
    "https://us-central1-famous-new.cloudfunctions.net/customFunctions/payment";

// Square
String chargeServerHost = "https://famusapp.herokuapp.com";
String chargeUrl = "$chargeServerHost/chargeForCookie";
// For Real Square Implementation, you need to do backend code in NodeJS and upload it on a
// backend server. Currently we are using Herokuapp.com as a backend server.

// UPI better than PayTM, no transaction charges.

const String squareApplicationId = "sandbox-sq0idb-d9uMOtHp1zsvbATA3Klz1Q";
const String squareLocationId = "3PG8RGDQP94ZV";

// PayPal
String domain = "https://api.sandbox.paypal.com"; // for sandbox mode
//  String domain = "https://api.paypal.com"; // for production mode

String clientId =
    'ASz1QcsBHrQ-wwwKv6xi75TVZ1R9AoA_GEOgrzNzyYC8wrmdWk5hQDmcYlpm1B7bZUvMQkN9vz2PWSXa';
String secret =
    'EAODNt2zOHYFvZigMV6ap-tI45cv1ZGPzGzfBs2nlbvY83P_MiSBjXEzrhxmHtNzCgsYL2hoY6GBYTWE';
