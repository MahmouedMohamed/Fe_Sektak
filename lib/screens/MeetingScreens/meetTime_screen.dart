import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:fe_sektak/api_callers/request_api.dart';
import 'package:fe_sektak/api_callers/user_api.dart';
import 'package:fe_sektak/models/request.dart';
import 'package:fe_sektak/models/user.dart';
import 'package:fe_sektak/models/user_location.dart';
import 'package:fe_sektak/session/session_manager.dart';
import 'package:fe_sektak/widgets/marker_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pusher_websocket_flutter/pusher.dart';
import 'package:toast/toast.dart';
import 'package:vector_math/vector_math.dart' as math;
import '../main_screen.dart';
import '../review_screen.dart';

class MeetTimeScreen extends StatefulWidget {
  static const String id = 'RideTime_Screen';
  final Request request;

  const MeetTimeScreen({Key key, this.request}) : super(key: key);
  @override
  _MeetTimeScreenState createState() => _MeetTimeScreenState(this.request);
}

class _MeetTimeScreenState extends State<MeetTimeScreen> {
  final Request request;
  GoogleMap googleMap;
  UserLocation userLocation;
  SessionManager sessionManager = new SessionManager();
  Set<Marker> markers = new Set();
  Channel channel;
  Completer<GoogleMapController> controller;
  String userId;
  bool inRide = false;
  _MeetTimeScreenState(this.request);

  @override
  void initState() {
    super.initState();
    userLocation = new UserLocation();
    initMarker();
    initPusher();
  }

  Future<void> initPusher() async {
    try {
      await Pusher.init("0e4e0f059789236002f4", PusherOptions(cluster: "eu"))
          .catchError((error) {});
    } on PlatformException catch (e) {
      Toast.show(e.message,context);
    }
    Pusher.connect(onConnectionStateChange: (value) {}, onError: (error) {});
    channel = await Pusher.subscribe('ride.${request.rideId}');
    getDriverLocation();
  }

  getDriverLocation() async {
    channel.bind('App\\Events\\LocationsSent', (event) {
      var convertDataToJson = jsonDecode(event.toJson()['data']);
      userId = convertDataToJson['currentUser'];
      setState(() {
        Marker marker = markers.elementAt(0).copyWith(
            positionParam: new LatLng(
                double.parse(convertDataToJson['locationLatitude']),
                double.parse(convertDataToJson['locationLongitude'])));
        markers.clear();
        markers.add(marker);
      });
    });
  }

  initMarker() async {
    MarkerIcon icon = new MarkerIcon();
    await icon.createMarkerImageFromAsset();
    markers.add(new Marker(
        markerId: new MarkerId('Driver'),
        icon: icon.getIcon(),
        infoWindow: InfoWindow(title: 'Driver')));
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

  Future<Widget> waitingForDriver() async {
    if (userLocation.getLatLng() == null) {
      await userLocation.getUserLocation();
    }
    while (calculateDistance(userLocation.getLatLng(),
                markers.elementAt(markers.length - 1).position) *
            1000 >
        20) {
      Future.delayed(Duration(seconds: 5));
      await userLocation.getUserLocation();
    }
    UserApi apiCaller = new UserApi();
    User user = await apiCaller.getById(userData: {'userId': userId});
    Pusher.unsubscribe('ride.${request.rideId}');
    return AlertDialog(
      title: Text("Did you got him?"),
      content: Text(
          'it seems that you are ${num.parse((calculateDistance(userLocation.getLatLng(), markers.elementAt(markers.length - 1).position) * 1000).toStringAsFixed(2))} Meter away from the Driver.\n'
          'Car Model : ${user.car.carModel} \n'
          'Car Color : ${user.car.color} \n'
          'Car License : ${user.car.carLicenseId}\n'
          'Phone Number : ${user.phoneNumber}'),
      actions: [
        FlatButton(
            child: Text("Press here if you saw him!"),
            onPressed: () async {
                setState(() {
                  inRide = true;
                  Marker marker = markers.elementAt(0).copyWith(
                      iconParam: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueGreen),
                      positionParam: new LatLng(
                          request.endPointLatitude, request.endPointLongitude));
                  markers.clear();
                  markers.add(marker);
                });
            }),
        FlatButton(
          child: Text(
            "Press here if he didn't come!",
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {
            ///Report for spam
          },
        )
      ],
    );
  }

  Future<Widget> rideDone() async {
    if (userLocation.getLatLng() == null) {
      await userLocation.getUserLocation();
    }
    while (calculateDistance(userLocation.getLatLng(),
                LatLng(request.endPointLatitude, request.endPointLongitude)) *
            1000 >
        30) {
      await userLocation.getUserLocation();
    }
    return AlertDialog(
      title: Text("Thanks for using our App"),
      content: Text(
          'it seems that you are ${num.parse((calculateDistance(userLocation.getLatLng(), markers.elementAt(markers.length - 1).position) * 1000).toStringAsFixed(2))} Meter away from the Destination.\n'),
      actions: [
        FlatButton(
            child: Text("Start Review!"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReviewScreen(driverId: userId),
                ),
              );
            }),
        FlatButton(
          child: Text(
            "No thanks",
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {
            Navigator.popAndPushNamed(context, MainPage.id);
          },
        )
      ],
    );
  }

  getAcquiringWidget() {
    return FutureBuilder<Widget>(
      future: inRide ? rideDone() : waitingForDriver(),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return snapshot.data;
        } else if (snapshot.error != null) {
          getAcquiringWidget();
          return Container(
            alignment: Alignment.center,
//            child: Text('Error ${snapshot.error}'),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

  Future<GoogleMap> getGoogleMap() async {
    controller = Completer();
    if (userLocation.getLatLng() == null) {
      await userLocation.getUserLocation();
    }
    return googleMap = GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
          target: LatLng(userLocation.getLatLng().latitude,
              userLocation.getLatLng().longitude),
          zoom: 18),
      markers: markers,
      onMapCreated: (GoogleMapController controller) {
        this.controller.complete(controller);
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
          title: Text('Ride ${request.rideId}'),
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
