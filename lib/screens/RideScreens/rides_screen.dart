import 'package:fe_sektak/api_callers/request_api.dart';
import 'package:fe_sektak/api_callers/ride_api.dart';
import 'package:fe_sektak/models/ride.dart';
import 'package:fe_sektak/session/session_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toast/toast.dart';
import '../main_screen.dart';
import 'package:fe_sektak/screens/MeetingScreens/rideTime_screen.dart';

import '../show_markers_screen.dart';
import 'update_ride.dart';

class RideScreen extends StatefulWidget {
  static const String id = 'Ride_Screen';
  @override
  _RideScreenState createState() => _RideScreenState();
}

class _RideScreenState extends State<RideScreen> {
  RideApi apiRideCaller = new RideApi();
  List<Ride> rides = new List<Ride>();
  SessionManager sessionManager = new SessionManager();
  RequestApi apiRequestCaller = new RequestApi();

  Future<List<Ride>> getRides() async {
    List<Ride> rides = await apiRideCaller
        .getAll(userData: {'userId': sessionManager.getUser().id});
    return rides;
  }

  Widget showRides() {
    return FutureBuilder<List<Ride>>(
      future: getRides(),
      builder: (BuildContext context, AsyncSnapshot<List<Ride>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          rides = snapshot.data;
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('My Rides'),
          leading: BackButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, MainPage.id);
            },
          ),
        ),
        body: showRides());
  }

  Widget showBody() {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 5),
      decoration: BoxDecoration(color: Colors.white),
      height: double.infinity,
      child: ListView(
        children: rides.map((ride) {
          return Card(
              color: Colors.white,
              elevation: 5.0,
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
                    backgroundImage: NetworkImage(
                        sessionManager.getUser().uPhoto.replaceAll('\\', '')),
                  ),
                ),
                title: Text('Ride #${ride.rideId}'),
                subtitle: ride.available
                    ? Text(
                        'Available ${ride.rideTime.hour}:${ride.rideTime.minute}',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Text(
                        'Not Available',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                children: <Widget>[
                  RaisedButton(
                      color: Colors.amber,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
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
                        'Show My Ride Info on map',
                        style: TextStyle(color: Colors.black),
                      )),
                  compare(ride.rideTime, TimeOfDay.now())
                      ? RaisedButton(
                          color: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RideTimeScreen(ride: ride),
                              ),
                            );
                          },
                          child: Text(
                            'Start the trip!',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: Text(
                          'Delete Ride',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          String status = await apiRideCaller
                              .cancel(rideData: {'rideId': ride.rideId});
                          if (status == 'done') {
                            setState(() {});
                          } else {
                            Toast.show('Error', context);
                          }
                        },
                      ),
                      ride.requests.length == 0
                          ? RaisedButton(
                              color: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              child: Text(
                                'Update Ride',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RideUpdateScreen(ride: ride),
                                  ),
                                );
                              },
                            )
                          : SizedBox()
                    ],
                  ),
                  for (int index = 0; index < ride.requests.length; index++)
                    Card(
                      child: Column(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(ride
                                .requests[index].passenger.uPhoto
                                .replaceAll('\\', '')),
                          ),
                          Text('${ride.requests[index].passenger.name}'),
                          Text('Rate : ${ride.requests[index].passenger.rate}'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Meet point: '),
                              Text(
                                  '${ride.requests[index].meetPoint.latitude.toStringAsFixed(2)}'),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 25,
                              ),
                              Text(
                                  '${ride.requests[index].meetPoint.longitude.toStringAsFixed(2)}'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('End Point: '),
                              Text(
                                  '${ride.requests[index].endPointLatitude.toStringAsFixed(2)}'),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 25,
                              ),
                              Text(
                                  '${ride.requests[index].endPointLongitude.toStringAsFixed(2)}'),
                            ],
                          ),
                          Text('Meeting time: '
                              '${ride.requests[index].meetPoint.meetingTime.hour}'
                              ':'
                              '${ride.requests[index].meetPoint.meetingTime.minute}'),
                          Text(
                              'Needed seats: ${ride.requests[index].numberOfNeededSeats}'),
                          ride.requests[index].response == true
                              ? Column(
                                  children: <Widget>[
                                    Text(
                                      'Accepted',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                    !compare(ride.rideTime, TimeOfDay.now())
                                        ? FlatButton(
                                            color: Colors.grey,
                                            child: Text(
                                              'Cancel Request',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onPressed: () async {
                                              String status =
                                                  await apiRequestCaller
                                                      .cancel(requestData: {
                                                'requestId': ride
                                                    .requests[index].requestId
                                              }, userData: {
                                                'userId':
                                                    sessionManager.getUser().id
                                              });
                                              if (status == 'done') {
                                                setState(() {});
                                              } else {
                                                Toast.show('Error!', context);
                                              }
                                            },
                                          )
                                        : SizedBox(),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    FlatButton(
                                      child: Text(
                                        'Delete Request',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () async {
                                        String status = await apiRequestCaller
                                            .reject(requestData: {
                                          'requestId':
                                              ride.requests[index].requestId
                                        });
                                        if (status == 'done') {
                                          setState(() {});
                                        } else {
                                          Toast.show('Error!', context);
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    FlatButton(
                                      child: Text(
                                        'Accept Request',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                      onPressed: () async {
                                        String status = await apiRequestCaller
                                            .acceptRequest(requestData: {
                                          'requestId':
                                              ride.requests[index].requestId
                                        }, rideData: {
                                          'rideId': ride.rideId
                                        });
                                        if (status == 'done') {
                                          setState(() {});
                                        } else {
                                          Toast.show('Error!', context);
                                        }
                                      },
                                    )
                                  ],
                                ),
                          SizedBox(
                            height: 4,
                          ),
                        ],
                      ),
                    )
                ],
              ));
        }).toList(),
      ),
    );
  }

  compare(TimeOfDay rideTime, TimeOfDay timeOfDay) {
    return rideTime.hour < timeOfDay.hour ||
        rideTime.hour == timeOfDay.hour && rideTime.minute < timeOfDay.minute;
  }
}
