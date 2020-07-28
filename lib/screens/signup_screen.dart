import 'package:fe_sektak/screens/login_screen.dart';
import 'package:fe_sektak/api_callers/api_caller.dart';
import 'package:fe_sektak/api_callers/user_api.dart';
import 'package:fe_sektak/widgets/text_field.dart';
import 'package:flutter/material.dart';
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

  ApiCaller apiCaller = new UserApi();
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
          child: SingleChildScrollView(
              child: Container(
        color: Colors.white,
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(top: 30, bottom: 20),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            Image.asset(
              'assets/images/road.png',
              alignment: Alignment.topCenter,
              fit: BoxFit.scaleDown,
              scale: 2.5,
            ),
            textField(
                'Full name', Icons.person, Colors.blue, false, null, name),
            textField('Email', Icons.email, Colors.blue, false, null, email),
            textField(
                'Password', Icons.lock, Colors.blue, true, null, password),
            textField('Mobile Number', Icons.mobile_screen_share, Colors.blue,
                false, TextInputType.number, mobileNumber),
            textField('National ID', Icons.mobile_screen_share, Colors.blue,
                false, TextInputType.number, nationalId),
            CheckboxListTile(
              title: Text('Have a Car? '),
              value: hasCar,
              onChanged: onChange,
              secondary: const Icon(Icons.directions_car),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            Visibility(
              child: Column(
                children: <Widget>[
                  textField('Licence ID', Icons.directions_car, Colors.blue,
                      false, null, licenceId),
                  textField('Car Number', Icons.directions_car, Colors.blue,
                      false, null, carLicense),
                  textField('Car Color', Icons.color_lens, Colors.blue, false,
                      null, carColor),
                  textField('Car Model', Icons.local_car_wash, Colors.blue,
                      false, null, carModel),
                ],
              ),
              visible: hasCar ? true : false,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Click Here To upload Your National ID'),
              ],
            ),
            RaisedButton(
              onPressed: () async {
                String status = await apiCaller.create(userData: {
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
                  Toast.show('Enter a valid data',context);
                }
              },
              child: Text('Signup'),
            )
          ],
        ),
      ))),
    );
  }
}
