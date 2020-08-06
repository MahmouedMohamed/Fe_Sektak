import 'dart:async';
import 'dart:math';
import 'package:fe_sektak/api_callers/ride_api.dart';
import 'package:fe_sektak/api_callers/user_api.dart';
import 'package:fe_sektak/models/ride.dart';
import 'package:fe_sektak/models/user_location.dart';
import 'package:fe_sektak/session/session_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vector_math/vector_math.dart' as math;
import '../main_screen.dart';
import '../review_screen.dart';

class RideTimeScreen extends StatefulWidget {
  static const String id = 'RideTime_Screen';
  final Ride ride;
  const RideTimeScreen({Key key, this.ride}) : super(key: key);
  @override
  _RideTimeScreenState createState() => _RideTimeScreenState(this.ride);
}

class _RideTimeScreenState extends State<RideTimeScreen> {
  final Ride ride;
  GoogleMap googleMap;
  UserLocation userLocation;
  SessionManager sessionManager = new SessionManager();
  Set<Marker> markers = new Set();
  UserApi apiUserCaller = new UserApi();

  _RideTimeScreenState(this.ride);

  @override
  void initState() {
    super.initState();
    userLocation = new UserLocation();
  }

  Future<void> sendLocation() async {
    Future.delayed(Duration(seconds: 10), () async {
      await apiUserCaller.sendUserLocation(userData: {
        'userId': sessionManager.getUser().id,
        'locationLatitude': userLocation.getLatLng().latitude,
        'locationLongitude': userLocation.getLatLng().longitude
      }, rideData: {
        'rideId': ride.rideId
      });
      sendLocation();
    });
  }

  initMarkers() {
    markers.clear();
    ride.requests.forEach((request) {
      markers.add(new Marker(
        markerId: new MarkerId(request.passenger.name),
        position:
            new LatLng(request.meetPoint.latitude, request.meetPoint.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(
            title: request.passenger.name,
            snippet: request.meetPoint.meetingTime.hour.toString() +
                ':' +
                request.meetPoint.meetingTime.minute.toString()),
      ));
    });
    for (int index = 0; index < 2; index++) {
      markers.add(new Marker(
          markerId: index == 0
              ? new MarkerId('Start Point')
              : new MarkerId('End Point'),
          position: index == 0
              ? new LatLng(ride.startPointLatitude, ride.startPointLongitude)
              : new LatLng(ride.endPointLatitude, ride.endPointLongitude),
          icon: index == 0
              ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
              : BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen),
          infoWindow: index == 0
              ? InfoWindow(title: 'Start Point')
              : InfoWindow(title: 'End Point')));
    }
  }

  double calculateDistance(LatLng startPoint, LatLng endPoint) {
    int radius = 6371; // radius of earth in Km
    double dLat = math.radians(endPoint.latitude - startPoint.latitude);
    double dLon = math.radians(endPoint.longitude - startPoint.longitude);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(math.radians(startPoint.latitude)) *
            cos(math.radians(endPoint.latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * asin(sqrt(a));
    return radius * c;
  }

  Future<Widget> rideDone() async {
    if (userLocation.getLatLng() == null) {
      await userLocation.getUserLocation();
    }
    if (markers.length == 0) {
      initMarkers();
    }
    while (calculateDistance(userLocation.getLatLng(),
                markers.elementAt(markers.length - 1).position) *
            1000 >
        20) {
      await userLocation.getUserLocation();
    }
    return AlertDialog(
      title: Text("Thank you for using the app!"),
      content: Text(
          'it seems that you are ${num.parse((calculateDistance(userLocation.getLatLng(), markers.elementAt(markers.length - 1).position) * 1000).toStringAsFixed(2))} Meter away from your destination.'),
      actions: [
        FlatButton(
            child: Text("Start Review!"),
            onPressed: () async {
              String status = await deleteRide();
              if (status == 'done') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewScreen(ride: ride),
                  ),
                );
              }
            }),
        FlatButton(
            child: Text(
              "No thanks",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () async {
              String status = await deleteRide();
              if (status == 'done') {
                Navigator.popAndPushNamed(context, MainPage.id);
              }
            })
      ],
    );
  }

  deleteRide() async {
    RideApi apiCaller = new RideApi();
    return await apiCaller.delete(rideData: {'rideId': ride.rideId});
  }

  getAcquiringWidget() {
    return FutureBuilder<Widget>(
      future: rideDone(),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return snapshot.data;
        } else if (snapshot.error != null) {
          return Container(
            alignment: Alignment.center,
            child: Text('Error ${snapshot.error}'),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

  Future<GoogleMap> getGoogleMap() async {
    Completer<GoogleMapController> _controller = Completer();
    if (userLocation.getLatLng() == null) {
      await userLocation.getUserLocation();
    }
    initMarkers();
    return googleMap = GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
          target: LatLng(userLocation.getLatLng().latitude,
              userLocation.getLatLng().longitude),
          zoom: 18),
      markers: markers,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      myLocationEnabled: true,
      zoomGesturesEnabled: true,
      tiltGesturesEnabled: true,
      mapToolbarEnabled: true,
    );
  }

  Widget showGoogleMap() {
    return FutureBuilder<GoogleMap>(
      future: getGoogleMap(),
      builder: (BuildContext context, AsyncSnapshot<GoogleMap> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          sendLocation();
          return googleMap;
        } else if (snapshot.error != null) {
          return Text(
            'Error ${snapshot.error.toString()}',
            textAlign: TextAlign.center,
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
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: BackButton(),
          title: Text('Ride ${ride.rideId}'),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              child: showGoogleMap(),
            ),
            Align(
              alignment: Alignment.center,
              child: getAcquiringWidget(),
            )
          ],
        ));
  }
}
