import 'package:fe_sektak/api_callers/request_api.dart';
import 'package:fe_sektak/models/request.dart';
import 'package:fe_sektak/session/session_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:fe_sektak/models/user_location.dart';
import 'package:toast/toast.dart';
import '../main_screen.dart';
import 'requests_screen.dart';

class RequestUpdateScreen extends StatefulWidget {
  static const String id = 'UpdateRide_Screen';
  final Request request;
  const RequestUpdateScreen({Key key, this.request}) : super(key: key);
  @override
  _RequestUpdateState createState() => _RequestUpdateState(this.request);
}

class _RequestUpdateState extends State<RequestUpdateScreen>
    with SingleTickerProviderStateMixin {
  GoogleMap googleMap;
  UserLocation userLocation;
  TimeOfDay selectedTime;
  NumberPicker integerNumberPicker;
  int currentIntValue;
  final Request request;
  RequestApi apiCaller = new RequestApi();
  Set<Marker> markers = new Set();
  SessionManager sessionManager = new SessionManager();
  bool available;
  AnimationController controller;

  _RequestUpdateState(this.request);
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
      reverseDuration: Duration(seconds: 4),
    );
    currentIntValue = request.numberOfNeededSeats;
    userLocation = new UserLocation();
    selectedTime = request.meetPoint.meetingTime;
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
            onPressed: () =>
                Navigator.popAndPushNamed(context, RequestScreen.id),
          ),
          backgroundColor: Colors.black,
          title: Text('Update Request'),
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
                    'Blue for Meet point',
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
                        'Update Request',
                        style: TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                      onPressed: () async {
                        int startIndex = 0;
                        if (markers.elementAt(0).markerId.value !=
                            'MeetPoint') {
                          startIndex = 1;
                        }
                        String status = await apiCaller.update(
                          requestData: {
                            'requestId': request.requestId,
                            'meetPointLatitude':
                                markers.elementAt(startIndex).position.latitude,
                            'meetPointLongitude': markers
                                .elementAt(startIndex)
                                .position
                                .longitude,
                            'endPointLatitude': markers
                                .elementAt(1 - startIndex)
                                .position
                                .latitude,
                            'endPointLongitude': markers
                                .elementAt(1 - startIndex)
                                .position
                                .longitude,
                            'numberOfNeededSeats': currentIntValue,
                            'time': selectedTime,
                          },
                        );
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
      markerId = MarkerId(i == 0 ? 'MeetPoint' : 'Destination');
      marker = Marker(
          markerId: markerId,
          position: i == 0
              ? LatLng(
                  request.meetPoint.latitude,
                  request.meetPoint.longitude,
                )
              : LatLng(request.endPointLatitude, request.endPointLongitude),
          infoWindow: InfoWindow(
              title: i == 0 ? 'MeetPoint' : 'Destination', snippet: '*'),
          draggable: true,
          onDragEnd: (LatLng position) {
            onMarkerDragEnd(markerId, position);
          },
          icon: i == 0
              ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
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
