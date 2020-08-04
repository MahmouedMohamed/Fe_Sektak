import 'package:fe_sektak/api_callers/api_caller.dart';
import 'package:fe_sektak/api_callers/request_api.dart';
import 'package:fe_sektak/models/request.dart';
import 'package:fe_sektak/session/session_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main_screen.dart';
import 'package:fe_sektak/screens/MeetingScreens/meetTime_screen.dart';
import 'package:fe_sektak/screens/RideScreens/ride_selector.dart';

class RequestScreen extends StatefulWidget {
  static const String id = 'Request_Screen';
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  List<Request> requests = new List<Request>();
  SessionManager sessionManager = new SessionManager();
  ApiCaller apiRequestCaller = new RequestApi();
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
          title: Text('My Requests'),
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
              color: Colors.amber,
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              margin: EdgeInsets.only(left: 5, right: 5, top: 10),
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
                        NetworkImage(sessionManager.getUser().uPhoto),
                  ),
                ),
                title: request.response
                    ? Text(
                        'Accepted',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Text(
                        'Waiting for answer',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                subtitle: FittedBox(
                  child: Row(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text('Meeting point', style: TextStyle(fontSize: 26)),
                          Text(
                              '${request.meetPoint.latitude.toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 26)),
                          Text(
                              '${request.meetPoint.longitude.toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 26)),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 6,
                      ),
                      Column(
                        children: <Widget>[
                          Text('Destination', style: TextStyle(fontSize: 26)),
                          Text('${request.endPointLatitude.toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 26)),
                          Text(
                              '${request.endPointLongitude.toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 26)),
                        ],
                      ),
                    ],
                  ),
                ),
                children: <Widget>[
                  request.response
                      ? Column(children: <Widget>[
                          Text('Ride Id: ${request.rideId}'),
                          compare(request.meetPoint.meetingTime,
                                  TimeOfDay.now())
                              ? RaisedButton(
                                  onPressed: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MeetTimeScreen(request: request),
                                      ),
                                    );
                                  }, child: Text('Start'))
                              : Text('No action available')
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
                                  color: Colors.black,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  onPressed: () {},
                                  child: Text(
                                    'Update',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                                RaisedButton(
                                  color: Colors.black,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  onPressed: () async {
                                    ApiCaller apiCaller = new RequestApi();
                                    String status = await apiCaller.delete(requestData: {'requestId' : request.requestId});
                                    if(status == 'done'){
                                      setState(() {});
                                    }
                                  },
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
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
