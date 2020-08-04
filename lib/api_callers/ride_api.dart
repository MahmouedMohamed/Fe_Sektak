import 'dart:convert';
import 'package:fe_sektak/models/meet_point.dart';
import 'package:fe_sektak/models/request.dart';
import 'package:fe_sektak/models/ride.dart';
import 'package:fe_sektak/models/user.dart';
import 'package:flutter/material.dart';
import 'api_caller.dart';
import 'package:http/http.dart' as http;
import 'user_api.dart';

class RideApi implements ApiCaller {
  @override
  create({userData, carData, rideData, requestData}) async {
    var body = {
      'userId': userData['userId'],
      'startPointLatitude': rideData['startPointLatitude'].toString(),
      'startPointLongitude': rideData['startPointLongitude'].toString(),
      'endPointLatitude': rideData['endPointLatitude'].toString(),
      'endPointLongitude': rideData['endPointLongitude'].toString(),
      'availableSeats': rideData['availableSeats'].toString(),
      'time': rideData['time'].hour.toString() +
          ':' +
          rideData['time'].minute.toString(),
      'available': rideData['available'].toString(),
    };
    var response = await http.post(Uri.encodeFull(URL + 'ride'),
        headers: {"Accpet": "application/json"}, body: body);
//    print('thing ${response.body}');
    if (response.statusCode != 200) {
      return null;
    } else {
      var convertDataToJson = jsonDecode(response.body);
      return convertDataToJson['status'];
    }
  }

  @override
  delete({userData, rideData, requestData}) async {
    var response = await http.delete(Uri.encodeFull(URL + 'ride?rideId=${rideData['rideId']}'),
        headers: {"Accpet": "application/json"});
    if (response.statusCode != 200) {
      return null;
    } else {
      var convertDataToJson = jsonDecode(response.body);
      print('thing ${convertDataToJson['status']}');
      return convertDataToJson['status'];
    }
  }

  TimeOfDay getTime(time) {
    List<String> array = time.toString().split(':');
//    print('thing $array');
    return TimeOfDay(hour: int.parse(array[0]), minute: int.parse(array[1]));
  }

  @override
  get({userData, requestData}) async {
    List<Ride> returnedRides = new List<Ride>();
    var response = await http.get(
        Uri.encodeFull(URL + 'availableRides?id=${requestData['requestId']}'),
        headers: {"Accpet": "application/json"});
    if (response.statusCode != 200) {
//      print('thing ${requestData['requestId']}');
      return null;
    } else {
      var convertDataToJson = jsonDecode(response.body);
      List rides = convertDataToJson['rides'];
      rides.forEach((ride) {
        returnedRides.add(new Ride(
            startPointLatitude: ride['startPointLatitude'],
            startPointLongitude: ride['startPointLongitude'],
            endPointLatitude: ride['destinationLatitude'],
            endPointLongitude: ride['destinationLongitude'],
            availableSeats: ride['availableSeats'],
            rideTime: getTime(ride['time']),
            rideId: ride['id'].toString(),
            driver: User(id: ride['user_id'].toString())));
      });
      for (int i = 0; i < rides.length; i++) {
//        print('thing ${returnedRides[i].driver.id}');
        User user = await new UserApi()
            .getById(Data: {'userId': returnedRides[i].driver.id});
        returnedRides[i].driver = user;
      }
    }
    return returnedRides;
  }

  @override
  getAll({userData, requestData}) async {
    List returnedRides = new List<Ride>();
    var response = await http.get(
        Uri.encodeFull(URL + 'allRides?userId=${userData['userId']}'),
        headers: {"Accpet": "application/json"});
    if (response.statusCode != 200) {
      return null;
    } else {
      var convertDataToJson = jsonDecode(response.body);
      List rides = convertDataToJson['rides'];
      rides.forEach((ride) {
        List<Request> returnedRequests = new List<Request>();
        if (ride['requests'] != null) {
          List requests = ride['requests'];
          requests.forEach((request) {
            returnedRequests.add(new Request(
              requestId: request['id'].toString(),
              passenger: User(id: request['user_id'].toString()),
              numberOfNeededSeats: request['neededSeats'],
              endPointLatitude: request['destinationLatitude'],
              endPointLongitude: request['destinationLongitude'],
              response: request['response'] == 1 ? true : false,
              meetPoint: new MeetPoint(
                latitude: request['meetPointLatitude'],
                longitude: request['meetPointLongitude'],
                meetingTime:
                    request['time'] == null ? null : getTime(request['time']),
              ),
            ));
          });
        }

        returnedRides.add(new Ride(
            rideId: ride['id'].toString(),
            requests: returnedRequests,
            startPointLatitude: ride['startPointLatitude'],
            startPointLongitude: ride['startPointLongitude'],
            endPointLatitude: ride['destinationLatitude'],
            endPointLongitude: ride['destinationLongitude'],
            availableSeats: ride['availableSeats'],
            rideTime: getTime(ride['time']),
            available: ride['available'] == 1 ? true : false));
      });
    }
    for (int i = 0; i < returnedRides.length; i++) {
      for (int j = 0; j < returnedRides[i].requests.length; j++) {
        User user = await UserApi().getById(Data: {
          'userId': returnedRides[i].requests[j].passenger.id.toString()
        });
        returnedRides[i].requests[j].passenger = user;
//        print(user);
      }
    }
    return returnedRides;
  }

  @override
  update({userData, rideData, requestData}) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  getById({Data}) {
    // TODO: implement getById
    throw UnimplementedError();
  }
}
