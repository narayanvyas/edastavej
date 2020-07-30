import 'package:flutter/material.dart';
import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../models/user_model.dart';
import '../pages/home.dart';
import 'package:hive/hive.dart';
import '../utils/splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/global.dart';
import 'package:dio/dio.dart';

bool showSplashScreen = true;

String currentDate;
bool isLoginUi = true,
    _isPasswordResetPage = false,
    loadingIndicator = false,
    _obscureTextSignup = true,
    _obscureTextLogin = true;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  TextEditingController passwordResetEmailController = TextEditingController();
  TextEditingController signupEmailController = TextEditingController();
  TextEditingController signupNameController = TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();
  final TextEditingController signupDobController = TextEditingController();
  DateTime currentBackPressTime;
  var dateFormatter = DateFormat('dd-MM-yyyy');
  refresh() => setState(() {});

  void initState() {
    super.initState();
  }

  loginUser(String email, String password) async {
    // Map<String, dynamic> userData = {
    //   'username': 'admin@edastavej.com',
    //   'password': 'edast@vej#2220',
    //   'grant_type': 'password'
    // };
    Map<String, dynamic> userData = {
      'username': email,
      'password': password,
      'grant_type': 'password'
    };
    try {
      Response response = await dio.post("/token",
          options: Options(contentType: Headers.formUrlEncodedContentType),
          data: userData);

      User tmpUser = User(
          email: email,
          accessToken: 'Bearer ' + response.data['access_token'],
          isAdmin: false);

      if (!userBox.isOpen) userBox = await Hive.openBox('userBox');
      userBox.put('email', tmpUser.email);
      userBox.put('access_token', tmpUser.accessToken);
      userBox.put('isAdmin', tmpUser.isAdmin);
      setState(() => currentUser = tmpUser);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) => Home()));
    } catch (e) {
      displaySnackBar(
          'Invalid Username or Password, Please Try Again', _scaffoldKey);
    }
  }

  Future createUser(String email, String password, Map name) async {}

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime) > Duration(seconds: 2)) {
          currentBackPressTime = now;
          return Future.value(false);
        }
        setState(() {
          currentBackPressTime = now;
        });
        await AwesomeDialog(
            context: context,
            dialogType: DialogType.INFO,
            useRootNavigator: true,
            animType: AnimType.BOTTOMSLIDE,
            body: Center(
                child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: Text(
                    'Exit MyShopee App?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  'Are you sure you want to exit the MyShopee App?',
                ),
              ],
            )),
            btnCancel: Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: RaisedButton(
                color: Colors.red,
                child: Text(
                  "No",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            btnOk: Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: RaisedButton(
                child: Text(
                  "Yes",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    currentBackPressTime = now;
                  });
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  return Future.value(false);
                },
              ),
            )).show();
        return Future.value(false);
      },
      child: showSplashScreen
          ? SplashScreen(
              notifyParent: refresh,
            )
          : Scaffold(
              resizeToAvoidBottomPadding: false,
              backgroundColor: Theme.of(context).primaryColor,
              key: _scaffoldKey,
              body: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: isLoginUi
                    ? _isPasswordResetPage
                        ? getForgotPasswordUi()
                        : getLoginUi()
                    : getSignupUi(),
              ),
            ),
    );
  }

  Widget getLoginUi() {
    return Container(
      width: double.infinity,
      height: 500,
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                Container(
                  color: Theme.of(context).primaryColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 40),
                            Text(
                              "Log In",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w500),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Text(
                                "Welcome Back",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                            SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60))),
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 60),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[200]))),
                                child: TextFormField(
                                  controller: loginEmailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Icon(
                                          Icons.mail_outline,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      hintText: 'Email ',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[200]))),
                                child: TextFormField(
                                  controller: loginPasswordController,
                                  obscureText: _obscureTextLogin,
                                  decoration: InputDecoration(
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Icon(
                                        Icons.lock,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    hintText: 'Password',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                    suffixIcon: GestureDetector(
                                      onTap: _toggleLogin,
                                      child: Icon(
                                        Icons.remove_red_eye,
                                        size: 20.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 80),
                        InkWell(
                          onTap: () async {},
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: 60),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 45,
                          child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: loadingIndicator
                                  ? CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white))
                                  : Text(
                                      'Login',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                              disabledColor: Colors.red[100],
                              onPressed: loadingIndicator
                                  ? null
                                  : () async {
                                      if (!regex
                                          .hasMatch(loginEmailController.text))
                                        displaySnackBar(
                                            'Please Enter Valid Email Address',
                                            _scaffoldKey);
                                      else if (loginPasswordController
                                              .text.length <
                                          8)
                                        displaySnackBar(
                                            'Password Length Must Be Minimum 8 Characters',
                                            _scaffoldKey);
                                      else
                                        await loginUser(
                                            loginEmailController.text,
                                            loginPasswordController.text);
                                    }),
                        ),
                        SizedBox(height: 50),
                        InkWell(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              isLoginUi = false;
                            });
                          },
                          child: Text(
                            'Didn\'t have an account ? Sign Up here ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getSignupUi() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 80),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Sign Up",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10),
                Text(
                  "Hello There...",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60))),
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 60,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey[200]))),
                          child: TextFormField(
                            controller: signupNameController,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Icon(
                                    Icons.person_outline,
                                    color: Colors.grey,
                                  ),
                                ),
                                hintText: 'Name',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey[200]))),
                          child: TextFormField(
                            controller: signupEmailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Icon(Icons.mail_outline,
                                      color: Colors.grey),
                                ),
                                hintText: 'Email',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey[200]))),
                          child: TextFormField(
                            controller: signupPasswordController,
                            obscureText: _obscureTextSignup,
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.lock,
                                  color: Colors.grey,
                                ),
                              ),
                              hintText: 'Password',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              suffixIcon: GestureDetector(
                                onTap: _toggleSignup,
                                child: Icon(
                                  Icons.remove_red_eye,
                                  size: 20.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 60),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 45,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: loadingIndicator
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white))
                            : Text(
                                'Signup',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                        disabledColor: Colors.red[100],
                        onPressed: loadingIndicator
                            ? null
                            : () async {
                                FocusScope.of(context).unfocus();
                                if (signupNameController.text.length < 2)
                                  displaySnackBar(
                                      "Please Enter Valid Name", _scaffoldKey);
                                else if (!regex
                                    .hasMatch(signupEmailController.text))
                                  displaySnackBar("Please Enter Valid Email ID",
                                      _scaffoldKey);
                                else if (signupPasswordController.text.length <
                                    8)
                                  displaySnackBar("Please Enter Valid Password",
                                      _scaffoldKey);
                                else {
                                  setState(() {
                                    loadingIndicator = true;
                                  });
                                  var name = getFirstAndLastName(
                                      signupNameController.text);
                                  await createUser(signupEmailController.text,
                                      signupPasswordController.text, name);
                                  setState(() {
                                    loadingIndicator = false;
                                  });
                                }
                              }),
                  ),
                  SizedBox(height: 50),
                  InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        isLoginUi = true;
                      });
                    },
                    child: Text(
                      'Already have an account ? Log In here ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget getForgotPasswordUi() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned(
          bottom: 0,
          right: 0,
          child: Image.asset(
            "assets/login_bottom.png",
            width: MediaQuery.of(context).size.width * 0.4,
          ),
        ),
        Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            children: <Widget>[
              Center(
                child: Text(
                  'RESET PASSWORD',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Image.asset(
                "assets/login.png",
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                width: MediaQuery.of(context).size.width * 0.8,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(29),
                ),
                child: TextFormField(
                  controller: passwordResetEmailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.mail_outline,
                      color: Theme.of(context).primaryColor,
                    ),
                    hintText: "Email Address",
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 45,
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: loadingIndicator
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white))
                        : Text(
                            'Reset Password',
                            style: TextStyle(color: Colors.white),
                          ),
                    disabledColor: Colors.deepPurple[800],
                    onPressed: loadingIndicator
                        ? null
                        : () async {
                            FocusScope.of(context).unfocus();
                            if (!regex
                                .hasMatch(passwordResetEmailController.text))
                              displaySnackBar(
                                  "Please Enter Valid Email ID", _scaffoldKey);
                            else {
                              setState(() {
                                loadingIndicator = true;
                              });
                            }
                          }),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 40, bottom: 20),
                child: InkWell(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      _isPasswordResetPage = false;
                      isLoginUi = true;
                    });
                  },
                  child: Text(
                    'Login Now',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Image.asset(
            "assets/main_top.png",
            width: MediaQuery.of(context).size.width * 0.35,
          ),
        ),
      ],
    );
  }
}
