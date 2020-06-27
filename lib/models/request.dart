import 'meet_point.dart';
import 'user.dart';
class Request{
  String requestId;
  User passenger;
  int numberOfNeededSeats;
  double startPointLatitude;
  double startPointLongitude;
  double endPointLatitude;
  double endPointLongitude;
  bool spam;
  MeetPoint meetPoint;

  Request({this.requestId,this.passenger, this.numberOfNeededSeats, this.startPointLatitude,
      this.startPointLongitude, this.endPointLatitude, this.endPointLongitude,
      this.meetPoint});
}