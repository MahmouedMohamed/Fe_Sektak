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
  TextEditingController name = new TextEditingController();
  TextEditingController nationalId = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController mobileNumber = new TextEditingController();
  TextEditingController carLicense = new TextEditingController();
  TextEditingController carColor = new TextEditingController();
  TextEditingController carModel = new TextEditingController();
  TextEditingController licenceId = new TextEditingController();

  UserApi apiCaller = new UserApi();
  @override
  void initState() {
    super.initState();
  }

  void onChange(bool status) {
    setState(() {
      carLicense.clear();
      carColor.clear();
      carModel.clear();
      licenceId.clear();
      hasCar = status;
    });
  }

  List<DropdownMenuItem<String>> buildDropDownMenuItems(List countries) {
    List<DropdownMenuItem<String>> list = List();
    for (String country in countries) {
      list.add(
        DropdownMenuItem(
          value: country,
          child: Text(country),
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Material(
          child: Container(
              color: Colors.redAccent,
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 30, bottom: 40),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Text('Fe Sektak',
                        style: GoogleFonts.delius(
                            color: Colors.white, fontSize: 40)),
                    textField('Full name', Colors.white, false, null, name,
                        Icons.person),
                    textField(
                        'Email', Colors.white, false, null, email, Icons.email),
                    textField('Password', Colors.white, true, null, password,
                        Icons.lock),
                    textField(
                        'Mobile Number',
                        Colors.white,
                        false,
                        TextInputType.number,
                        mobileNumber,
                        Icons.mobile_screen_share),
                    textField('National ID', Colors.white, false,
                        TextInputType.number, nationalId, Icons.credit_card),
                    CheckboxListTile(
                      title: Text(
                        'Have a Car? ',
                        style: TextStyle(
                            color: hasCar ? Colors.green[900] : Colors.white),
                      ),
                      activeColor: Colors.green,
                      checkColor: Colors.white,
                      value: hasCar,
                      onChanged: onChange,
                      secondary: Icon(Icons.directions_car,
                          color: hasCar ? Colors.green[900] : Colors.white),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    Visibility(
                      child: Column(
                        children: <Widget>[
                          textField('Licence ID', Colors.yellow, false, null,
                              licenceId, Icons.credit_card),
                          textField('Car Number', Colors.yellow, false, null,
                              carLicense, Icons.directions_car),
                          textField('Car Color', Colors.yellow, false, null,
                              carColor, Icons.color_lens),
                          textField('Car Model', Colors.yellow, false, null,
                              carModel, Icons.local_car_wash),
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
                        String status = await apiCaller.register(userData: {
                          'name': name.text,
                          'email': email.text,
                          'password': password.text,
                          'phoneNumber': mobileNumber.text,
                          'nationalId': nationalId.text,
                          'licenceId': licenceId.text,
                        }, carData: {
                          'carLicenseId': carLicense.text,
                          'carModel': carModel.text,
                          'color': carColor.text,
                        });
                        if (status == 'done') {
                          Navigator.popAndPushNamed(context, LoginScreen.id);
                        } else {
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
