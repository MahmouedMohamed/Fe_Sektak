
import 'package:fe_sektak/screens/home_screen.dart';
import 'package:fe_sektak/screens/login_screen.dart';
import 'package:fe_sektak/screens/rideCreation_screen.dart';
import 'package:fe_sektak/screens/ride_selector.dart';
import 'package:fe_sektak/screens/signup_screen.dart';
import 'package:fe_sektak/screens/splash_screen.dart';
import 'package:flutter/material.dart';

import 'package:fe_sektak/screens/requestCreation_screen.dart';
import 'package:fe_sektak/session/session_manager.dart';

import 'screens/main_screen.dart';
import 'screens/requests_screen.dart';
import 'screens/rides_screen.dart';
void main() => runApp(new FeSektak());

class FeSektak extends StatelessWidget {
  SessionManager sessionManager = new SessionManager();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fe Sektak',
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(primaryColor: Colors.blue, accentColor: Color(0xFFFEF9EB)),
      initialRoute: SplashScreen.id,
      routes: <String, WidgetBuilder>{
        MainPage.id: (context) => MainPage(),
        HomeScreen.id: (context) => HomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RideCreation.id: (context) => RideCreation(),
        RideScreen.id: (context) => RideScreen(),
        RequestScreen.id: (context) => RequestScreen(),
        RequestCreation.id: (context) => RequestCreation(),
        SignupScreen.id: (context) => SignupScreen(),
        SplashScreen.id: (context) => SplashScreen(),
        RideSelectionScreen.id: (context) => RideSelectionScreen(request: null,),
      },
//      darkTheme: ThemeData.dark(),
    );
  }
}
