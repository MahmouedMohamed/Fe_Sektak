import 'dart:convert';

import 'package:fe_sektak/models/car.dart';
import 'package:fe_sektak/models/user.dart';

import 'api_caller.dart';

import 'package:http/http.dart' as http;

class UserApi implements ApiCaller {
  @override
  create({userData,carData}) async {
    var body = {
      'fullName': userData['fullName'].toString(),
      'email': userData['email'].toString(),
      'password': userData['password'],
      'phoneNumber': userData['phoneNumber'].toString(),
      'nationalId' : userData['nationalId'].toString(),
      'licenceId' : userData['licenceId'].toString(),
      'car': [carData['carLicenseId'],carData['carModel'],carData['color']],
    };
    var response = await http.post(Uri.encodeFull(URL + 'register'),
        headers: {"Accpet": "application/json"}, body: body);
    var convertDataToJson = jsonDecode(response.toString());
    if (convertDataToJson['status'] != 'undone') {
      return 'done';
    } else {
      return 'undone';
    }
  }

  @override
  delete({userData}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  get({userData}) async {
    var body = {'email': userData['email'], 'password': userData['password']};
    var response = await http.post(Uri.encodeFull(URL + 'login'),
        headers: {"Accpet": "application/json"}, body: body);
    if (response.statusCode != 200) {
      return null;
    } else {
      var convertDataToJson = jsonDecode(response.body);
      User user = new User(
        id: convertDataToJson['user']['id'].toString(),
        nationalId: convertDataToJson['user']['nationalID'],
        name: convertDataToJson['user']['name'],
        email: convertDataToJson['user']['email'],
        phoneNumber: convertDataToJson['user']['mobileNum'],
        licenseId: convertDataToJson['user']['licenceId'],
        car: convertDataToJson['user']['car']
            ? null
            : Car(
                convertDataToJson['user']['car'][0],
                convertDataToJson['user']['car'][1],
                convertDataToJson['user']['car'][2],
              ),
        uPhoto: convertDataToJson['user']['uPhoto'],
      );
      return user;
    }
  }

  @override
  getAll({userData}) {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  update({userData}) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
