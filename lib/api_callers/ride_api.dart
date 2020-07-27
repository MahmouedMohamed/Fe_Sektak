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
  get({userData}) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  getAll({userData}) async {
    var body = {'userId': userData['userId']};
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
        if (ride['requests'] != null) {
          List requests = ride['requests'];
          requests.forEach((request) async {
            User user =
                await UserApi().get(userData: {'userId': request['userId']});
            returnedRequests.add(new Request(
              requestId: request['requestId'],
              passenger: user,
              numberOfNeededSeats: request['numberOfNeededSeats'],
              startPointLatitude: request['startPointLatitude'],
              startPointLongitude: request['startPointLatitude'],
              endPointLatitude: request['startPointLatitude'],
              endPointLongitude: request['startPointLatitude'],
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
            startPointLatitude: ride['startPointLatitude'],
            startPointLongitude: ride['startPointLongitude'],
            endPointLatitude: ride['endPointLatitude'],
            endPointLongitude: ride['endPointLongitude'],
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
