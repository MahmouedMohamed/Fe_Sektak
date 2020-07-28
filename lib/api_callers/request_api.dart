
import 'api_caller.dart';

import 'package:http/http.dart' as http;

import 'user_api.dart';
class RequestApi implements ApiCaller{
  @override
  create({userData, carData,rideData,requestData}) async {
    var body = {
      'meetPointLatitude' : requestData['meetPointLatitude'],
      'meetPointLongitude' : requestData['meetPointLongitude'],
      'endPointLatitude' : requestData['endPointLatitude'],
      'endPointLongitude' : requestData['endPointLongitude'],
      'numberOfNeededSeats' : requestData['numberOfNeededSeats'],
      'time' : requestData['meetingTime'],
      'response' : false
    };
    var response = await http.post(Uri.encodeFull(URL + 'request'),
        headers: {"Accpet": "application/json"}, body: body);
    if (response.statusCode != 200) {
      return null;
    } else {
      return 'done';
    }
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
  getAll({userData,requestData}) {
    // TODO: implement getAll
    throw UnimplementedError();
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