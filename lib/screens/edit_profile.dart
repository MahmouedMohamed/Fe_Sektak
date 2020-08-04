import 'package:fe_sektak/api_callers/api_caller.dart';
import 'package:fe_sektak/api_callers/user_api.dart';
import 'package:fe_sektak/models/user.dart';
import 'package:fe_sektak/session/session_manager.dart';
import 'package:fe_sektak/widgets/text_field.dart';
import 'package:flutter/material.dart';

import 'RegisterationScreens/login_screen.dart';
import 'main_screen.dart';

class EditProfileScreen extends StatefulWidget {
  static const String id = 'Edit_Profile_Screen';

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  SessionManager sessionManager = new SessionManager();
  TextEditingController name = new TextEditingController();
  TextEditingController phoneNumber = new TextEditingController();
  TextEditingController carModel = new TextEditingController();
  TextEditingController carColor = new TextEditingController();
  TextEditingController carLicenseId = new TextEditingController();
  TextEditingController licenseId = new TextEditingController();
  TextEditingController password = new TextEditingController();

  @override
  void initState() {
    super.initState();
    name.text = sessionManager.getUser().name;
    phoneNumber.text = sessionManager.getUser().phoneNumber;
    carModel.text = sessionManager.getUser().car.carModel;
    carColor.text = sessionManager.getUser().car.color;
    carLicenseId.text = sessionManager.getUser().car.carLicenseId;
    licenseId.text = sessionManager.getUser().car.licenseId;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Edit Profile',
              style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w400,
                  color: Colors.amber),
            ),
            leading: BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            )),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 40, bottom: 10),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  textField('Name', Colors.amber, false, null, name),
                  textField(
                      'Phone Number', Colors.amber, false, null, phoneNumber),
                  textField('Car Model', Colors.amber, false, null, carModel),
                  textField('Car License ID', Colors.amber, false, null,
                      carLicenseId),
                  textField('Car Color', Colors.amber, false, null, carColor),
                  textField('Lincese ID', Colors.amber, false, null, licenseId),
                  textField('Password', Colors.amber, true, null, password,
                      null, 'Enter Your Password if No change'),
                  RaisedButton.icon(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    color: Colors.blueAccent,
                    onPressed: () async {
                      ApiCaller apiCaller = new UserApi();
                      String status = await apiCaller.update(userData: {
                        'userId': sessionManager.getUser().id,
                        'name': name.text,
                        'password': password.text,
                        'phoneNumber': phoneNumber.text,
                        'carModel': carModel.text,
                        'carColor': carColor.text,
                        'licenseId': licenseId.text,
                        'carLicenseId': carLicenseId.text,
                      });
                      if(status=='done'){
                        User user = await apiCaller.getById(Data: {'userId' : sessionManager.getUser().id});
                        if(user!=null){
                          sessionManager.logout();
                          sessionManager.createSession(user);
                          sessionManager.loadSession();
                          Navigator.popAndPushNamed(context, MainPage.id);
                        }
                      }},
                    icon: Icon(
                      Icons.mode_edit,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Update',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
