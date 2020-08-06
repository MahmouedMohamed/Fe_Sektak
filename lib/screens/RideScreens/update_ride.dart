import 'package:fe_sektak/api_callers/ride_api.dart';
import 'package:fe_sektak/models/ride.dart';
import 'package:fe_sektak/session/session_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:fe_sektak/models/user_location.dart';
import 'package:toast/toast.dart';
import '../main_screen.dart';
import 'rides_screen.dart';

class RideUpdateScreen extends StatefulWidget {
  static const String id = 'UpdateRide_Screen';
  final Ride ride;
  const RideUpdateScreen({Key key, this.ride}) : super(key: key);
  @override
  _RideUpdateState createState() => _RideUpdateState(this.ride);
}

class _RideUpdateState extends State<RideUpdateScreen>
    with SingleTickerProviderStateMixin {
  GoogleMap googleMap;
  UserLocation userLocation;
  TimeOfDay selectedTime;
  NumberPicker integerNumberPicker;
  int currentIntValue;
  final Ride ride;
  RideApi apiCaller = new RideApi();
  Set<Marker> markers = new Set();
  SessionManager sessionManager = new SessionManager();
  bool available;
  AnimationController controller;

  _RideUpdateState(this.ride);
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
      reverseDuration: Duration(seconds: 4),
    );
    currentIntValue = ride.availableSeats;
    available = ride.available;
    userLocation = new UserLocation();
    selectedTime = ride.rideTime;
    initializeNumberPickers();
    initMarkers();
  }

  Future<GoogleMap> getGoogleMap() async {
    Completer<GoogleMapController> _controller = Completer();
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
    controller.repeat();
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => Navigator.popAndPushNamed(context, RideScreen.id),
          ),
          backgroundColor: Colors.black,
          title: Text('Update Ride'),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 10, right: 10),
                child: GestureDetector(
                    onTap: onButtonPressed,
                    child: AnimatedIcon(
                      icon: AnimatedIcons.arrow_menu,
                      progress: controller,
                      size: 40,
                      color: Colors.green,
                    )))
          ],
        ),
        body: Stack(
          children: <Widget>[
            Container(
              child: showGoogleMap(),
            ),
          ],
        ));
  }

  void onButtonPressed() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Note that',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Red for Start Point',
                    style: TextStyle(color: Colors.red),
                  ),
                  Text(
                    'Green for Destination',
                    style: TextStyle(color: Colors.green),
                  ),
                  RaisedButton.icon(
                    color: Colors.amber,
                    label: Text(
                      'Update Time Of Ride',
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    icon: Icon(
                      Icons.timer,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      TimeOfDay t = await showTimePicker(
                          context: context, initialTime: selectedTime);
                      if (t != null)
                        setState(() {
                          selectedTime = t;
                        });
                    },
                  ),
                  RaisedButton(
                    color: Colors.amber,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    onPressed: () => showIntDialog(),
                    child: new Text(
                      "Update Number Of Seats",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  RaisedButton(
                    color: available ? Colors.green : Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    onPressed: () {
                      setState(() {
                        available = !available;
                        Navigator.pop(context);
                      });
                    },
                    child: new Text(
                      available ? "Available" : "Not Available",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: RaisedButton.icon(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      icon: Icon(
                        Icons.arrow_forward,
                        color: Colors.blue,
                      ),
                      label: Text(
                        'Update Ride',
                        style: TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                      onPressed: () async {
                        int startIndex = 0;
                        if (markers.elementAt(0).markerId.value != 'Source') {
                          startIndex = 1;
                        }
                        String status = await apiCaller.update(rideData: {
                          'rideId': ride.rideId,
                          'startPointLatitude':
                              markers.elementAt(startIndex).position.latitude,
                          'startPointLongitude':
                              markers.elementAt(startIndex).position.longitude,
                          'endPointLatitude': markers
                              .elementAt(1 - startIndex)
                              .position
                              .latitude,
                          'endPointLongitude': markers
                              .elementAt(1 - startIndex)
                              .position
                              .longitude,
                          'availableSeats': currentIntValue,
                          'time': selectedTime,
                          'available': available,
                        });
                        if (status == 'done') {
                          Navigator.popAndPushNamed(context, MainPage.id);
                        } else {
                          Toast.show('Enter Valid data', context);
                        }
                      },
                    ),
                  )
                ]),
          );
        });
  }

  void initializeNumberPickers() {
    integerNumberPicker = new NumberPicker.horizontal(
      initialValue: currentIntValue,
      minValue: 0,
      maxValue: 4,
      step: 1,
      onChanged: (value) => setState(() => currentIntValue = value),
    );
  }

  Future showIntDialog() async {
    await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return new Theme(
            data: ThemeData.dark(),
            child: NumberPickerDialog.integer(
                minValue: 0,
                maxValue: 4,
                step: 1,
                initialIntegerValue: currentIntValue,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                )));
      },
    ).then((num value) {
      if (value != null) {
        setState(() => currentIntValue = value);
        integerNumberPicker.animateInt(value);
      }
    });
  }

  Future<void> initMarkers() async {
    final int markerCount = markers.length;
    if (markerCount == 2) {
      return;
    }
    await userLocation.updateLatLng();
    for (int i = 0; i < 2; i++) {
      MarkerId markerId;
      Marker marker;
      markerId = MarkerId(i == 0 ? 'Source' : 'Destination');
      marker = Marker(
          markerId: markerId,
          position: i == 0
              ? LatLng(
                  ride.startPointLatitude,
                  ride.startPointLongitude,
                )
              : LatLng(ride.endPointLatitude, ride.endPointLongitude),
          infoWindow: InfoWindow(
              title: i == 0 ? 'Source' : 'Destination', snippet: '*'),
          draggable: true,
          onDragEnd: (LatLng position) {
            onMarkerDragEnd(markerId, position);
          },
          icon: i == 0
              ? BitmapDescriptor.defaultMarker
              : BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen));
      setState(() {
        markers.add(marker);
      });
    }
  }

  void onMarkerDragEnd(MarkerId markerId, LatLng newPosition) async {
    for (int index = 0; index < markers.length; index++) {
      if (markers.elementAt(index).markerId == markerId) {
        setState(() {
          markers.add(
              markers.elementAt(index).copyWith(positionParam: newPosition));
          markers.remove(markers.elementAt(index));
        });
        break;
      }
    }
  }
}
