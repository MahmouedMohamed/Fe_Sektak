import 'package:fe_sektak/models/request.dart';
import 'package:fe_sektak/screens/home_screen.dart';
import 'package:fe_sektak/screens/login_screen.dart';
import 'package:fe_sektak/screens/rideCreation_screen.dart';
import 'package:fe_sektak/screens/send_request.dart';
import 'package:fe_sektak/screens/signup_screen.dart';
import 'package:fe_sektak/screens/splash_screen.dart';
import 'package:flutter/material.dart';

import 'package:fe_sektak/screens/requestCreation_screen.dart';

void main() => runApp(new FeSektak());

class FeSektak extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fe Sektak',
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(primaryColor: Colors.blue, accentColor: Color(0xFFFEF9EB)),
      initialRoute: Requests.id,
      routes: <String, WidgetBuilder>{
        HomeScreen.id: (context) => HomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RideCreation.id: (context) => RideCreation(),
        RequestCreation.id: (context) => RequestCreation(),
        SignupScreen.id: (context) => SignupScreen(),
        SplashPage.id: (context) => SplashPage(),
        Requests.id: (context) => Requests(),
      },
//      darkTheme: ThemeData.dark(),
    );
  }
}
