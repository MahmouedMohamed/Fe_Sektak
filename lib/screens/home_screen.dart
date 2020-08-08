import 'package:fe_sektak/api_callers/notification_api.dart';
import 'package:fe_sektak/screens/RegisterationScreens/login_screen.dart';
import 'package:fe_sektak/screens/RequestScreens/requestCreation_screen.dart';
import 'package:fe_sektak/screens/profile_screen.dart';
import 'package:fe_sektak/session/session_manager.dart';
import 'package:fe_sektak/screens/RideScreens/rideCreation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'notification_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'Home_Screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  final Duration duration = const Duration(milliseconds: 300);
  AnimationController _animationController;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;
  SessionManager sessionManager = new SessionManager();
  int notificationCount = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: duration);
    _scaleAnimation =
        Tween<double>(begin: 1, end: 0.6).animate(_animationController);
    _menuScaleAnimation =
        Tween<double>(begin: 0, end: 1).animate(_animationController);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[menu(context), home(context)],
      ),
    );
  }
  Stream<int> refresher(Duration interval) async* {
    while (true) {
      await Future.delayed(interval);
      NotificationApi apiCaller = new NotificationApi();
      notificationCount =
      await apiCaller.getUnReadNotificationsCount(userData: {'userId' : sessionManager.getUser().id});
      yield notificationCount;
    }
  }
  Widget showBody(){
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.only(right: 20,top: 10),
        child: Stack(
          children: <Widget>[
            Icon(Icons.notifications,color: Colors.black,size: 30,), Container(
              padding: EdgeInsets.all(1),
              decoration: new BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: BoxConstraints(
                minWidth: 14,
                minHeight: 12,
              ),
              child: new Text(
                '$notificationCount',
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      onTap: (){
        Navigator.pushNamed(context, NotificationScreen.id);
      },
    );
  }
  Widget home(context) {
    return AnimatedPositioned(
        top: 0,
        bottom: 0,
        left: isCollapsed ? 0 : 0.6 * MediaQuery.of(context).size.width,
        right: isCollapsed ? 0 : -0.4 * MediaQuery.of(context).size.width,
        duration: duration,
        curve: ElasticInCurve(3),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Material(
              animationDuration: duration,
              shadowColor: Colors.black,
              borderRadius:
                  isCollapsed ? null : BorderRadius.all(Radius.circular(30)),
              elevation: isCollapsed ? 0 : 8,
              child: Container(
                  child: Wrap(children: <Widget>[
                AppBar(
                  backgroundColor: Colors.transparent,
                  centerTitle: true,
                  elevation: 0,
                  leading: InkWell(
                    child: IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Colors.black,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          if (isCollapsed)
                            _animationController.forward();
                          else
                            _animationController.reverse();
                          isCollapsed = !isCollapsed;
                        });
                      },
                    ),
                  ),
                  title: Text(
                    "Fe Sektak",
                    style: GoogleFonts.delius(color: Colors.black,fontWeight: FontWeight.bold),
                  ),
                  actions: <Widget>[
                    StreamBuilder(
                      stream: refresher(Duration(seconds: 2)),
                      initialData: notificationCount,
                      builder: (BuildContext context, snapshot) {
                        return showBody();
                      },
                    ),
                  ],
                ),
                PreferredSize(
                    child: Padding(
                      padding: EdgeInsets.only(right: 20, left: 20),
                      child: Container(
                        decoration: ShapeDecoration(
                            shape: Border(
                                bottom: BorderSide(
                                    color: Color.fromRGBO(127, 127, 127, 450),
                                    width: 1))),
                      ),
                    ),
                    preferredSize: Size.fromHeight(0)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: Image.network(
                          sessionManager.getUser().uPhoto.replaceAll('\\', ''),
                          fit: BoxFit.fill,
                          width: 150,
                          height: 150,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30, bottom: 3),
                      child: Text(
                        'Welcome, ${sessionManager.getUser().name}!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.delius(
                            color: Colors.black,
                            fontSize: 25),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 30),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: ButtonTheme(
                                child: RaisedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, RequestCreation.id);
                                  },
                                  color: Colors.lightBlue[200],
                                  splashColor: Colors.blue,
                                  focusColor: Colors.blue,
                                  highlightColor: Colors.blue,
                                  colorBrightness: Brightness.light,
                                  child: Text('Looking for a Ride?',
                                      style: GoogleFonts.delius(
                                          color: Colors.white,
                                          fontSize: 20,
                                          letterSpacing: 1.5,
                                          fontWeight: FontWeight.bold)),
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                                minWidth: 240,
                              ),
                            )),
                        Visibility(
                          child: Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 30),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: ButtonTheme(
                                  child: RaisedButton(
                                    onPressed: () => {
                                      Navigator.pushNamed(
                                          context, RideCreation.id)
                                    },
                                    color: Colors.lightBlue[200],
                                    splashColor: Colors.blue,
                                    focusColor: Colors.blue,
                                    highlightColor: Colors.blue,
                                    colorBrightness: Brightness.light,
                                    child: Text('Start a Ride!',
                                        style: GoogleFonts.delius(
                                            color: Colors.white,
                                            fontSize: 20,
                                            letterSpacing: 1.5,
                                            fontWeight: FontWeight.bold)),
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                  ),
                                  minWidth: 240,
                                ),
                              )),
                          visible: sessionManager.getUser().car != null,
                        )
                      ],
                    )
                  ],
                ),
              ]))),
        ));
  }

  Widget menu(context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _menuScaleAnimation,
        child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [
                Colors.white,
                Color.fromARGB(255, 252, 92, 125),
              ],
            )),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                          child: Image.network(
                            sessionManager.getUser().uPhoto.replaceAll('\\', ''),
                            fit: BoxFit.fill,
                            width: 120,
                            height: 120,
                          ),
                        ),
                      ),
                      RaisedButton.icon(
                        label: Text(
                          'Profile',
                          style: TextStyle(color: Colors.amber),
                        ),
                        icon: Icon(
                          Icons.accessibility,
                          size: 30,
                          color: Colors.amber,
                        ),
                        color: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        splashColor: Colors.blue,
                        onPressed: () {
                          Navigator.pushNamed(context, ProfileScreen.id);
                        },
                      ),
                      RaisedButton.icon(
                        color: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        onPressed: () {
                          sessionManager.logout();
                          Navigator.popAndPushNamed(context, LoginScreen.id);
                        },
                        icon: Icon(
                          Icons.exit_to_app,
                          size: 30,
                          color: Colors.amber,
                        ),
                        label: Text(
                          'Logout',
                          style: TextStyle(color: Colors.amber, fontSize: 18),
                        ),
                      ),
                      SizedBox(height: 10),
                      RaisedButton.icon(
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          onPressed: () {},
                          icon: Icon(
                            Icons.warning,
                            size: 25,
                            color: Colors.white,
                          ),
                          label: Text('Report a problem.',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15))),
                    ],
                  ))),
            )),
      ),
    );
  }
}
