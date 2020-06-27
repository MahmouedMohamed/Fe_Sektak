import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  static const String id='Home_Screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);

  AnimationController _animationController;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;

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
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    Size size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;
    return Scaffold(
      body: Stack(
        children: <Widget>[menu(context), home(context)],
      ),
    );
  }

  Widget home(context) {
    return AnimatedPositioned(
        top: 0,
        bottom: 0,
        left: isCollapsed ? 0 : 0.6 * screenWidth,
        right: isCollapsed ? 0 : -0.4 * screenWidth,
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
                    'Looking for a Ride?',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(0, 0, 0, 100000),
                    ),
                  ),
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.settings,
                          color: Colors.grey,
                        ),
                        padding: EdgeInsets.only(right: 10),
                        onPressed: () {}),
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
                Wrap(
                  alignment: WrapAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/2.jpg',
                          fit: BoxFit.fill,
                          width: 150,
                          height: 150,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30, bottom: 3),
                      child: Text(
                        'Welcome, Mahmoued!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 25,
                            letterSpacing: 1),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 3),
                      child: Text(
                        'You have been involved in 4 Rides Until Now',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.blue, fontSize: 25, letterSpacing: 1),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 3),
                      child: Text(
                        'Keep it going!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 25,
                            letterSpacing: 1),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(
                                top: screenHeight / 4, bottom: 30),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: ButtonTheme(
                                child: RaisedButton(
                                  onPressed: () => {},
                                  color: Colors.lightBlue[200],
                                  splashColor: Colors.blue,
                                  focusColor: Colors.blue,
                                  highlightColor: Colors.blue,
                                  colorBrightness: Brightness.light,
                                  child: Text('Start a Ride!',
                                      style: TextStyle(
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
                            ))
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
                Colors.blueAccent,
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
//                      mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/2.jpg',
                            fit: BoxFit.fill,
                            width: 120,
                            height: 120,
                          ),
                        ),
                      ),
                      FloatingActionButton.extended(
                        label: Text('Profile'),
                        icon: Icon(
                          Icons.accessibility,
                          size: 30,
                        ),
                        splashColor: Colors.blue,
                        onPressed: () {},
                      ),
                      SizedBox(height: 10),
                      FloatingActionButton.extended(
                        label: Text('My Rides'),
                        icon: Icon(
                          Icons.directions_car,
                          size: 30,
                        ),
                        splashColor: Colors.limeAccent,
                        onPressed: () {},
                      ),
                      SizedBox(height: 10),
                      FloatingActionButton.extended(
                        label: Text(
                          'Contact Us',
                          softWrap: true,
                          style: TextStyle(letterSpacing: 1.5),
                        ),
                        icon: Icon(
                          Icons.message,
                          size: 30,
                        ),
                        splashColor: Colors.green,
                        onPressed: () {},
                      ),
                      SizedBox(height: 50),
                      FlatButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Icons.exit_to_app,
                          size: 30,
                        ),
                        label: Text(
                          'Logout',
                          style: TextStyle(color: Colors.black, fontSize: 25),
                        ),
                      ),
                      SizedBox(height: 10),
                      FlatButton.icon(
                          onPressed: () {},
                          icon: Icon(
                            Icons.warning,
                            size: 25,
                            color: Colors.red,
                          ),
                          label: Text('Report a problem.',
                              style:
                                  TextStyle(color: Colors.red, fontSize: 15))),
                    ],
                  ))),
            )),
      ),
    );
  }
}
