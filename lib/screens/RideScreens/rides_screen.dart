import 'package:fe_sektak/api_callers/api_caller.dart';
import 'package:fe_sektak/api_callers/request_api.dart';
import 'package:fe_sektak/api_callers/ride_api.dart';
import 'package:fe_sektak/models/ride.dart';
import 'package:fe_sektak/session/session_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import '../main_screen.dart';
import 'package:fe_sektak/screens/MeetingScreens/rideTime_screen.dart';

class RideScreen extends StatefulWidget {
  static const String id = 'Ride_Screen';
  @override
  _RideScreenState createState() => _RideScreenState();
}

class _RideScreenState extends State<RideScreen> {
  ApiCaller apiRideCaller = new RideApi();
  List<Ride> rides = new List<Ride>();
  SessionManager sessionManager = new SessionManager();
  ApiCaller apiRequestCaller = new RequestApi();

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
                backgroundImage: NetworkImage(sessionManager.getUser().uPhoto),
              ),
            ),
            title: ride.available
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
            subtitle: FittedBox(
              child: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text('From'),
                      Text('${ride.startPointLatitude.toStringAsFixed(2)}'),
                      Text('${ride.startPointLongitude.toStringAsFixed(2)}'),
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 7,
                  ),
                  Column(
                    children: <Widget>[
                      Text('To'),
                      Text('${ride.endPointLatitude.toStringAsFixed(2)}'),
                      Text('${ride.endPointLongitude.toStringAsFixed(2)}'),
                    ],
                  ),
                ],
              ),
            ),
            children: <Widget>[
              compare(ride.rideTime, TimeOfDay.now())
                  ? RaisedButton(
                color: Colors.transparent,
                      onPressed: () {
//                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RideTimeScreen(ride: ride),
                          ),
                        );
                      },
                      child: Text(
                        'Start the trip!',
                        style: TextStyle(color: Colors.green),
                      ),
                    )
                  : SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      'Delete Ride',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () async {
                      String status = await apiRideCaller
                          .delete(rideData: {'rideId': ride.rideId});
                      if (status == 'done') {
                        setState(() {});
                      } else {
                        Toast.show('Error', context);
                      }
                    },
                  ),
                  FlatButton(
                    child: Text(
                      'Update Ride',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () async {},
                  )
                ],
              ),
              for (int index = 0; index < ride.requests.length; index++)
                Card(
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            NetworkImage(ride.requests[index].passenger.uPhoto),
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
                          ? Text(
                              'Accepted',
                              style: TextStyle(color: Colors.green),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FlatButton(
                                  child: Text(
                                    'Delete Request',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () {
                                    apiRequestCaller.delete(rideData: {
                                      'rideId': ride.rideId
                                    }, requestData: {
                                      'requestId':
                                          ride.requests[index].requestId
                                    });
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
                                        .update(requestData: {
                                      'requestId':
                                          ride.requests[index].requestId
                                    }, rideData: {
                                      'rideId': ride.rideId
                                    });
                                    if (status == 'done') {
                                      print(status);
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
