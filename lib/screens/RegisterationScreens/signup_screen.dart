import 'package:fe_sektak/screens/RegisterationScreens/login_screen.dart';
import 'package:fe_sektak/api_callers/user_api.dart';
import 'package:fe_sektak/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toast/toast.dart';

class SignupScreen extends StatefulWidget {
  static const String id = 'SignUp_Screen';
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool hasCar = false;
  List<TextEditingController> controllers = new List<TextEditingController>();
  List<String> errors = new List<String>();
  UserApi apiCaller = new UserApi();

  @override
  void initState() {
    super.initState();
    List.generate(9, (index) => errors.add(null));
    List.generate(9, (index) => controllers.add(new TextEditingController()));
  }

  void onChange(bool status) {
    setState(() {
      controllers[5].clear();
      controllers[6].clear();
      controllers[7].clear();
      controllers[8].clear();
      hasCar = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Material(
          child: Container(
              color: Colors.indigo,
              alignment: Alignment.topCenter,
              height: double.infinity,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 30, bottom: 40),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Text('Fe Sektak',
                        style: GoogleFonts.delius(
                            color: Colors.white, fontSize: 40)),
                    textField('Full name', Colors.white, false, null,
                        controllers[0], errors[0], Icons.person),
                    textField(
                      'Email',
                      Colors.white,
                      false,
                      null,
                      controllers[1],
                      errors[1],
                      Icons.email,
                    ),
                    textField('Password', Colors.white, true, null,
                        controllers[2], errors[2], Icons.lock),
                    textField(
                        'Mobile Number',
                        Colors.white,
                        false,
                        TextInputType.number,
                        controllers[4],
                        errors[4],
                        Icons.mobile_screen_share),
                    textField(
                        'National ID',
                        Colors.white,
                        false,
                        TextInputType.number,
                        controllers[3],
                        errors[3],
                        Icons.credit_card),
                    CheckboxListTile(
                      title: Text(
                        'Have a Car? ',
                        style: TextStyle(
                            color: hasCar ? Colors.green : Colors.white),
                      ),
                      activeColor: Colors.green,
                      checkColor: Colors.white,
                      value: hasCar,
                      onChanged: onChange,
                      secondary: Icon(Icons.directions_car,
                          color: hasCar ? Colors.green : Colors.white),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    Visibility(
                      child: Column(
                        children: <Widget>[
                          textField('Licence ID', Colors.yellow, false, TextInputType.number,
                              controllers[8], errors[8], Icons.credit_card),
                          textField(
                              'Car License ID',
                              Colors.yellow,
                              false,
                              null,
                              controllers[5],
                              errors[5],
                              Icons.directions_car),
                          textField('Car Color', Colors.yellow, false, null,
                              controllers[7], errors[7], Icons.color_lens),
                          textField('Car Model', Colors.yellow, false, null,
                              controllers[6], errors[6], Icons.local_car_wash),
                        ],
                      ),
                      visible: hasCar ? true : false,
                    ),
                    RaisedButton(
                      color: Colors.amber,
                      elevation: 2.0,
                      padding: EdgeInsets.only(
                          top: 7, bottom: 7, right: 20, left: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Text('Signup!',
                          style: GoogleFonts.delius(
                              fontSize: 22, color: Colors.white)),
                      onPressed: () async {
                        var status = await apiCaller.register(userData: {
                          'name': controllers[0].text,
                          'email': controllers[1].text,
                          'password': controllers[2].text,
                          'phoneNumber': controllers[4].text,
                          'nationalId': controllers[3].text,
                          'licenceId': controllers[8].text,
                        }, carData: {
                          'carLicenseId': controllers[5].text,
                          'carModel': controllers[6].text,
                          'color': controllers[7].text,
                        });
                        if (status == 'done') {
                          Navigator.popAndPushNamed(context, LoginScreen.id);
                        } else {
                          setState(() {
                            for (int index = 0; index < errors.length; index++)
                              errors[index] = status[index];
                          });
                          Toast.show('Enter a valid data', context);
                        }
                      },
                    )
                  ],
                ),
              ))),
    );
  }
}
