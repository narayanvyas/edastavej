import 'dart:io';
import 'package:edatavejapp/ui/account/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/global.dart';
import 'package:url_launcher/url_launcher.dart';

File _image;
bool isLoadingImage = false;

class NavigationDrawer extends StatefulWidget {
  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  void getCurrentProfileImage() async {
    // if (profileUrl != '' && profileUrl != null) {
    //   setState(() {
    //     isLoadingImage = true;
    //   });
    //   File file = await DefaultCacheManager().getSingleFile(profileUrl);
    //   if (this.mounted) {
    //     setState(() {
    //       _image = file;
    //       isLoadingImage = false;
    //     });
    //   }
    // }
  }

  @override
  void initState() {
    super.initState();
    getCurrentProfileImage();
  }

  Widget getUserAccountDrawer() {
    return Stack(
      children: <Widget>[
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          currentAccountPicture: isLoadingImage
              ? Container()
              : _image != null
                  ? Center(
                      child: Stack(
                        alignment: Alignment(1.5, -1.3),
                        children: <Widget>[
                          Container(
                            child: Material(
                                elevation: 10.0,
                                shape: CircleBorder(),
                                clipBehavior: Clip.hardEdge,
                                color: Colors.transparent,
                                child: Image.file(
                                  _image,
                                  fit: BoxFit.fill,
                                  width: 120,
                                  height: 120,
                                )),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Material(
                          elevation: 10.0,
                          shape: CircleBorder(),
                          clipBehavior: Clip.hardEdge,
                          color: Colors.transparent,
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.only(top: 5),
                            child: Image.asset(
                              'assets/img/no-profile.png',
                              width: 120,
                              height: 120,
                            ),
                          )),
                    ),
          accountEmail:
              Text(currentUser.email == null ? "" : currentUser.email),
          accountName: Text(name == null ? "" : name),
        ),
        Positioned(
          bottom: -40,
          left: -50,
          child: Container(
              height: 120.0,
              width: 120.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(120.0),
                  color: Colors.white.withOpacity(0.03))),
        ),
        Positioned(
          top: -70,
          right: -50,
          child: Container(
              height: 200.0,
              width: 200.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(150.0),
                  color: Colors.white.withOpacity(0.05))),
        ),
      ],
    );
  }

  Widget buildUserDrawer() {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: ListView(
          padding: const EdgeInsets.all(0.0),
          children: <Widget>[
            getUserAccountDrawer(),
            // firebaseUser == null
            //     ? Container()
            //     : firebaseUser.isEmailVerified ? Container() : getVerifyEmail(),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListTile(
                title: getNavTitle("My Profile"),
                leading: getNavIcon(Icons.person, Colors.blue),
                onTap: () {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (BuildContext context) => Profile()));
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListTile(
                title: getNavTitle("Contact Us"),
                leading: getNavIcon(Icons.alternate_email, Colors.lightBlue),
                onTap: () async {
                  var url =
                      'mailto:ahussain421@gmail.com?subject=UFit Support&';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListTile(
                title: getNavTitle("Logout"),
                leading: getNavIcon(Icons.exit_to_app, Colors.red),
                onTap: () {
                  signOutUser();
                },
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListTile(
                title: getNavTitle("Rate on Google Play"),
                leading: getNavIcon(FontAwesomeIcons.googlePlay, Colors.blue),
                onTap: () async {
                  await launchPlayStoreUrl();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListTile(
                title: getNavTitle("Share App"),
                leading: getNavIcon(Icons.share, Colors.green),
                onTap: () async {
                  await shareApp();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildUserDrawer();
  }

  Widget getNavTitle(String navName) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: Text(
        navName,
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }

  Widget getNavIcon(IconData icon, Color color) {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      child: Icon(
        icon,
        size: 25.0,
        color: color,
      ),
    );
  }

  Widget getVerifyEmail() {
    return RaisedButton(
      child: Text(
        "Verify Email",
        style: TextStyle(color: Colors.white),
      ),
      color: Colors.red,
      onPressed: () {
        _verifyEmailDialog(this.context,
            "We have sent you a verification link to your email. Kindly click on that link to verify your email before continue using the app.");
      },
    );
  }

  shareApp() async {
    // await FlutterShare.share(
    //     title: 'UFit Fitness App',
    //     text:
    //         'Get the best Fitness advice customized specially for you, Download UFit Fitness App Now.',
    //     linkUrl:
    //         'https://play.google.com/store/apps/details?id=com.webdevfusion.ufit_trainer',
    //     chooserTitle: 'Share UFit Share');
  }

  launchPlayStoreUrl() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.webdevfusion.ufit_trainer';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future signOutUser() async {
    userBox.deleteFromDisk();
    currentUser = null;
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  }
}

void _verifyEmailDialog(BuildContext context, String msg) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Text("Verify Email"),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(27.0),
            child: Container(
              child: Text(msg),
            ),
          ),
          Row(
            children: <Widget>[
              SimpleDialogOption(
                child: RaisedButton(
                  color: Colors.blue,
                  child: Text(
                    "Resend Email",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    // await firebaseUser.sendEmailVerification();
                    // Navigator.of(context).pop();
                  },
                ),
              ),
              SimpleDialogOption(
                child: RaisedButton(
                  child: Text(
                    "Ok",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          )
        ],
      );
    },
  );
}
