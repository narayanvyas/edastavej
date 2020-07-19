import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import '../account/login_page.dart';

class SplashScreen extends StatefulWidget {
  final Function() notifyParent;
  SplashScreen({this.notifyParent});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool animate = false;
  startTimer() {
    Future.delayed(Duration(microseconds: 1), () {
      setState(() {
        animate = true;
      });
    });
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        showSplashScreen = false;
      });
      widget.notifyParent();
    });
  }

  @override
  void initState() {
    super.initState();
    animate = false;
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.red, Colors.pink])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedContainer(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(300)),
                duration: Duration(seconds: 3),
                width: animate ? 400 : 200,
                height: animate ? 400 : 200,
                child: Center(
                  child: FlareActor("assets/flare/splash_logo.flr",
                      alignment: Alignment.center,
                      fit: BoxFit.cover,
                      animation: "idle"),
                )),
            Container(
              margin: const EdgeInsets.only(top: 100),
              child: Text(
                'eDastavej',
                style: TextStyle(fontSize: 35, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
