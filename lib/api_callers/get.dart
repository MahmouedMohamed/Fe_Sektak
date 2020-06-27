import 'dart:convert';
import 'package:fe_sektak/models/car.dart';
import 'package:fe_sektak/models/user.dart';
import 'package:fe_sektak/models/ride.dart';
import 'package:fe_sektak/models/request.dart';
import 'package:fe_sektak/models/meet_point.dart';
import 'package:http/http.dart' as http;

final String URL = "http://192.168.1.100:8000/api/";

Future<User> getUser(email, password) async {
  var body = {'email': email, 'password': password};
  var response = await http.post(Uri.encodeFull(URL + 'login'),
      headers: {"Accpet": "application/json"}, body: body);
  if (response.statusCode != 200) {
    return null;
  } else {
    var convertDataToJson = jsonDecode(response.body);
    User user = new User(
      id: convertDataToJson['user']['id'].toString(),
      nationalId: convertDataToJson['user']['nationalId'],
      name: convertDataToJson['user']['fullName'],
      email: convertDataToJson['user']['email'],
      phoneNumber: convertDataToJson['user']['phoneNumber'],
      licenseID: convertDataToJson['user']['licenceId'],
      car: convertDataToJson['user']['car']
          ? null
          : Car(
              convertDataToJson['user']['car'][0],
              convertDataToJson['user']['car'][1],
              convertDataToJson['user']['car'][2],
            ),
      uPhoto: convertDataToJson['user']['uPhoto'],
    );
    return user;
  }
}

Future<List<Ride>> getAllRides(userId)async{
  var body = {'userId': userId};
  List returnedRides = new List<Ride>();
  var response = await http.post(Uri.encodeFull(URL + 'rides'),
      headers: {"Accpet": "application/json"}, body: body);
  if (response.statusCode != 200) {
    return null;
  } else {
    var convertDataToJson = jsonDecode(response.body);
    List rides = convertDataToJson['rides'];
    rides.forEach((ride) {
      List returnedRequests = new List<Request>();
      if(ride['requests']!=null){
        List requests = ride['requests'];
        requests.forEach((request){
          returnedRequests.add( new Request(
            requestId: request['requestId'],
            passenger:  new User(
              id: request['user']['id'].toString(),
              nationalId: request['user']['nationalId'],
              name: request['user']['fullName'],
              email: request['user']['email'],
              phoneNumber: request['user']['phoneNumber'],
              uPhoto: request['user']['uPhoto'],
            ),
            numberOfNeededSeats:request['numberOfNeededSeats'],
            startPointLatitude:request['startPointLatitude'],
            startPointLongitude:request['startPointLatitude'],
            endPointLatitude:request['startPointLatitude'],
            endPointLongitude:request['startPointLatitude'],
            meetPoint:new MeetPoint(
              request['MeetPoint'][0],
              request['MeetPoint'][1],
              request['MeetPoint'][2],
              request['MeetPoint'][2] == null
                  ? null
                  : DateTime.parse( request['MeetPoint'][2]),
            ),
          )
          );
        });
      }
      returnedRides.add(new Ride(
          rideId: ride['id'],
          driver: ride['driver'],
          requests: returnedRequests,
          startPointLatitude: ride['startPointLatitude'],
          startPointLongitude: ride['startPointLongitude'],
          endPointLatitude: ride['endPointLatitude'],
          endPointLongitude: ride['endPointLongitude'],
          numberOfNeededSeats: ride['numberOfNeededSeats'],
          rideTime: ride['rideTime'],   /// Must be converted
          available: ride['available']
      ));
    });
  }
    return returnedRides;
}
