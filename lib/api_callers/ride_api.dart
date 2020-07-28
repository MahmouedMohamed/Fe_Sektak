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
  create({userData,carData,rideData,requestData}) async {
    var body = {
      'userId': userData['userId'],
      'startPointLatitude': rideData['startPointLatitude'].toString(),
      'startPointLongitude': rideData['startPointLongitude'].toString(),
      'endPointLatitude': rideData['endPointLatitude'].toString(),
      'endPointLongitude': rideData['endPointLongitude'].toString(),
      'availableSeats': rideData['availableSeats'].toString(),
      'time': rideData['time'].hour.toString()+':'+rideData['time'].minute.toString(),
      'available': rideData['available'].toString(),
    };
    var response = await http.post(Uri.encodeFull(URL + 'ride'),
        headers: {"Accpet": "application/json"}, body: body);
    print('thing ${response.body}');
    if (response.statusCode != 200) {
      return null;
    } else {
      var convertDataToJson = jsonDecode(response.body);
      return convertDataToJson['status'];
    }
  }
  @override
  delete({userData}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  get({userData}) async {   ///////////get for specific user

  }

  @override
  getAll({userData,requestData}) async { ///////////get responding for request
    List returnedRides = new List<Ride>();
    var response = await http.get(Uri.encodeFull(URL + 'myRides?userId=${userData['userId']}'),
        headers: {"Accpet": "application/json"});
//    print(response.body);
    if (response.statusCode != 200) {
      return null;
    } else {
      var convertDataToJson = jsonDecode(response.body);
      List rides = convertDataToJson['rides'];
      rides.forEach((ride) async {
        List <Request> returnedRequests = new List<Request>();
        if (ride['requests'] != null) {
          List requests = ride['requests'];
          await Future.forEach(requests, (request) async {
            User user =
            await UserApi().getById(Data:  {'userId': request['user_id']});
//            print(request);
            TimeOfDay getTime(time){
              List<String> array = time.toString().split(':');
              return TimeOfDay(hour: int.parse(array[0]), minute: int.parse(array[1]));
            }
//            print(user.toList());
            returnedRequests.add(new Request(
              requestId: request['id'].toString(),
              passenger: user,
              numberOfNeededSeats: request['neededSeats'],
              endPointLatitude: request['destinationLatitude'],
              endPointLongitude: request['destinationLongitude'],
              response: request['response']==1? true:false,
              meetPoint: new MeetPoint(
                latitude: request['meetPointLatitude'],
                longitude: request['meetPointLongitude'],
                meetingTime: request['time']== null
                    ? null
                    : getTime(request['time']),
              ),
            ));
            print('thing ${returnedRequests[0].passenger.name}');
          });
        }
//        print('thing thing $returnedRequests');
        returnedRides.add(new Ride(
            rideId: ride['id'].toString(),
            requests: returnedRequests,
            startPointLatitude: ride['startPointLatitude'],
            startPointLongitude: ride['startPointLongitude'],
            endPointLatitude: ride['destinationLatitude'],
            endPointLongitude: ride['destinationLongitude'],
            availableSeats: ride['availableSeats'],
            rideTime: ride['rideTime'],
            /// Must be converted
            available: ride['available'] == 1 ? true:false));
      });
//      print(returnedRides[0]);
    }
    return returnedRides;
  }

  @override
  update({userData}) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  getById({Data}) {
    // TODO: implement getById
    throw UnimplementedError();
  }
}
