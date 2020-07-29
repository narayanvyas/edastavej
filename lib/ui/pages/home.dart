import 'package:edatavejapp/ui/admin/add_users.dart';
import 'package:edatavejapp/ui/models/global.dart';
import 'package:edatavejapp/ui/models/user_model.dart';
import '../account/login_page.dart';
import '../utils/splash_screen.dart';
import 'package:flutter/material.dart';
import '../utils/drawer.dart';
import 'all_services.dart';
import 'services.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  refresh() => setState(() {});

  @override
  void initState() {
    super.initState();
    currentUser = User(
        email: userBox.get('email'),
        accessToken: userBox.get('access_token'),
        isAdmin: userBox.get('isAdmin'));
  }

  @override
  Widget build(BuildContext context) {
    return showSplashScreen
        ? SplashScreen(
            notifyParent: refresh,
          )
        : Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text('eDastavej'),
              centerTitle: true,
            ),
            drawer: NavigationDrawer(),
            body: Container(
              child: GridView.count(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                crossAxisCount: 2,
                scrollDirection: Axis.vertical,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 10 / 9,
                children: buildDashboard(),
              ),
            ),
          );
  }

  dynamic buildDashboard() {
    return [
      GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => AllServices()));
          },
          child: generateGridItem('All Services', Icons.filter, Colors.red)),
      GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => Services()));
          },
          child: generateGridItem('Stamp', Icons.filter, Colors.green)),
      GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => Services()));
          },
          child: generateGridItem(
              'Rent Agreement', Icons.check, Colors.deepOrange)),
      GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => Services()));
          },
          child: generateGridItem(
              'Jan Seva Kendra', Icons.people, Theme.of(context).primaryColor)),
      GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => Services()));
          },
          child: generateGridItem('Loan', Icons.attach_money, Colors.pink)),
      GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => AddUsers()));
          },
          child: generateGridItem('Add Users', Icons.add, Colors.blue)),
    ];
  }

  Widget generateGridItem(String title, IconData icon, Color color) {
    return Card(
        elevation: 12.0,
        margin: EdgeInsets.zero,
        color: color,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          child: Stack(children: <Widget>[
            Positioned(
                child: Icon(
              Icons.arrow_forward,
              size: 80,
              color: Colors.white.withOpacity(0.1),
            )),
            Positioned(
              top: -5,
              right: -5,
              child: Container(
                height: 60.0,
                width: 60.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60.0),
                    color: Colors.white.withOpacity(0.1)),
              ),
            ),
            Positioned(
              top: 11,
              right: 11,
              child: Icon(
                icon,
                color: Colors.white,
                size: 30.0,
              ),
            ),
            Positioned(
              left: 15,
              top: 85,
              child: Container(
                width: 120,
                child: Text(title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 19.0,
                    )),
              ),
            )
          ]),
        ));
  }
}
