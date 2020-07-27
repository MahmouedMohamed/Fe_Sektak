import 'package:fe_sektak/models/request.dart';
import 'package:fe_sektak/models/user.dart';

class Ride {
  String rideId;
  User driver;
  List<Request> requests;
  double startPointLatitude;
  double startPointLongitude;
  double endPointLatitude;
  double endPointLongitude;
  int availableSeats;
  DateTime rideTime;
  bool available;
  bool spam;

  //initial input
  Ride({
    this.rideId,
    this.driver,
    this.requests,
    this.startPointLatitude,
    this.startPointLongitude,
    this.endPointLatitude,
    this.endPointLongitude,
    this.availableSeats,
    this.rideTime,
    this.available
  });
}
