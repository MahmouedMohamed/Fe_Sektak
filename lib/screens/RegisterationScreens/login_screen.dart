import 'package:fe_sektak/api_callers/user_api.dart';
import 'package:fe_sektak/models/user.dart';
import 'package:fe_sektak/screens/RegisterationScreens/signup_screen.dart';
import 'package:fe_sektak/session/session_manager.dart';
import 'package:fe_sektak/widgets/text_field.dart';
import 'package:flutter/material.dart';
import '../main_screen.dart';
import 'package:google_fonts/google_fonts.dart';
class LoginScreen extends StatefulWidget {
  static const String id = 'Login_Screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  UserApi apiCaller = new UserApi();
  SessionManager sessionManager = new SessionManager();
  String error='';
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Material(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.white, Colors.grey],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter)),
            width: double.infinity,
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/road.png'),
                        ),
                      ),
                    )),
                Text('Fe Sektak',
                    style: GoogleFonts.delius(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      wordSpacing: 1.5,
                      letterSpacing: 1.5,
                      fontSize: 40,
                    )),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                  child: Column(
                    children: [
                      textField('Email', Colors.green, false, null, email,null,
                          Icons.person,  ''),
                      SizedBox(
                        height: 10,
                      ),
                      textField('Password', Colors.green, true, null, password,null,
                          Icons.lock, ''),
                      Text('$error',style: TextStyle(color: Colors.red)),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ButtonTheme(
                              minWidth: MediaQuery.of(context).size.width / 3,
                              child: RaisedButton(
                                child: Text(
                                  'Login',
                                  style: GoogleFonts.delius(fontSize: 16),
                                ),
                                color: Colors.greenAccent,
                                splashColor: Colors.blue,
                                colorBrightness: Brightness.light,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onPressed: () async {
                                  dynamic user = await apiCaller.login(userData: {
                                    'email': email.text,
                                    'password': password.text
                                  });
                                  if (user['type'] == 'User') {
                                    sessionManager.createSession(user['data']);
                                    Navigator.popAndPushNamed(
                                        context, MainPage.id);
                                  }
                                  else{
                                    setState(() {
                                      error = user['data'];
                                    });
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 25),
                              child: Text(
                                'Forgot password?',
                                style: GoogleFonts.delius(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                            )
                          ]),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Don\'t have Account? ',
                                style: GoogleFonts.delius(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              GestureDetector(
                                child: Text(
                                  'Join Us Now!',
                                  style: GoogleFonts.delius(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.greenAccent,
                                    fontSize: 18,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(context, SignupScreen.id);
                                },
                              ),
                            ],
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
