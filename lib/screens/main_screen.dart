import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'requests_screen.dart';
import 'rides_screen.dart';

class MainPage extends StatefulWidget {
  static const String id = 'Main_Page';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Widget> screens = [RideScreen(),HomeScreen(), RequestScreen()];
  TabController controller = new TabController(length: 3, vsync: DrawerControllerState(),initialIndex: 1);
  int index = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: TabBar(
          labelColor: Colors.amber,
          unselectedLabelColor: Colors.black.withOpacity(0.4),
          tabs: [
            Tab(
              icon: Icon(
                Icons.directions_car,
                color: index==0? Colors.amber: Colors.black,
              ),
              text: 'Rides',
            ),
            Tab(
              icon: Icon(
                Icons.home,
                color: index==1? Colors.amber: Colors.black,
              ),
              text: 'Home',
            ),
            Tab(
                icon: Icon(
              Icons.label,
              color: index==2? Colors.amber: Colors.black,
            ),
            text: 'Requests',
            ),
          ],
          onTap: (value) {
            print(value);
            setState(() {
              index = value;
            });
          },
          controller: controller,
        ),
    );
  }
}
