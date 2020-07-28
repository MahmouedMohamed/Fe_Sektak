import 'package:fe_sektak/api_callers/api_caller.dart';
import 'package:fe_sektak/api_callers/ride_api.dart';
import 'package:fe_sektak/models/ride.dart';
import 'package:fe_sektak/session/session_manager.dart';
import 'package:flutter/material.dart';

class RideScreen extends StatefulWidget {
  static const String id='Ride_Screen';
  @override
  _RideScreenState createState() => _RideScreenState();
}

class _RideScreenState extends State<RideScreen> {
  ApiCaller apiCaller = new RideApi();
  List<Ride> rides = new List<Ride>();
  SessionManager sessionManager = new SessionManager();
  getRide() async {
   rides = await apiCaller.getAll(userData: {'userId': sessionManager.getUser().id});
  }
  @override
  Widget build(BuildContext context) {
    getRide();
    print(rides);
    return Container(
      child: Column(
        children: <Widget>[
          Text('${rides}'),
          Text('${rides[0].startPointLatitude}'),
          Text('${rides[0].startPointLongitude}'),
          Text('${rides[0].endPointLatitude}'),
          Text('${rides[0].endPointLongitude}'),
          Text('${rides[1].requests[0].passenger.name}'),
        ],
      ),
    );
  }
}
