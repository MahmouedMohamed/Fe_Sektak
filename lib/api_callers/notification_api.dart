import 'dart:convert';

import 'package:fe_sektak/models/notification.dart';

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
  get({userData, requestData}) async {
    var response = await http.get(Uri.encodeFull(URL + 'getUnReadNotificationsCount?userId=${userData['userId'].toString()}'),
        headers: {"Accpet": "application/json"});
    var convertDataToJson = jsonDecode(response.body);
    return convertDataToJson['count'];
  }

  @override
  getAll({userData, requestData}) async {
    var response = await http.get(Uri.encodeFull(URL + 'showNotifications?userId=${userData['userId'].toString()}'),
        headers: {"Accpet": "application/json"});
    var convertDataToJson = jsonDecode(response.body);
    print(response.body);

    List<CustomNotification> notifications = new List<CustomNotification>();
    convertDataToJson['notifications'].forEach((notification){
      print(notification['data']);
      notifications.add(CustomNotification(
        notifyingUser: notification['data']['user'].toString(),
        eventId: notification['data']['requestId'].toString(),
        type: notification['type'].split('\\')[2],
        readAt: notification['read_at']!=null? DateTime.parse(notification['read_at']):null,
        createdAt: DateTime.parse(notification['created_at'])
      ));
    });
    return notifications;
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