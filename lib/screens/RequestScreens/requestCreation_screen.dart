import 'dart:async';

import 'package:fe_sektak/api_callers/api_caller.dart';
import 'package:fe_sektak/api_callers/request_api.dart';
import 'package:fe_sektak/models/user_location.dart';
import 'package:fe_sektak/session/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';

import '../main_screen.dart';

class RequestCreation extends StatefulWidget {
  static const String id = 'RequestCreation_Screen';
  @override
  _RequestCreationState createState() => _RequestCreationState();
}

class _RequestCreationState extends State<RequestCreation> {
  GoogleMap googleMap;
  UserLocation userLocation;
  Set<Marker> markers=new Set();
  NumberPicker integerNumberPicker;
  int currentIntValue = 1;
  bool isLoaded = false;
  TimeOfDay selectedTime;
  SessionManager sessionManager = new SessionManager();
  @override
  void initState() {
    super.initState();
    userLocation = new UserLocation();
    selectedTime = TimeOfDay.now();
    initializeNumberPickers();
  }

  Future<GoogleMap> getGoogleMap() async {
    await userLocation.getUserLocation();
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
        appBar: AppBar(
          leading: BackButton(),
          title: Text('Ride Creation'),
        ),
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
                      addTwoMarkers();
                    },
                  ),
                  RaisedButton.icon(
                    color: Colors.black,
                    label: Text(
                      'Select Time Of meeting',
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
                    onPressed: () => showIntDialog(),
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
                      onPressed: () async {
                        RequestApi apiCaller = new RequestApi();
                        int startIndex = 0;
                        if(markers.elementAt(0).markerId.value!='MeetPoint'){
                          startIndex =1;
                        }
                        String status = await apiCaller.create(
                          requestData: {
                          'meetPointLatitude': markers.elementAt(startIndex).position.latitude,
                          'meetPointLongitude' :markers.elementAt(startIndex).position.longitude,
                          'endPointLatitude' : markers.elementAt(1-startIndex).position.latitude,
                          'endPointLongitude' : markers.elementAt(1-startIndex).position.longitude,
                          'numberOfNeededSeats' : currentIntValue,
                          'time' : selectedTime,
                          'response' : false
                        },userData: {'userId' : sessionManager.getUser().id});
                        if(status=='done'){
                          Navigator.popAndPushNamed(context, MainPage.id);
                        }else{
                          Toast.show('Please Enter valid data', context);
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
      minValue: 1,
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
        print('Modifying Number $value');
        setState(() => currentIntValue = value);
        integerNumberPicker.animateInt(value);
      }
    });
  }

  Future<void> addTwoMarkers() async {
    final int markerCount = markers.length;
    if (markerCount == 2) {
      return;
    }
    await userLocation.updateLatLng();
    for (int i = 0; i < 2; i++) {
      MarkerId markerId;
      Marker marker;
      markerId =
          MarkerId(i == 0 ? 'MeetPoint' : 'Destination');
      marker = Marker(
          markerId: markerId,
          position: LatLng(
            userLocation.getLatLng().latitude,
            userLocation.getLatLng().longitude,
          ),
          infoWindow: InfoWindow(
              title: i == 0 ? 'MeetPoint' : 'Destination'),
          draggable: true,
          onDragEnd: (LatLng position) {
            _onMarkerDragEnd(markerId, position);
          },
          icon: i == 0
              ? BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueGreen)
                  : BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueBlue));
      setState(() {
        markers.add(marker);
      });
    }
  }

  void _onMarkerDragEnd(MarkerId markerId, LatLng newPosition) async {
    for (int index = 0; index < markers.length; index++) {
      if (markers.elementAt(index).markerId == markerId) {
        setState(() {
          markers.add(markers.elementAt(index).copyWith(
              positionParam: newPosition
          ));
          markers.remove(markers.elementAt(index));
        });
        break;
      }
    }
  }
}
