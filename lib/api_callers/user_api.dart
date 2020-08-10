import 'dart:convert';
import 'package:dio/dio.dart';

import 'api_caller.dart';
import 'package:http/http.dart' as http;

class UserApi {
  register({userData, carData}) async {
    Map<String, dynamic> body = {
      'name': userData['name'].toString(),
      'email': userData['email'].toString(),
      'password': userData['password'],
      'phoneNumber': userData['phoneNumber'].toString(),
      'nationalId': userData['nationalId'].toString(),
    };
    if (carData['carLicenseId'] != '' || userData['licenceId'] != '') {
      body.addAll({
        'car[license]': carData['carLicenseId'].toString(),
        'car[model]': carData['carModel'],
        'car[color]': carData['color'],
        'car[userLicense]': userData['licenceId'].toString(),
      });
    }
    var response = await http.post(Uri.encodeFull(URL + 'register'),
        headers: {"Accpet": "application/json"}, body: body);
    var convertDataToJson = jsonDecode(response.body);
    if('done' == convertDataToJson['status']){
      return convertDataToJson['status'];
    }
    else{
      return errorCreator.getRegisterErrorsFromJson(convertDataToJson['details']);
    }
  }

  delete({userData}) async {
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

  login({userData}) async {
    var response = await http.get(
        Uri.encodeFull(URL +
            'login?email=${userData['email']}&password=${userData['password']}'),
        headers: {"Accpet": "application/json"});
    var convertDataToJson = jsonDecode(response.body);
    if (response.statusCode != 200) {
      return null;
    } else {
      if(convertDataToJson['error']==null){
        return {'type' : 'User' , 'data' : modelCreator.getUserFromJson(convertDataToJson['user'])};
      }else{
        return {'type': 'Error', 'data' :  convertDataToJson['error']};
      }
    }
  }

  update({userData}) async {
    var body = {
      'user_id': userData['userId'],
      'name': userData['name'],
      'password': userData['password'],
      'phoneNumber': userData['phoneNumber'],
    };
    if (userData['carLicenseId'] != 'null' && userData['carLicenseId'] != '') {
      body.addAll({
        'car[license]': userData['carLicenseId'].toString(),
        'car[model]': userData['carModel'],
        'car[color]': userData['carColor'],
        'car[userLicense]': userData['licenseId'].toString(),
      });
    }
    var response = await http.put(Uri.encodeFull(URL + 'user'),
        headers: {"Accpet": "application/json"}, body: body);
    var convertDataToJson = jsonDecode(response.body);
    if('done' == convertDataToJson['status']){
      return convertDataToJson['status'];
    }
    else{
      return errorCreator.getEditProfileErrorsFromJson(convertDataToJson['details']);
    }
  }

  getById({userData}) async {
    var response = await http.get(
        Uri.encodeFull(URL + 'user?userId=${userData['userId']}'),
        headers: {"Accpet": "application/json"});
    var convertDataToJson = jsonDecode(response.body);
    if (response.statusCode != 200) {
      return null;
    } else {
      return modelCreator.getUserFromJson(convertDataToJson);
    }
  }

  sendUserLocation({userData, rideData}) async {
    var body = {
      'rideId': rideData['rideId'].toString(),
      'userId': userData['userId'].toString(),
      'locationLatitude': userData['locationLatitude'].toString(),
      'locationLongitude': userData['locationLongitude'].toString(),
    };
    await http.post(Uri.encodeFull(URL + 'userLocation'),
        headers: {"Accpet": "application/json"}, body: body);
  }

  updateProfilePicture({userData}) async {
    if (userData['image'] == null) {
      return 'undone';
    }
    String fileName = userData['image'].path.split('/').last;
    FormData formData = new FormData.fromMap({
      'picture': await MultipartFile.fromFile(userData['image'].path,
          filename: fileName),
      'userId': userData['userId']
    });
    var response =
        await Dio().post(URL + 'updateProfilePicture', data: formData);
    var convertDataToJson = jsonDecode(response.toString());
    return convertDataToJson['status'];
  }
}
