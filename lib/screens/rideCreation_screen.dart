import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fe_sektak/widgets/marker_options.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:fe_sektak/models/marker.dart';
import 'package:fe_sektak/models/user_location.dart';

class RideCreation extends StatefulWidget {
  static const String id='RideCreation_Screen';
  @override
  _RideCreationState createState() => _RideCreationState();
}

class _RideCreationState extends State<RideCreation> {
  GoogleMap googleMap;
  UserLocation userLocation;
  List<ModifiedMarker> _markers;
  MarkerIcon markerOption;
  DateTime selectedDate;
  TimeOfDay selectedTime;
  NumberPicker integerNumberPicker;
  int _currentIntValue = 0;
  @override
  void initState() {
    super.initState();
    userLocation = new UserLocation();
    _markers = List<ModifiedMarker>();
    markerOption = new MarkerIcon();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
    _initializeNumberPickers();
  }
  /* in Case we needed it*/

//  void _onMarkerTapped(MarkerId markerId) {
//    ModifiedMarker tappedMarker;
//    int i = 0;
//    for (; i < _markers.length; i++) {
//      if (markerId == _markers.elementAt(i).getMarker().markerId) {
//        tappedMarker = _markers.elementAt(i);
//        break;
//      }
//    }
//    if (tappedMarker != null) {
//      setState(() {
//        _markers.elementAt(i).changeColor();
//      });
//    }
//  }

  Future<GoogleMap> getGoogleMap() async {
    Completer<GoogleMapController> _controller = Completer();
    if (userLocation.getLatLng() == null) {
      await userLocation.getUserLocation();
    }
    Set<Marker> markers = Set();
    for (int i = 0; i < _markers.length; i++) {
      markers.add(_markers[i].getMarker());
    }
    return googleMap = GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
          target: LatLng(userLocation.getLatLng().latitude,
              userLocation.getLatLng().longitude),
          zoom: 18),
      markers: Set<Marker>.of(markers),
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
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
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
                    _onButtonPressed();
                  },
                )),
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
              color: Colors.blueGrey,
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
                    'Green for Start Point',
                    style: TextStyle(color: Colors.green),
                  ),
                  RaisedButton.icon(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    icon: Icon(
                      Icons.flag,
                      color: Colors.black,
                    ),
                    label: Text('Press Here To Show Markers'),
                    onPressed: () {
                      Navigator.pop(context);
                      addTwoMarker();
                    },
                  ),
                  RaisedButton.icon(
                      label: Text('Select Date of Ride'),
                      icon: Icon(Icons.calendar_today),
                      onPressed: () async {
                        DateTime date = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 1)),
                        );
                        if (date != null) {
                          setState(() {
                            selectedDate = date;
                          });
                        }
                      }),
                  RaisedButton.icon(
                    label: Text('Select Time Of Ride'),
                    icon: Icon(Icons.timer),
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
                  RaisedButton(
                    onPressed: () => _showIntDialog(),
                    child: new Text("Select Number Of Seats"),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: RaisedButton.icon(
                      icon: Icon(Icons.arrow_forward),
                      label: Text('Create Ride'),
                      onPressed: () {},
                    ),
                  )
                ]),
          );
        });
  }

  void _initializeNumberPickers() {
    integerNumberPicker = new NumberPicker.horizontal(
      initialValue: _currentIntValue,
      minValue: 0,
      maxValue: 4,
      step: 1,
      onChanged: (value) => setState(() => _currentIntValue = value),
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
                initialIntegerValue: _currentIntValue,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                )));
      },
    ).then((num value) {
      if (value != null) {
        print('Modifying Number $value');
        setState(() => _currentIntValue = value);
        integerNumberPicker.animateInt(value);
      }
    });
  }

  Future<void> addTwoMarker() async {
    final int markerCount = _markers.length;
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
          position: LatLng(
            userLocation.getLatLng().latitude,
            userLocation.getLatLng().longitude,
          ),
          infoWindow: InfoWindow(
              title: i == 0 ? 'Source' : 'Destination', snippet: '*'),
//            onTap: () {
//              _onMarkerTapped(markerId);
//            },
          draggable: true,
          onDragEnd: (LatLng position) {
            _onMarkerDragEnd(markerId, position);
          },
//            icon: markerOption.getIcon()
          icon: i == 0
              ? BitmapDescriptor.defaultMarker
              : BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen));
      setState(() {
        _markers.add(ModifiedMarker(marker));
      });
    }
  }

  void _onMarkerDragEnd(MarkerId markerId, LatLng newPosition) async {
    for (int i = 0; i < _markers.length; i++) {
      if (_markers.elementAt(i).getMarker().markerId == markerId) {
        setState(() {
          _markers.elementAt(i).onMarkerDragEnd(newPosition);
        });
        break;
      }
    }
  }
}
