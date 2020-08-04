import 'dart:convert';

import 'api_caller.dart';
import 'package:http/http.dart' as http;

class NotificationApi implements ApiCaller{
  @override
  create({userData, carData, rideData, requestData}) async {
    var body = {
      'rideId': rideData['rideId'].toString(),
      'userId': userData['userId'].toString(),
      'locationLatitude': userData['locationLatitude'].toString(),
      'locationLongitude': userData['locationLongitude'].toString(),
    };
    await http.post(Uri.encodeFull(URL + 'sendNotification'),
        headers: {"Accpet": "application/json"}, body: body);
  }

  @override
  delete({userData, rideData, requestData}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  get({userData, requestData}) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  getAll({userData, requestData}) {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  getById({Data}) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  update({userData, rideData, requestData}) {
    // TODO: implement update
    throw UnimplementedError();
  }

}