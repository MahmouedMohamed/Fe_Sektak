import 'package:flutter/material.dart';

import 'meet_point.dart';
import 'user.dart';
class Request{
  String requestId;
  User passenger;
  int numberOfNeededSeats;
  double endPointLatitude;
  double endPointLongitude;
  MeetPoint meetPoint;
  bool response;
  bool spam;

  Request({this.requestId,this.passenger, this.numberOfNeededSeats, this.response, this.endPointLatitude, this.endPointLongitude,
      this.meetPoint});
}