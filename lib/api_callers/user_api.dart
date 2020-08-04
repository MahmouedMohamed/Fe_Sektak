import 'dart:convert';

import 'package:fe_sektak/models/car.dart';
import 'package:fe_sektak/models/user.dart';

import 'api_caller.dart';

import 'package:http/http.dart' as http;

class UserApi implements ApiCaller {
  @override
  create({userData, carData, rideData, requestData}) async {
    Map<String, dynamic> body = {
      'name': userData['name'].toString(),
      'email': userData['email'].toString(),
      'password': userData['password'],
      'phoneNumber': userData['phoneNumber'].toString(),
      'nationalId': userData['nationalId'].toString(),
    };
    if (carData['carLicenseId'] != '') {
      body.addAll({
        'car[license]': carData['carLicenseId'].toString(),
        'car[model]': carData['carModel'],
        'car[color]': carData['color'],
        'car[userLicense]': userData['licenceId'].toString(),
      });
    }
    print(body);
    var response = await http.post(Uri.encodeFull(URL + 'register'),
        headers: {"Accpet": "application/json"}, body: body);
    print(response.body);
    var convertDataToJson = jsonDecode(response.body);
    if (convertDataToJson['status'] != 'undone') {
      return 'done';
    } else {
      return 'undone';
    }
  }

  @override
  delete({userData, rideData, requestData}) async {
    var response = await http.delete(
        Uri.encodeFull(URL + 'user?userId=${userData['userId']}'),
        headers: {"Accpet": "application/json"});
    if (response.statusCode != 200) {
      return null;
    } else {
      var convertDataToJson = jsonDecode(response.body);
      return convertDataToJson['status'];
    }
  }

  @override
  get({userData, requestData}) async {
    var response = await http.get(
        Uri.encodeFull(URL +
            'login?email=${userData['email']}&password=${userData['password']}'),
        headers: {"Accpet": "application/json"});
    print(response.statusCode);
    if (response.statusCode != 200) {
      return null;
    } else {
      var convertDataToJson = jsonDecode(response.body);
      print('thing $convertDataToJson');
      User user = new User(
        id: convertDataToJson['user']['id'].toString(),
        nationalId: convertDataToJson['user']['nationalId'],
        name: convertDataToJson['user']['name'],
        email: convertDataToJson['user']['email'],
        phoneNumber: convertDataToJson['user']['phoneNumber'],
        rate: double.parse(convertDataToJson['user']['profile']['rate'].toString()),
        numberOfServices: int.parse(convertDataToJson['user']['profile']['services'].toString()),
        totalReview: double.parse(convertDataToJson['user']['profile']['totalReview'].toString()),
        car: convertDataToJson['user']['car'] == null
            ? null
            : Car(
                convertDataToJson['user']['car']['license'],
                convertDataToJson['user']['car']['carModel'],
                convertDataToJson['user']['car']['color'],
                convertDataToJson['user']['car']['userLicense'],
              ),
        uPhoto: convertDataToJson['user']['profile']['picture'].toString(),
      );
      print(user.toList());
      return user;
    }
  }

  @override
  getAll({userData, requestData}) {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  update({userData, rideData, requestData}) async {
    var body = {
      'user_id' : userData['userId'],
      'name': userData['name'],
      'password': userData['password'],
      'phoneNumber': userData['phoneNumber'],
      'car[model]': userData['carModel'],
      'car[color]': userData['carColor'],
      'car[license]': userData['licenseId'],
      'car[userLicense]': userData['carLicenseId'],
    };
    var response = await http.put(Uri.encodeFull(URL + 'user'),
        headers: {"Accpet": "application/json"}, body: body);
    print(response.body);
    if (response.statusCode != 200) {
      return null;
    } else {
      return 'done';
    }
  }

  @override
  getById({Data}) async {
    var response = await http.get(
        Uri.encodeFull(URL + 'user?userId=${Data['userId']}'),
        headers: {"Accpet": "application/json"});
    var convertDataToJson = jsonDecode(response.body);
    print('thing $convertDataToJson');
    if (response.statusCode != 200) {
      return null;
    } else {
//      print(convertDataToJson['car']);
      return new User(
        id: convertDataToJson['id'].toString(),
        email: convertDataToJson['email'],
        phoneNumber: convertDataToJson['phoneNumber'].toString(),
        name: convertDataToJson['name'].toString(),
        nationalId: convertDataToJson['nationalId'].toString(),
        uPhoto: convertDataToJson['profile']['picture'].toString(),
        rate: double.parse(convertDataToJson['profile']['rate'].toString()),
        numberOfServices: int.parse(convertDataToJson['profile']['services'].toString()),
        totalReview: double.parse(convertDataToJson['profile']['totalReview'].toString()),
        car: convertDataToJson['car'] == null
            ? null
            : Car(
          convertDataToJson['car']['license'],
          convertDataToJson['car']['carModel'],
          convertDataToJson['car']['color'],
          convertDataToJson['car']['userLicense'],
        ),
      );
    }
  }
}
