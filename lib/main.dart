import 'package:flutter/material.dart';
import 'package:fe_sektak/screens/edit_profile.dart';
import 'package:fe_sektak/screens/notification_screen.dart';
import 'package:fe_sektak/screens/profile_screen.dart';
import 'package:fe_sektak/screens/RegisterationScreens/login_screen.dart';
import 'package:fe_sektak/screens/RegisterationScreens/signup_screen.dart';
import 'package:fe_sektak/screens/home_screen.dart';
import 'package:fe_sektak/screens/RideScreens/rideCreation_screen.dart';
import 'package:fe_sektak/screens/splash_screen.dart';
import 'package:fe_sektak/screens/RequestScreens/requestCreation_screen.dart';
import 'package:fe_sektak/session/session_manager.dart';
import 'package:fe_sektak/screens/main_screen.dart';
import 'package:fe_sektak/screens/RequestScreens/requests_screen.dart';
import 'package:fe_sektak/screens/MeetingScreens/rideTime_screen.dart';
import 'package:fe_sektak/screens/RideScreens/rides_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(new FeSektak());

class FeSektak extends StatelessWidget {
  SessionManager sessionManager = new SessionManager();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fe Sektak',
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(primaryColor: Colors.blue, accentColor: Color(0xFFFEF9EB),textTheme: GoogleFonts.deliusTextTheme()),
      initialRoute: SplashScreen.id,
      routes: <String, WidgetBuilder>{
        SplashScreen.id: (context) => SplashScreen(),
        MainPage.id: (context) => MainPage(),
        HomeScreen.id: (context) => HomeScreen(),
        SignupScreen.id: (context) => SignupScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
        EditProfileScreen.id: (context) => EditProfileScreen(),
        RideCreation.id: (context) => RideCreation(),
        RideScreen.id: (context) => RideScreen(),
        RideTimeScreen.id: (context) => RideTimeScreen(),
        RequestScreen.id: (context) => RequestScreen(),
        RequestCreation.id: (context) => RequestCreation(),
        NotificationScreen.id: (context) => NotificationScreen(),
      },
    );
  }
}
