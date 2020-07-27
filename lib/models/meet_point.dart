import 'package:flutter/material.dart';

class MeetPoint{
  String meetPointId;
  double latitude;
  double longitude;
  TimeOfDay meetingTime;
  MeetPoint({this.meetPointId,this.latitude,this.longitude,this.meetingTime});
}