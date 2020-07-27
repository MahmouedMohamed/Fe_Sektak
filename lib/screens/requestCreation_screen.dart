import 'dart:async';

import 'package:fe_sektak/models/marker.dart';
import 'package:fe_sektak/models/user_location.dart';
import 'package:fe_sektak/widgets/marker_options.dart';
import 'package:fe_sektak/screens/ride_selector.dart';
import 'package:fe_sektak/models/request.dart';
import 'package:fe_sektak/models/meet_point.dart';
import 'package:fe_sektak/session/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter/cupertino.dart';

class RequestCreation extends StatefulWidget {
  static const String id = 'RequestCreation_Screen';
  @override
  _RequestCreationState createState() => _RequestCreationState();
}

class _RequestCreationState extends State<RequestCreation> {
  GoogleMap googleMap;
  UserLocation userLocation;
  List<ModifiedMarker> markers;
  NumberPicker integerNumberPicker;
  int currentIntValue = 1;
  bool isLoaded = false;
  TimeOfDay selectedTime;
  SessionManager sessionManager = new SessionManager();
  @override
  void initState() {
    super.initState();
    userLocation = new UserLocation();
    markers = List<ModifiedMarker>();
    selectedTime = TimeOfDay.now();
    _initializeNumberPickers();
  }

  Future<GoogleMap> getGoogleMap() async {
    await userLocation.getUserLocation();
    Set<Marker> _markers = Set();
    for (int i = 0; i < markers.length; i++) {
      _markers.add(markers[i].getMarker());
    }
    return googleMap = GoogleMap(
      initialCameraPosition: CameraPosition(
          target: LatLng(userLocation.getLatLng().latitude,
              userLocation.getLatLng().longitude),
          zoom: 18),
      markers: Set<Marker>.of(_markers),
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
          isLoaded = true;
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
        body: Stack(
          children: <Widget>[
            Container(
              child: showGoogleMap(),
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: RaisedButton(
                  child: Text('Begin Creation'),
                  onPressed: () {
                    isLoaded ? _onButtonPressed() : null;
                  },
                ))
          ],
        ));
  }

  void _onButtonPressed() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Declare Your Points of The Ride'),
                  Text(
                    'Red for Destination',
                    style: TextStyle(color: Colors.red),
                  ),
                  Text(
                    'Blue for Meet Point',
                    style: TextStyle(color: Colors.blue),
                  ),
                  Text(
                    'Green for Start Point',
                    style: TextStyle(color: Colors.green),
                  ),
                  RaisedButton.icon(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    icon: Icon(
                      Icons.flag,
                      color: Colors.amber,
                    ),
                    color: Colors.black,
                    label: Text(
                      'Press Here To Show Markers',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      addThreeMarkers();
                    },
                  ),
                  RaisedButton.icon(
                    color: Colors.black,
                    label: Text(
                      'Select Time Of Ride',
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: Icon(
                      Icons.timer,
                      color: Colors.amber,
                    ),
                    onPressed: () async {
                      TimeOfDay t = await showTimePicker(
                          context: context, initialTime: selectedTime);
                      if (t != null)
                        setState(() {
                          selectedTime = t;
                          print('Modifying Time $selectedTime');
                        });
                    },
                  ),
                  RaisedButton.icon(
                    color: Colors.black,
                    onPressed: () => _showIntDialog(),
                    icon: Icon(Icons.airline_seat_recline_normal,
                        color: Colors.amber),
                    label: new Text(
                      "Select Number Of Seats you need",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: RaisedButton.icon(
                      color: Colors.black,
                      icon: Icon(
                        Icons.arrow_forward,
                        color: Colors.amber,
                      ),
                      label: Text(
                        'Create Request',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Request request = new Request(
                          startPointLatitude:
                              markers[0].marker.position.latitude,
                          startPointLongitude:
                              markers[0].marker.position.longitude,
                          endPointLatitude: markers[1].marker.position.latitude,
                          endPointLongitude:
                              markers[1].marker.position.longitude,
                          meetPoint: new MeetPoint(
                              meetingTime: selectedTime,
                              latitude: markers[2].marker.position.latitude,
                              longitude: markers[2].marker.position.longitude),
                          passenger: sessionManager.getUser(),
                          numberOfNeededSeats: currentIntValue
                        );
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RideSelector(request: request,),
                            ));
//                        print(
//                            'thing ${markers[0].marker.position} ${markers[1].marker.position} ${markers[2].marker.position}');
//                        print('thing ${selectedTime.runtimeType}');
//                        print('thing ${currentIntValue}');
                      },
                    ),
                  )
                ]),
          );
        });
  }

  void _initializeNumberPickers() {
    integerNumberPicker = new NumberPicker.horizontal(
      initialValue: currentIntValue,
      minValue: 1,
      maxValue: 4,
      step: 1,
      onChanged: (value) => setState(() => currentIntValue = value),
    );
  }

  Future _showIntDialog() async {
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
        print('Modifying Number $value');
        setState(() => currentIntValue = value);
        integerNumberPicker.animateInt(value);
      }
    });
  }

  Future<void> addThreeMarkers() async {
    final int markerCount = markers.length;
    if (markerCount == 3) {
      return;
    }
    await userLocation.updateLatLng();
    for (int i = 0; i < 3; i++) {
      MarkerId markerId;
      Marker marker;
      markerId =
          MarkerId(i == 0 ? 'Source' : i == 1 ? 'Destination' : 'MeetPoint');
      marker = Marker(
          markerId: markerId,
          position: LatLng(
            userLocation.getLatLng().latitude,
            userLocation.getLatLng().longitude,
          ),
          infoWindow: InfoWindow(
              title: i == 0 ? 'Source' : i == 1 ? 'Destination' : 'MeetPoint'),
          draggable: true,
          onDragEnd: (LatLng position) {
            _onMarkerDragEnd(markerId, position);
          },
          icon: i == 0
              ? BitmapDescriptor.defaultMarker
              : i == 1
                  ? BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueGreen)
                  : BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueBlue));
      setState(() {
        markers.add(ModifiedMarker(marker));
      });
    }
  }

  void _onMarkerDragEnd(MarkerId markerId, LatLng newPosition) async {
    for (int i = 0; i < markers.length; i++) {
      if (markers.elementAt(i).getMarker().markerId == markerId) {
        setState(() {
          markers.elementAt(i).onMarkerDragEnd(newPosition);
        });
        break;
      }
    }
  }
}
