import 'package:fe_sektak/screens/home_screen.dart';
import 'package:fe_sektak/screens/signup_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  static const String id ='Login_Screen';
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
              colors: [Colors.white, Colors.lightBlueAccent, Colors.blue],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
            width: double.infinity,
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(20),
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/road.png'),
                        ),
                      ),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 0.0, bottom: 40),
                      child: Text(
                        'Fe Sektak',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white30,
                          shadows: [
                            Shadow(color: Colors.black, offset: Offset(0, 2))
                          ],
                          fontSize: 30,
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  decoration: BoxDecoration(color: Colors.transparent),
                  child: Column(
                    children: [
                      Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          child: TextField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              icon: Icon(
                                Icons.person,
                                color: Colors.pinkAccent,
                              ),
                              labelText: 'User Name:',
                            ),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          child: TextField(
                            obscureText: true,
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                              icon: Icon(
                                Icons.lock,
                                color: Colors.pinkAccent,
                              ),
                              labelText: 'Password :',
                            ),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ButtonTheme(
                              minWidth: 130,
                              child: RaisedButton(
                                child: Text('Login'),
                                color: Colors.greenAccent,
                                splashColor: Colors.blue,
                                colorBrightness: Brightness.light,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, HomeScreen.id);
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 25),
                              child: Text(
                                'Forgot password?',
                                style: TextStyle(
                                  fontSize: 13,
                                  shadows: [
                                    Shadow(
                                        color: Colors.black,
                                        offset: Offset(0, 1))
                                  ],
                                ),
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
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                'Join Us Now!',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.greenAccent,
                                  fontSize: 15,
                                ),
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
