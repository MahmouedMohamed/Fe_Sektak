import 'package:fe_sektak/models/request.dart';
import 'package:fe_sektak/models/user.dart';
import 'package:flutter/material.dart';

class Ride {
  String rideId;
  User driver;
  List<Request> requests;
  double startPointLatitude;
  double startPointLongitude;
  double endPointLatitude;
  double endPointLongitude;
  int availableSeats;
  TimeOfDay rideTime;
  bool available;
  bool spam;
  Ride(
      {this.rideId,
      this.driver,
      this.requests,
      this.startPointLatitude,
      this.startPointLongitude,
      this.endPointLatitude,
      this.endPointLongitude,
      this.availableSeats,
      this.rideTime,
      this.available});
}
