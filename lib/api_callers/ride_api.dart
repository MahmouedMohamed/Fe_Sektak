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
  create({userData,carData}) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  delete({userData}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  get({userData}) async {   ///////////get for specific user
    var body = {'userId': userData['userId']};
    List returnedRides = new List<Ride>();
    var response = await http.post(Uri.encodeFull(URL + 'allRides'),
        headers: {"Accpet": "application/json"}, body: body);
    if (response.statusCode != 200) {
      return null;
    } else {
      var convertDataToJson = jsonDecode(response.body);
      List rides = convertDataToJson['rides'];
      rides.forEach((ride) {
        List returnedRequests = new List<Request>();
        if (ride['requests'] != null) {
          List requests = ride['requests'];
          requests.forEach((request) async {
            User user =
            await UserApi().get(userData: {'userId': request['userId']});
            returnedRequests.add(new Request(
              requestId: request['requestId'],
              passenger: user,
              numberOfNeededSeats: request['numberOfNeededSeats'],
              startPointLatitude: request['startLat'],
              startPointLongitude: request['StartLng'],
              endPointLatitude: request['EndLat'],
              endPointLongitude: request['EndLng'],
              meetPoint: new MeetPoint(
                meetPointId: request['MeetPoint'][0],
                latitude: double.parse(request['meetPoint'][1]),
                longitude: double.parse(request['meetPoint'][2]),
                meetingTime: request['MeetPoint'][2] == null
                    ? null
                    : TimeOfDay.fromDateTime(DateTime.parse(request['meetPoint'][3])),
              ),
            ));
          });
        }
        returnedRides.add(new Ride(
            rideId: ride['id'],
            driver: ride['driver'],
            requests: returnedRequests,
            startPointLatitude: ride['startPoint']['lat'],
            startPointLongitude: ride['startPoint']['lng'],
            endPointLatitude: ride['endPoint']['lat'],
            endPointLongitude: ride['endPoint']['lng'],
            availableSeats: ride['availableSeats'],
            rideTime: ride['rideTime'],

            /// Must be converted
            available: bool.fromEnvironment(ride['available'])));
      });
    }
    return returnedRides;
  }

  @override
  getAll({userData,requestData}) async { ///////////get responding for request
    var body = {
      'startPointLatitude' : requestData['startPointLatitude'],
      'startPointLongitude' : requestData['startPointLongitude'],
      'endPointLatitude' : requestData['endPointLatitude'],
      'endPointLongitude' : requestData['endPointLongitude'],
      'numberOfNeededSeats' : requestData['numberOfNeededSeats'],
    };
    List returnedRides = new List<Ride>();
    var response = await http.post(Uri.encodeFull(URL + 'suitableRides'),
        headers: {"Accpet": "application/json"}, body: body);
    if (response.statusCode != 200) {
      return null;
    } else {
      var convertDataToJson = jsonDecode(response.body);
      List rides = convertDataToJson['rides'];
      rides.forEach((ride) {
        returnedRides.add(new Ride(
            rideId: ride['id'],
            driver: ride['driver'],
            startPointLatitude: ride['startPoint']['lat'],
            startPointLongitude: ride['startPoint']['lng'],
            endPointLatitude: ride['endPoint']['lat'],
            endPointLongitude: ride['endPoint']['lng'],
            availableSeats: ride['availableSeats'],
            rideTime: ride['rideTime'],

            /// Must be converted
            available: ride['available']));
      });
    }
    return returnedRides;
  }

  @override
  update({userData}) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
