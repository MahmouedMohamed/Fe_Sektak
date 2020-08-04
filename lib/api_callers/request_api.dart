import 'dart:convert';
import 'package:fe_sektak/models/meet_point.dart';
import 'package:fe_sektak/models/request.dart';
import 'package:flutter/material.dart';
import 'api_caller.dart';
import 'package:http/http.dart' as http;

class RequestApi implements ApiCaller {
  @override
  create({userData, carData, rideData, requestData}) async {
    var body = {
      'meetPointLatitude': requestData['meetPointLatitude'].toString(),
      'meetPointLongitude': requestData['meetPointLongitude'].toString(),
      'endPointLatitude': requestData['endPointLatitude'].toString(),
      'endPointLongitude': requestData['endPointLongitude'].toString(),
      'numberOfNeededSeats': requestData['numberOfNeededSeats'].toString(),
      'time': requestData['time'].hour.toString() +
          ':' +
          requestData['time'].minute.toString(),
      'response': 0.toString(),
      'userId': userData['userId']
    };
    var response = await http.post(Uri.encodeFull(URL + 'request'),
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
  delete({userData, rideData, requestData}) async {
    var response = await http.delete(Uri.encodeFull(URL + 'request?requestId=${requestData['requestId']}'),
        headers: {"Accpet": "application/json"});
    if (response.statusCode != 200) {
      return null;
    } else {
      var convertDataToJson = jsonDecode(response.body);
      return convertDataToJson['status'];
    }
  }

  @override
  get({userData, requestData}) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  getAll({userData, requestData}) async {
    var response = await http.get(
        Uri.encodeFull(URL + 'allRequests?userId=${userData['userId']}'),
        headers: {"Accpet": "application/json"});
    var convertDataToJson = jsonDecode(response.body);
    if (response.statusCode != 200) {
      return null;
    } else {
      List requests = convertDataToJson['requests'];
      List<Request> returnedRequests = new List<Request>();
      TimeOfDay getTime(time) {
        List<String> array = time.toString().split(':');
        return TimeOfDay(
            hour: int.parse(array[0]), minute: int.parse(array[1]));
      }

      requests.forEach((request) {
        returnedRequests.add(new Request(
          requestId: request['id'].toString(),
          rideId: request['ride_id'].toString(),
          response: request['response'] == 0 ? false : true,
          meetPoint: new MeetPoint(
            latitude: request['meetPointLatitude'],
            longitude: request['meetPointLongitude'],
            meetingTime: getTime(request['time']),
          ),
          endPointLatitude: request['destinationLatitude'],
          endPointLongitude: request['destinationLongitude'],
          numberOfNeededSeats: request['neededSeats'],
        ));
      });
      return returnedRequests;
    }
  }

  @override
  update({userData, rideData, requestData}) async {
    if (rideData != null) {
      var body = {
        'requestId': requestData['requestId'],
        'rideId': rideData['rideId'],
      };
      var response = await http.put(Uri.encodeFull(URL + 'acceptRequest'),
          headers: {"Accpet": "application/json"}, body: body);
      if (response.statusCode != 200) {
        return null;
      } else {
        return 'done';
      }
    } else {
      var body = {
        'requestId': requestData['request'].requestId,
        'rideId': requestData['request'].rideId,
        'meetPointLatitude':
            requestData['request'].meetPoint.latitude.toString(),
        'meetPointLongitude':
            requestData['request'].meetPoint.longitude.toString(),
        'endPointLatitude': requestData['request'].endPointLatitude.toString(),
        'endPointLongitude':
            requestData['request'].endPointLongitude.toString(),
        'numberOfNeededSeats':
            requestData['request'].numberOfNeededSeats.toString(),
        'time': requestData['request'].meetPoint.meetingTime.hour.toString() +
            ':' +
            requestData['request'].meetPoint.meetingTime.minute.toString(),
        'userId': userData['userId'],
      };
      var response = await http.put(Uri.encodeFull(URL + 'request'),
          headers: {"Accpet": "application/json"}, body: body);
      if (response.statusCode != 200) {
        return null;
      } else {
        return 'done';
      }
    }
  }

  @override
  getById({Data}) {
    // TODO: implement getById
    throw UnimplementedError();
  }
}
