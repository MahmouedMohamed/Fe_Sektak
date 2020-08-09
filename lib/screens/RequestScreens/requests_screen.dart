import 'package:fe_sektak/api_callers/request_api.dart';
import 'package:fe_sektak/models/request.dart';
import 'package:fe_sektak/session/session_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toast/toast.dart';

import '../main_screen.dart';
import 'package:fe_sektak/screens/MeetingScreens/meetTime_screen.dart';
import 'package:fe_sektak/screens/RideScreens/ride_selector.dart';

import '../show_markers_screen.dart';
import 'update_request.dart';

class RequestScreen extends StatefulWidget {
  static const String id = 'Request_Screen';
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  List<Request> requests = new List<Request>();
  SessionManager sessionManager = new SessionManager();
  RequestApi apiRequestCaller = new RequestApi();
  Future<List<Request>> getRequests() async {
    List<Request> requests = await apiRequestCaller
        .getAll(userData: {'userId': sessionManager.getUser().id});
    return requests;
  }

  Widget showRides() {
    return FutureBuilder<List<Request>>(
      future: getRequests(),
      builder: (BuildContext context, AsyncSnapshot<List<Request>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          requests = snapshot.data;
          return showBody();
        } else if (snapshot.error != null) {
          return Container(
            alignment: Alignment.center,
            child: Text(
                'Error Showing Requests, Please Restart ${snapshot.error}'),
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
          title: Text(
            'My Requests',
            style: TextStyle(color: Colors.white),
          ),
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
        padding: EdgeInsets.only(top: 5),
        decoration: BoxDecoration(color: Colors.white),
        height: double.infinity,
        child: ListView(
            children: requests.map((request) {
          return Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              margin: EdgeInsets.only(left: 5, right: 5, top: 10),
              child: ExpansionTile(
                title: FittedBox(
                  child: Row(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text('Request #${request.requestId}'),
                          ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 6,
                      ),
                    ],
                  ),
                ),
                leading: request.response
                    ? Icon(
                        Icons.check,
                        color: Colors.green,
                        size: 50,
                      )
                    : Icon(
                        Icons.access_alarm,
                        color: Colors.grey,
                        size: 50,
                      ),
                children: <Widget>[
                  RaisedButton(
                      color: Colors.amber,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(30))),
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ShowMarkersScreen(first: LatLng(request.meetPoint.latitude,request.meetPoint.longitude),
                                    second: LatLng(request.endPointLatitude,request.endPointLongitude)),
                          ),
                        );
                      },
                      child: Text('Show My Request Info on map',style: TextStyle(color: Colors.black),)
                  ),
                  request.response
                      ? Column(children: <Widget>[
                          compare(request.meetPoint.meetingTime,
                                  TimeOfDay.now())
                              ? Text(
                                  'It\'s up Now !',
                                  style: TextStyle(
                                      color: Colors.green[700], fontSize: 20),
                                )
                              : Text(
                                  'Meeting Time ${request.meetPoint.meetingTime.hour}:${request.meetPoint.meetingTime.minute}'),
                          compare(request.meetPoint.meetingTime,
                                  TimeOfDay.now())
                              ? RaisedButton(
                                  color: Colors.green,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  onPressed: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MeetTimeScreen(request: request),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Start Ride!',
                                    style: TextStyle(color: Colors.white),
                                  ))
                              : FlatButton(
                                      color: Colors.grey,
                                      child: Text(
                                        'Cancel Request',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () async {
                                        String status = await apiRequestCaller
                                            .cancel(requestData: {
                                          'requestId': request.requestId
                                        }, userData: {
                                          'userId': sessionManager.getUser().id
                                        });
                                        if (status == 'done') {
                                          setState(() {});
                                        } else {
                                          Toast.show('Error!', context);
                                        }
                                      },
                                    )
                        ])
                      : Column(
                          children: <Widget>[
                            request.rideId == 'null'
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      RaisedButton(
                                        color: Colors.black,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30))),
                                        child: Text(
                                          'Show Suitable Rides!',
                                          style: TextStyle(
                                              color: Colors.lightGreenAccent),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    RideSelectionScreen(
                                                  request: request,
                                                ),
                                              ));
                                        },
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                RaisedButton(
                                  color: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RequestUpdateScreen(
                                                request: request),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Update',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                RaisedButton(
                                  color: Colors.red,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  onPressed: () async {
                                    RequestApi apiCaller = new RequestApi();
                                    String status = await apiCaller.delete(
                                        requestData: {
                                          'requestId': request.requestId
                                        });
                                    if (status == 'done') {
                                      setState(() {});
                                    }
                                  },
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                ],
              ));
        }).toList()));
  }

  compare(TimeOfDay rideTime, TimeOfDay timeOfDay) {
    return rideTime.hour < timeOfDay.hour ||
        rideTime.hour == timeOfDay.hour && rideTime.minute < timeOfDay.minute;
  }
}
