import 'dart:convert';
import 'package:fe_sektak/models/request.dart';
import 'package:fe_sektak/models/ride.dart';
import 'package:fe_sektak/models/user.dart';
import 'package:flutter/material.dart';
import 'api_caller.dart';
import 'package:http/http.dart' as http;
import 'user_api.dart';

class RideApi {
  create({userData, rideData}) async {
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
    };
    var response = await http.post(Uri.encodeFull(URL + 'ride'),
        headers: {"Accpet": "application/json"}, body: body);
    if (response.statusCode != 200) {
      return null;
    } else {
      var convertDataToJson = jsonDecode(response.body);
      return convertDataToJson['status'];
    }
  }

  delete({rideData}) async {
    var response = await http.delete(
        Uri.encodeFull(URL + 'ride?rideId=${rideData['rideId']}'),
        headers: {"Accpet": "application/json"});
    if (response.statusCode != 200) {
      return null;
    } else {
      var convertDataToJson = jsonDecode(response.body);
      return convertDataToJson['status'];
    }
  }

  TimeOfDay getTime(time) {
    List<String> array = time.toString().split(':');
    return TimeOfDay(hour: int.parse(array[0]), minute: int.parse(array[1]));
  }

  getAvailableRides({userData, requestData}) async {
    var response = await http.get(
        Uri.encodeFull(URL + 'availableRides?requestId=${requestData['requestId']}'),
        headers: {"Accpet": "application/json"});
    if (response.statusCode != 200) {
      return null;
    } else {
      var convertDataToJson = jsonDecode(response.body);
      List<Ride> returnedRides =
          modelCreator.getRidesFromJson(convertDataToJson['rides']);
      for (int index = 0; index < returnedRides.length; index++) {
        User user = await new UserApi()
            .getById(userData: {'userId': returnedRides[index].driver.id});
        returnedRides[index].driver = user;
      }
      return [returnedRides,convertDataToJson['price'].toString()];
    }
  }

  getAll({userData, requestData}) async {
    var response = await http.get(
        Uri.encodeFull(URL + 'allRides?userId=${userData['userId']}'),
        headers: {"Accpet": "application/json"});
    if (response.statusCode != 200) {
      return null;
    }
    var convertDataToJson = jsonDecode(response.body);
    List<Ride> returnedRides =
        modelCreator.getRidesFromJson(convertDataToJson['rides']);
    for (int index = 0; index < returnedRides.length; index++) {
      if (convertDataToJson['rides'][index]['requests'] != null) {
        List<Request> requests = modelCreator
            .getRequestsFromJson(convertDataToJson['rides'][index]['requests']);
        for (int requestIndex = 0;
            requestIndex < requests.length;
            requestIndex++) {
          User user = await UserApi().getById(userData: {
            'userId': requests[requestIndex].passenger.id.toString()
          });
          requests[requestIndex].passenger = user;
        }
        returnedRides[index].requests = requests;
      }
    }
    return returnedRides;
  }

  update({userData, rideData, requestData}) async {
    var body = {
      'rideId': rideData['rideId'],
      'startPointLatitude': rideData['startPointLatitude'].toString(),
      'startPointLongitude': rideData['startPointLongitude'].toString(),
      'endPointLatitude': rideData['endPointLatitude'].toString(),
      'endPointLongitude': rideData['endPointLongitude'].toString(),
      'availableSeats': rideData['availableSeats'].toString(),
      'time': rideData['time'].hour.toString() +
          ':' +
          rideData['time'].minute.toString(),
      'available': rideData['available'] ? 1.toString() : 0.toString(),
    };
    var response = await http.put(Uri.encodeFull(URL + 'ride'),
        headers: {"Accpet": "application/json"}, body: body);
    if (response.statusCode != 200) {
      return null;
    } else {
      var convertDataToJson = jsonDecode(response.body);
      return convertDataToJson['status'];
    }
  }
  cancel({userData, rideData, requestData}) async {
    var body = {
      'rideId': rideData['rideId'],
    };
    var response = await http.put(Uri.encodeFull(URL + 'cancelRide'),
        headers: {"Accpet": "application/json"}, body: body);
    if (response.statusCode != 200) {
      return null;
    } else {
      var convertDataToJson = jsonDecode(response.body);
      return convertDataToJson['status'];
    }
  }
}
