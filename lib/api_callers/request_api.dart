import 'dart:convert';
import 'api_caller.dart';
import 'package:http/http.dart' as http;

class RequestApi {
  create({userData, requestData}) async {
    var body = {
      'meetPointLatitude': requestData['meetPointLatitude'].toString(),
      'meetPointLongitude': requestData['meetPointLongitude'].toString(),
      'endPointLatitude': requestData['endPointLatitude'].toString(),
      'endPointLongitude': requestData['endPointLongitude'].toString(),
      'numberOfNeededSeats': requestData['numberOfNeededSeats'].toString(),
      'time': requestData['time'].hour.toString() +
          ':' +
          requestData['time'].minute.toString(),
      'userId': userData['userId']
    };
    var response = await http.post(Uri.encodeFull(URL + 'request'),
        headers: {"Accpet": "application/json"}, body: body);
    if (response.statusCode != 200) {
      return null;
    } else {
      var convertDataToJson = jsonDecode(response.body);
      return convertDataToJson['status'];
    }
  }

  reject({requestData}) async {
    var body = {
      'requestId': requestData['requestId'].toString(),
    };
    var response = await http.put(Uri.encodeFull(URL + 'rejectRequest'),
        headers: {"Accpet": "application/json"}, body: body);
    if (response.statusCode != 200) {
      return null;
    } else {
      var convertDataToJson = jsonDecode(response.body);
      return convertDataToJson['status'];
    }
  }

  delete({requestData}) async {
    var response = await http.delete(
        Uri.encodeFull(URL + 'request?requestId=${requestData['requestId']}'),
        headers: {"Accpet": "application/json"});
    if (response.statusCode != 200) {
      return null;
    } else {
      var convertDataToJson = jsonDecode(response.body);
      return convertDataToJson['status'];
    }
  }

  getAll({userData, requestData}) async {
    var response = await http.get(
        Uri.encodeFull(URL + 'allRequests?userId=${userData['userId']}'),
        headers: {"Accpet": "application/json"});
    var convertDataToJson = jsonDecode(response.body);
    if (response.statusCode != 200) {
      return null;
    } else {
      return modelCreator.getRequestsFromJson(convertDataToJson['requests']);
    }
  }

  acceptRequest({rideData, requestData}) async {
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
  }

  sendRequest({rideData, requestData}) async {
    var body = {
      'requestId': requestData['requestId'],
      'rideId': rideData['rideId'],
    };
    var response = await http.put(Uri.encodeFull(URL + 'sendRequest'),
        headers: {"Accpet": "application/json"}, body: body);
    if (response.statusCode != 200) {
      return null;
    } else {
      return 'done';
    }
  }

  update({requestData}) async {
    var body = {
      'requestId': requestData['requestId'].toString(),
      'meetPointLatitude': requestData['meetPointLatitude'].toString(),
      'meetPointLongitude': requestData['meetPointLongitude'].toString(),
      'endPointLatitude': requestData['endPointLatitude'].toString(),
      'endPointLongitude': requestData['endPointLongitude'].toString(),
      'numberOfNeededSeats': requestData['numberOfNeededSeats'].toString(),
      'time': requestData['time'].hour.toString() +
          ':' +
          requestData['time'].minute.toString(),
    };
    var response = await http.put(Uri.encodeFull(URL + 'request'),
        headers: {"Accpet": "application/json"}, body: body);
    if (response.statusCode != 200) {
      return null;
    } else {
      var convertDataToJson = jsonDecode(response.body);
      return convertDataToJson['status'];
    }
  }
  cancel({requestData,userData}) async {
    var body = {
      'userId' : userData['userId'].toString(),
      'requestId': requestData['requestId'].toString(),
    };
    var response = await http.put(Uri.encodeFull(URL + 'cancelRequest'),
        headers: {"Accpet": "application/json"}, body: body);
    if (response.statusCode != 200) {
      return null;
    } else {
      var convertDataToJson = jsonDecode(response.body);
      return convertDataToJson['status'];
    }
  }
}
