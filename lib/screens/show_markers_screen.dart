import 'dart:async';
import 'package:fe_sektak/models/user_location.dart';
import 'package:fe_sektak/session/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter/cupertino.dart';

import 'main_screen.dart';

class ShowMarkersScreen extends StatefulWidget {
  static const String id = 'ShowMarkers_Screen';
  final first,second;

  const ShowMarkersScreen({Key key, this.first, this.second}) : super(key: key);
  @override
  _ShowMarkersState createState() => _ShowMarkersState(first,second);
}

class _ShowMarkersState extends State<ShowMarkersScreen> {
  final LatLng first, second;
  GoogleMap googleMap;
  UserLocation userLocation;
  Set<Marker> markers = new Set();
  SessionManager sessionManager = new SessionManager();

  _ShowMarkersState(this.first, this.second);
  @override
  void initState() {
    super.initState();
    userLocation = new UserLocation();
  }
  initMarkers() {
    markers.clear();
    for (int index = 0; index < 2; index++) {
      markers.add(new Marker(
          markerId: index == 0
              ? new MarkerId('Start Point')
              : new MarkerId('End Point'),
          position: index == 0
              ? new LatLng(first.latitude, first.longitude)
              : new LatLng(second.latitude, second.longitude),
          icon: index == 0
              ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
              : BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen),
          infoWindow: index == 0
              ? InfoWindow(title: 'Start Point')
              : InfoWindow(title: 'End Point')));
    }
  }
  Future<GoogleMap> getGoogleMap() async {
    await userLocation.getUserLocation();
    initMarkers();
    return googleMap = GoogleMap(
      initialCameraPosition: CameraPosition(
          target: LatLng(userLocation.getLatLng().latitude,
              userLocation.getLatLng().longitude),
          zoom: 18),
      markers: markers,
      myLocationEnabled: true,
      zoomGesturesEnabled: true,
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
            'Error! ${snapshot.error}',
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
          backgroundColor: Colors.black,
          leading: BackButton(
//            onPressed: () => Navigator.popAndPushNamed(context, MainPage.id),
          ),
          title: Text('Show Markers'),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              child: showGoogleMap(),
            ),
          ],
        ));
  }
}
