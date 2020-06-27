import 'package:fe_sektak/models/request.dart';
import 'package:fe_sektak/models/user.dart';

class Ride{
  String rideID;
  User driver;
  List<User> passengers;
  List<Request> requests;
  double startPointLatitude;
  double startPointLongitude;
  double endPointLatitude;
  double endPointLongitude;
  int numberOfNeededSeats;
  DateTime rideTime;
  bool available;
  bool spam;
}