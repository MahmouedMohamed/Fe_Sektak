import 'meet_point.dart';

class Request{
  String requestID;
  int numberOfNeededSeats;
  double startPointLatitude;
  double startPointLongitude;
  double endPointLatitude;
  double endPointLongitude;
  bool spam;
  MeetPoint meetPoint;
  String rideID;

  Request(this.requestID, this.numberOfNeededSeats, this.startPointLatitude,
      this.startPointLongitude, this.endPointLatitude, this.endPointLongitude,
      this.spam, this.meetPoint, this.rideID);
}