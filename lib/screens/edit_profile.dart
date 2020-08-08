import 'package:fe_sektak/api_callers/user_api.dart';
import 'package:fe_sektak/models/user.dart';
import 'package:fe_sektak/session/session_manager.dart';
import 'package:fe_sektak/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'main_screen.dart';

class EditProfileScreen extends StatefulWidget {
  static const String id = 'Edit_Profile_Screen';

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  SessionManager sessionManager = new SessionManager();
  List<TextEditingController> controllers = new List<TextEditingController>();
  List<String> errors = new List<String>();
  @override
  void initState() {
    super.initState();
    List.generate(7, (index) => errors.add(null));
    List.generate(7, (index) => controllers.add(new TextEditingController()));
    controllers[0].text = sessionManager.getUser().name;
    controllers[1].text = sessionManager.getUser().phoneNumber;
    if (sessionManager.getUser().car != null) {
      controllers[2].text = sessionManager.getUser().car.carModel;
      controllers[3].text = sessionManager.getUser().car.color;
      controllers[4].text = sessionManager.getUser().car.carLicenseId;
      controllers[5].text = sessionManager.getUser().car.licenseId;
    }
    controllers[6] = new TextEditingController();
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
            decoration: BoxDecoration(color: Colors.grey[800]),
            height: double.infinity,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  textField('Name', Colors.white, false, null, controllers[0],
                      errors[0]),
                  textField('Phone Number', Colors.white, false, null,
                      controllers[1], errors[1]),
                  textField('Car Model', Colors.white, false, null,
                      controllers[2], errors[2]),
                  textField('Car License ID', Colors.white, false, null,
                      controllers[4], errors[4]),
                  textField('Car Color', Colors.white, false, null,
                      controllers[3], errors[3]),
                  textField('Lincese ID', Colors.white, false, null,
                      controllers[5], errors[5]),
                  textField('Password', Colors.white, true, null, controllers[6],
                      errors[6], null, 'Enter Your Password if No change'),
                  RaisedButton.icon(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    color: Colors.blueAccent,
                    onPressed: () async {
                      UserApi apiCaller = new UserApi();
                      dynamic status = await apiCaller.update(userData: {
                        'userId': sessionManager.getUser().id,
                        'name': controllers[0].text,
                        'password': controllers[6].text,
                        'phoneNumber': controllers[1].text,
                        'carModel': controllers[2].text,
                        'carColor': controllers[3].text,
                        'licenseId': controllers[5].text,
                        'carLicenseId': controllers[4].text,
                      });
                      if (status.toString() == 'done') {
                        User user = await apiCaller.getById(
                            userData: {'userId': sessionManager.getUser().id});
                        if (user != null) {
                          sessionManager.logout();
                          sessionManager.createSession(user);
                          sessionManager.loadSession();
                          Navigator.popAndPushNamed(context, MainPage.id);
                        }
                      } else {
                        setState(() {
                          for (int index = 0; index < errors.length; index++)
                            errors[index] = status[index];
                        });
                      }
                    },
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
