import 'package:fe_sektak/models/user_location.dart';
import 'package:flutter/cupertino.dart';

import 'car.dart';
import 'request.dart';

class User {
  String UID;
  String nationalID;
  String name;
  String licenseID;
  Car car;
  UserLocation userLocation;
  List<Request> request;
  String UPhoto;
  User(
      {this.UID,
      this.nationalID,
      this.name,
      this.licenseID,
      this.car,
      this.userLocation,
      this.request,
      this.UPhoto});
}
