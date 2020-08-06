import 'dart:async';
import 'package:fe_sektak/session/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'RegisterationScreens/login_screen.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'Splash_Screen';
  @override
  _SplashScreen createState() => new _SplashScreen();
}

class _SplashScreen extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  SessionManager sessionManager;
  AnimationController _animationController;
  Animation<Color> _colorAnimation;
  double value = 0.0;
  double opacity = 0;
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    _colorAnimation = Tween<Color>(begin: Colors.green, end: Colors.blue)
        .animate(_animationController);
    sessionManager = new SessionManager();
    getSession();
    changeOpacity();
  }

  getSession() async {
    await sessionManager.getSessionManager();
    setState(() {});
  }

  getHomePage() {
    if (sessionManager.isLoggin()) {
      sessionManager.loadSession();
      return MainPage.id;
    } else
      return LoginScreen.id;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  changeOpacity() {
    if (value < 1.0) {
      Timer.periodic(
          Duration(seconds: 1),
          (timer) => {
                if (mounted)
                  {
                    setState(() {
//            value += 0.02;
                      value += 1.0;
                    })
                  }
              });
      Timer.periodic(
          Duration(seconds: 3),
          (timer) => {
                if (mounted)
                  {
                    setState(() {
                      opacity = 1 - opacity;
                      changeOpacity();
                    })
                  }
              });
    } else {
      opacity = 1.0;
      navigate();
    }
  }

  navigate() {
    sessionManager.sharedPreferences == null
        ? navigate()
        : Navigator.popAndPushNamed(context, getHomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: AnimatedContainer(
          alignment: Alignment.center,
          padding: EdgeInsets.only(right: 40, left: 40),
          duration: Duration(seconds: 3),
          decoration: BoxDecoration(color: Colors.black),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedOpacity(
                    opacity: opacity,
                    duration: Duration(seconds: 2),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.height / 3,
                      child: Image.asset('assets/images/road.png'),
                    ),
                  ),
                  Text(
                    'Fe Sektak',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        value < 1.0
                            ? '${(value * 100).toStringAsPrecision(3)}%'
                            : 'Welcome',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      LinearProgressIndicator(
                        value: value,
                        valueColor: _colorAnimation,
                        backgroundColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
