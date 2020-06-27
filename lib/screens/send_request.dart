import 'package:fe_sektak/models/user.dart';
import 'package:flutter/material.dart';

import 'package:fe_sektak/models/ride.dart';

class Requests extends StatelessWidget {
  static const String id = 'send_request';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Request'),
      ),
      body: Requsetss(),
    );
  }
}

class Requsetss extends StatefulWidget {
  @override
  _RequsetssState createState() => _RequsetssState();
}

class _RequsetssState extends State<Requsetss> {
  final List<Ride> _rides = [
    Ride(
        driver: User(name: 'shahed', UPhoto: 'direction'),
        endPointLatitude: 125478.0,
        startPointLatitude: 0.251458754),
    Ride(
        driver: User(name: 'shahed', UPhoto: 'direction'),
        endPointLatitude: 125478.0,
        startPointLatitude: 0.251458754),
    Ride(
        driver: User(name: 'shahed', UPhoto: 'direction'),
        endPointLatitude: 125478.0,
        startPointLatitude: 0.251458754),
    Ride(
        driver: User(name: 'shahed', UPhoto: 'direction'),
        endPointLatitude: 125478.0,
        startPointLatitude: 0.251458754),
    Ride(
        driver: User(name: 'shahed', UPhoto: 'direction'),
        endPointLatitude: 125478.0,
        startPointLatitude: 0.251458754),
    Ride(
        driver: User(name: 'shahed', UPhoto: 'direction'),
        endPointLatitude: 125478.0,
        startPointLatitude: 0.251458754),
    Ride(
        driver: User(name: 'shahed', UPhoto: 'direction'),
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _rides.map((ride) {
              return Card(
                child: Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage(ride.driver.UPhoto),
                        ),
                        Text(
                          ride.driver.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('From'),
                        // give the pointLatitiude to google map and get it's place to put it in the form as a name of city
                        Location(ride.startPointLatitude.toString()),
                        Text('To'),
                        Location(ride.endPointLatitude.toString())
                      ],
                    ),
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
                ),
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
          fontSize: 20,
          color: Colors.purple,
        ),
      ),
    );
  }
}
