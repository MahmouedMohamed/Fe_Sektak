import 'package:fe_sektak/api_callers/api_caller.dart';
import 'package:fe_sektak/api_callers/request_api.dart';
import 'package:fe_sektak/api_callers/ride_api.dart';
import 'package:fe_sektak/session/session_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fe_sektak/models/ride.dart';
import 'package:fe_sektak/models/request.dart';
import '../main_screen.dart';

class RideSelectionScreen extends StatefulWidget {
  static const String id = 'Ride_Selection';
  final Request request;
  const RideSelectionScreen({Key key, @required this.request}) : super(key: key);

  @override
  _RideSelectionScreen createState() => _RideSelectionScreen(request);
}

class _RideSelectionScreen extends State<RideSelectionScreen> {
  Request request;
  _RideSelectionScreen(this.request);
  RideApi apiRideCaller = new RideApi();
  List<Ride> rides;
  SessionManager sessionManager = new SessionManager();
  @override
  void initState() {
    super.initState();
  }

  Future<List<Ride>> getRides() async {
    List<Ride> rides =
        await apiRideCaller.get(requestData: {'requestId': request.requestId});
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

  Widget showBody() {
    return Container(
      height: double.infinity,
      child: ListView(
        children: <Widget>[
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
                    backgroundImage: NetworkImage(ride.driver.uPhoto.replaceAll('\\', '')),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text('From'),
                          Text('${ride.startPointLatitude.toStringAsFixed(2)}'),
                          Text(
                              '${ride.startPointLongitude.toStringAsFixed(2)}'),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 6,
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
                  Column(
                    children: <Widget>[
                      Text('Rate : ${ride.driver.rate}',style: TextStyle(color: Colors.amber),),
                      Text('Total Review : ${ride.driver.totalReview}'),
                      Text('Number Of Services : ${ride.driver.numberOfServices}'),
                      FlatButton(
                        child: Text(
                          'Send Request',
                          style: TextStyle(color: Colors.green),
                        ),
                        onPressed: () async {
                          RequestApi apiRequestCaller = new RequestApi();
                          request.rideId = ride.rideId;
                          String status = await apiRequestCaller.sendRequest(
                              requestData: {
                                'requestId': request.requestId
                              },
                              rideData: {
                                'rideId': ride.rideId
                              });
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
          leading: BackButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, MainPage.id);
            },
          ),
        ),
        body: showRides());
  }
}
