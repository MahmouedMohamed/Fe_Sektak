import 'package:fe_sektak/api_callers/request_api.dart';
import 'package:fe_sektak/api_callers/ride_api.dart';
import 'package:fe_sektak/session/session_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fe_sektak/models/ride.dart';
import 'package:fe_sektak/models/request.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../main_screen.dart';
import '../show_markers_screen.dart';

class RideSelectionScreen extends StatefulWidget {
  static const String id = 'Ride_Selection';
  final Request request;
  const RideSelectionScreen({Key key, @required this.request})
      : super(key: key);

  @override
  _RideSelectionScreen createState() => _RideSelectionScreen(request);
}

class _RideSelectionScreen extends State<RideSelectionScreen> {
  Request request;
  _RideSelectionScreen(this.request);
  RideApi apiRideCaller = new RideApi();
  List<Ride> rides;
  SessionManager sessionManager = new SessionManager();
  double cost = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<List<dynamic>> getRides() async {
    List<dynamic> returnedItems = await apiRideCaller
        .getAvailableRides(requestData: {'requestId': request.requestId});
    return returnedItems;
  }

  Widget showRides() {
    return FutureBuilder<List<dynamic>>(
      future: getRides(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          rides = snapshot.data[0];
          cost = double.parse(snapshot.data[1]);
          return showBody();
        } else if (snapshot.error != null) {
          return Container(
            alignment: Alignment.center,
            child:
                Text('Error Showing Rides, Please Restart ${snapshot.error}'),
          );
        } else {
          return Center(
            child: CupertinoActivityIndicator(
              radius: 30,
              animating: true,
            ),
          );
        }
      },
    );
  }

  Widget showBody() {
    return Container(
      height: double.infinity,
      child: ListView(
        children: <Widget>[
          Container(
            child: Text('That request might cost you $cost, Hope you enjoy it',
                style: TextStyle(color: Colors.white)),
            decoration: BoxDecoration(
              color: Colors.redAccent,
            ),
            margin: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 5),
            padding: EdgeInsets.only(top: 3, bottom: 3, right: 3, left: 3),
          ),
          Column(
            children: rides.map((ride) {
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
                    backgroundImage:
                        NetworkImage(ride.driver.uPhoto.replaceAll('\\', '')),
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
                subtitle: FittedBox(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Rate : ${ride.driver.rate}',
                        style: TextStyle(color: Colors.amber),
                      ),
                      Text('Total Review : ${ride.driver.totalReview}'),
                      Text(
                          'Number Of Services : ${ride.driver.numberOfServices}'),
                    ],
                  ),
                ),
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      RaisedButton(
                          color: Colors.amber,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowMarkersScreen(
                                    first: LatLng(ride.startPointLatitude,
                                        ride.startPointLongitude),
                                    second: LatLng(ride.endPointLatitude,
                                        ride.endPointLongitude)),
                              ),
                            );
                          },
                          child: Text(
                            'Show This Ride Info on map',
                            style: TextStyle(color: Colors.black),
                          )),
                      FlatButton(
                        child: Text(
                          'Send Request',
                          style: TextStyle(color: Colors.green),
                        ),
                        onPressed: () async {
                          RequestApi apiRequestCaller = new RequestApi();
                          request.rideId = ride.rideId;
                          String status = await apiRequestCaller.sendRequest(
                              requestData: {'requestId': request.requestId},
                              rideData: {'rideId': ride.rideId});
                          if (status == 'done') {
                            Navigator.popAndPushNamed(context, MainPage.id);
                          }
                        },
                      )
                    ],
                  )
                ],
              ));
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Ride Selection'),
          leading: BackButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, MainPage.id);
            },
          ),
        ),
        body: showRides());
  }
}
