import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:toast/toast.dart';
import 'login_screen.dart';

class SplashPage extends StatefulWidget {
  static const String id='splash_Screen';
  @override
  Splash createState() => new Splash();
}

class Splash extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: LoginScreen(),
      title: new Text('Fe Sektak',
          style: new TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 60.0,
            color: Colors.red.shade400,
            shadows: [Shadow(color: Colors.black, offset: Offset(0, 2))],
          )),
      image: new Image.asset('assets/images/road.png'),
      imageBackground: AssetImage('assets/images/1.jpg'),
      photoSize: 100.0,
      onClick: () => Toast.show('Just a Sec', context,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.BOTTOM,
          backgroundColor: Colors.purpleAccent),
      loaderColor: Colors.white,
      loadingText: Text(
        'Loading',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
