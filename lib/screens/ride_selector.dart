import 'package:fe_sektak/api_callers/api_caller.dart';
import 'package:fe_sektak/api_callers/ride_api.dart';
import 'package:fe_sektak/models/user.dart';
import 'package:flutter/material.dart';

import 'package:fe_sektak/models/ride.dart';
import 'package:fe_sektak/models/request.dart';

class RideSelector extends StatelessWidget {
  static const String id = 'ride_selector';
  final Request request;

  const RideSelector({Key key,@required this.request}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Request'),
      ),
      body: RideSelectionScreen(request),
//    body: test(request),
    );
  }
}
class test extends StatelessWidget {
  Request request;
  test(this.request);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text('${request.passenger}'),
          Text('${request.startPointLatitude}'),
          Text('${request.startPointLongitude}'),
          Text('${request.endPointLatitude}'),
          Text('${request.endPointLongitude}'),
          Text('${request.meetPoint}'),
        ],
      ),
    );
  }
}

class RideSelectionScreen extends StatefulWidget {
  Request request;
  RideSelectionScreen(this.request);

  @override
  _RideSelectionScreen createState() => _RideSelectionScreen(request);
}

class _RideSelectionScreen extends State<RideSelectionScreen> {
  Request request;
  _RideSelectionScreen(this.request);
  ApiCaller apiCaller = new RideApi();
  List<Ride> rides;
  initializeRides() async {
    rides = await apiCaller.getAll(
      requestData: {
        'startPointLatitude' : request.startPointLatitude,
        'startPointLongitude' : request.startPointLongitude,
        'endPointLatitude' : request.endPointLatitude,
        'endPointLongitude' : request.endPointLongitude,
        'numberOfNeededSeats' : request.numberOfNeededSeats,
      }
    );
  }
  @override
  void initState() {
    super.initState();
  }
  final List<Ride> _rides = [
    Ride(
        driver: User(name: 'shahed', uPhoto: 'direction'),
        endPointLatitude: 125478.0,
        startPointLatitude: 0.251458754),
    Ride(
        driver: User(name: 'shahed', uPhoto: 'direction'),
        endPointLatitude: 125478.0,
        startPointLatitude: 0.251458754),
    Ride(
        driver: User(name: 'shahed', uPhoto: 'direction'),
        endPointLatitude: 125478.0,
        startPointLatitude: 0.251458754),
    Ride(
        driver: User(name: 'shahed', uPhoto: 'direction'),
        endPointLatitude: 125478.0,
        startPointLatitude: 0.251458754),
    Ride(
        driver: User(name: 'shahed', uPhoto: 'direction'),
        endPointLatitude: 125478.0,
        startPointLatitude: 0.251458754),
    Ride(
        driver: User(name: 'shahed', uPhoto: 'direction'),
        endPointLatitude: 125478.0,
        startPointLatitude: 0.251458754),
    Ride(
        driver: User(name: 'shahed', uPhoto: 'direction'),
        endPointLatitude: 125478.0,
        startPointLatitude: 0.251458754),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
        child: ListView(
          children: <Widget>[
            Column(
              children: _rides.map((ride) {
                return Card(
                  child: ExpansionTile(
                    leading: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 44,
                      minHeight: 44,
                      maxWidth: 84,
                      maxHeight: 84,
                    ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage(ride.driver.uPhoto),
                      ),
                    ),
                    title: Text(
                      ride.driver.name,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle:
                    FittedBox(
                      child:
                      Row(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text('From'),
                              Location(ride.startPointLatitude.toString()),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text('To'),
                              Location(ride.endPointLatitude.toString()),
                            ],
                          ),
                          // give the pointLatitiude to google map and get it's place to put it in the form as a name of city

                        ],
                      ),
                    ),
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              FlatButton(
                                child: Text('Ignore'),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              FlatButton(
                                child: Text('Send'),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  )
                );
              }).toList(),
            ),
          ],
        ),
    );
  }
}

class Location extends StatelessWidget {
  final String location;

  Location(@required this.location);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.purple,
          width: 2,
        ),
      ),
      padding: EdgeInsets.all(10),
      child: Text(
        location,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.purple,
        ),
      ),
    );
  }
}
