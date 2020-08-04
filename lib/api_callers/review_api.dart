import 'dart:convert';

import 'api_caller.dart';

import 'package:http/http.dart' as http;

class ReviewApi implements ApiCaller {
  @override
  create({userData, carData, rideData, requestData}) async {
    Map<String, dynamic> body = {
      'userId': userData['userId'].toString(),
      'rate': userData['rate'].toString(),
    };
    var response = await http.post(Uri.encodeFull(URL + 'calcUserTotalReview'),
        headers: {"Accpet": "application/json"}, body: body);
    print(response.body);
    var convertDataToJson = jsonDecode(response.body);
    return convertDataToJson['status'];
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
