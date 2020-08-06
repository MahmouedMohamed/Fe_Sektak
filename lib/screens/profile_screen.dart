import 'dart:io';
import 'package:fe_sektak/api_callers/user_api.dart';
import 'package:fe_sektak/models/user.dart';
import 'package:fe_sektak/session/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

import 'RegisterationScreens/login_screen.dart';
import 'edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'Profile_Screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  SessionManager sessionManager = new SessionManager();
  File image;
  Future<File> pickImageFromGallery(ImageSource source) {
    return ImagePicker.pickImage(source: source);
  }

  uploadImage(ImageSource source) async {
    image = await pickImageFromGallery(source);
    UserApi apiCaller = new UserApi();
    String status = await apiCaller.updateProfilePicture(
        userData: {'image': image, 'userId': sessionManager.getUser().id});
    if ('done' == status) {
      User user = await apiCaller
          .getById(userData: {'userId': sessionManager.getUser().id});
      sessionManager.logout();
      sessionManager.createSession(user);
      sessionManager.loadSession();
      setState(() {});
    } else {
      Toast.show('Error!', context);
    }
  }

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
        body: SingleChildScrollView(
            child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            colorFilter: ColorFilter.mode(Colors.blue, BlendMode.darken),
            fit: BoxFit.cover,
          )),
          child: Padding(
            padding: EdgeInsets.only(top: 20, bottom: 10),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        sessionManager.getUser().uPhoto.replaceAll('\\', '')),
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
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  padding:
                      EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 5),
                  margin:
                      EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  child: Column(
                    children: <Widget>[
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Personal Info',
                            style: TextStyle(fontSize: 22),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Text.rich(
                        TextSpan(text: 'Phone Number: ', children: [
                          TextSpan(
                              text: '${sessionManager.getUser().phoneNumber}',
                              style: TextStyle(color: Colors.blue[800]))
                        ]),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Text.rich(
                        TextSpan(text: 'Rate: ', children: [
                          TextSpan(
                              text: '${sessionManager.getUser().rate}',
                              style: TextStyle(color: Colors.blue[800]))
                        ]),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Text.rich(
                        TextSpan(text: 'Total Review: ', children: [
                          TextSpan(
                              text: '${sessionManager.getUser().totalReview}',
                              style: TextStyle(color: Colors.blue[800]))
                        ]),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Text.rich(
                        TextSpan(text: 'Services you made: ', children: [
                          TextSpan(
                              text:
                                  '${sessionManager.getUser().numberOfServices}\n',
                              style: TextStyle(color: Colors.blue[800]),
                              children: [
                                sessionManager.getUser().numberOfServices == 0
                                    ? TextSpan(
                                        text:
                                            'Only ${sessionManager.getUser().numberOfServices} Services?\nWe are waiting more from you!',
                                        style: TextStyle(
                                            color: Colors.redAccent[700]))
                                    : TextSpan(
                                        text: 'What a society Lover!',
                                        style:
                                            TextStyle(color: Colors.green[800]))
                              ])
                        ]),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  padding:
                      EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 5),
                  margin:
                      EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  child: Column(
                    children: <Widget>[
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Car Info',
                            style: TextStyle(fontSize: 22),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Text.rich(
                        TextSpan(text: 'Car Model: ', children: [
                          TextSpan(
                              text: sessionManager.getUser().car == null
                                  ? 'N/A'
                                  : '${sessionManager.getUser().car.carModel}',
                              style: TextStyle(color: Colors.blue[800]))
                        ]),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Text.rich(
                        TextSpan(text: 'Car Color: ', children: [
                          TextSpan(
                              text: sessionManager.getUser().car == null
                                  ? 'N/A'
                                  : '${sessionManager.getUser().car.color}',
                              style: TextStyle(color: Colors.blue[800]))
                        ]),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Text.rich(
                        TextSpan(text: 'Car License ID: ', children: [
                          TextSpan(
                              text: sessionManager.getUser().car == null
                                  ? 'N/A'
                                  : '${sessionManager.getUser().car.carLicenseId}',
                              style: TextStyle(color: Colors.blue[800]))
                        ]),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Text.rich(
                        TextSpan(text: 'License ID: ', children: [
                          TextSpan(
                              text: sessionManager.getUser().car == null
                                  ? 'N/A'
                                  : '${sessionManager.getUser().car.licenseId}',
                              style: TextStyle(color: Colors.blue[800]))
                        ]),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
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
                    UserApi apiCaller = new UserApi();
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
        )));
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
                child: RaisedButton(
                  elevation: 0.0,
                  onPressed: () async {
                    await uploadImage(ImageSource.gallery);
                  },
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
