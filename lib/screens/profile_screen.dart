import 'package:fe_sektak/api_callers/api_caller.dart';
import 'package:fe_sektak/api_callers/user_api.dart';
import 'package:fe_sektak/session/session_manager.dart';
import 'package:flutter/material.dart';

import 'RegisterationScreens/login_screen.dart';
import 'edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'Profile_Screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  SessionManager sessionManager = new SessionManager();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile',
            style: TextStyle(
                fontSize: 27, fontWeight: FontWeight.w400, color: Colors.amber),
          ),
          leading: BackButton(),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          )),
          child: Padding(
            padding: EdgeInsets.only(top: 40, bottom: 10),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  child: CircleAvatar(
                    backgroundImage:
                        NetworkImage(sessionManager.getUser().uPhoto),
                    minRadius: 40,
                    maxRadius: 60,
                    backgroundColor: Colors.white.withOpacity(0.5),
                  ),
                  onTap: () {
                    onImagePressed(context);
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '${sessionManager.getUser().name.toUpperCase()}',
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.amber,
                      fontSize: 30,
                      letterSpacing: 1.5),
                ),
                SizedBox(
                  height: 20,
                ),
                Text('Phone Number : ${sessionManager.getUser().phoneNumber}',
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.white,
                        fontSize: 18)),
                Text('Rate : ${sessionManager.getUser().rate}',
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.white,
                        fontSize: 18)),
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white.withOpacity(0.3),
                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: Column(
                    children: <Widget>[
                      Text(
                          'Car Model : ${sessionManager.getUser().car.carModel}',
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.black,
                              fontSize: 18,
                              height: 1.5)),
                      Text('Car Color : ${sessionManager.getUser().car.color}',
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.black,
                              fontSize: 18,
                              height: 1.5)),
                      Text(
                          'Car License ID : ${sessionManager.getUser().car.carLicenseId}',
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.black,
                              fontSize: 18,
                              height: 1.5)),
                      Text(
                          'License ID : ${sessionManager.getUser().car.licenseId}',
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.black,
                              fontSize: 18,
                              height: 1.5)),
                    ],
                  ),
                ),
                RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  color: Colors.blueAccent,
                  onPressed: () {
                    Navigator.pushNamed(context, EditProfileScreen.id);
                  },
                  icon: Icon(
                    Icons.mode_edit,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Update Profile',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  color: Colors.red,
                  onPressed: () async {
                    ApiCaller apiCaller = new UserApi();
                    String status = await apiCaller.delete(
                        userData: {'userId': sessionManager.getUser().id});
                    if (status == 'done') {
                      Navigator.pushNamed(context, LoginScreen.id);
                    }
                  },
                  icon: Icon(
                    Icons.report_problem,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Delete Your Account',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void onImagePressed(context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ButtonTheme(
                minWidth: MediaQuery.of(context).size.width / 2,
                buttonColor: Colors.transparent,
//                shape: Border(bottom: BorderSide(width: 1)),
                child: RaisedButton(
                  elevation: 0.0,
                  onPressed: () {},
                  child: Text('Show profile picture'),
                ),
              ),
              Divider(
                height: 1,
                color: Colors.black.withOpacity(0.5),
                indent: 10,
                endIndent: 10,
              ),
              ButtonTheme(
                minWidth: MediaQuery.of(context).size.width / 2,
                buttonColor: Colors.transparent,
//                shape: Border(bottom: BorderSide(width: 1)),
                child: RaisedButton(
                  elevation: 0.0,
                  onPressed: () {},
                  child: Text('Change profile picture'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
