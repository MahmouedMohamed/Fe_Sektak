import 'dart:convert';
import 'api_caller.dart';
import 'package:http/http.dart' as http;

class NotificationApi{
  getUnReadNotificationsCount({userData}) async {
    var response = await http.get(Uri.encodeFull(URL + 'getUnReadNotificationsCount?userId=${userData['userId'].toString()}'),
        headers: {"Accpet": "application/json"});
    var convertDataToJson = jsonDecode(response.body);
    return convertDataToJson['count'];
  }

  getAll({userData}) async {
    var response = await http.get(Uri.encodeFull(URL + 'notifications?userId=${userData['userId'].toString()}'),
        headers: {"Accpet": "application/json"});
    var convertDataToJson = jsonDecode(response.body);
    return modelCreator.getNotificationsFromJson(convertDataToJson);
  }
}