import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

final String URL="http://192.168.1.100:8000/api/";

Future<String> register(fullName,email,password,mobileNumber,nationalId,licenceId,car,carImage,idImage)async{
   String fileCar;
   carImage!=null? fileCar = carImage.path.split('/').last : null;
   print('thing ${car.toString()}');
   if(idImage==null){
      return 'undone';
   }
   String fileId = idImage.path.split('/').last;
   FormData formData = new FormData.fromMap(({
      'fullName': fullName.toString(),
      'email': email.toString(),
      'password': password,
      'mobileNumber': mobileNumber.toString(),
      'nationalId' : nationalId.toString(),
      'licenceId' : licenceId.toString(),
      'car': [car.carLicenseID,car.type,car.color],
      'carImage': carImage!=null ? await MultipartFile.fromFile(carImage.path, filename: fileCar) : null,
      'idImage': await MultipartFile.fromFile(idImage.path, filename: fileId),
   }));
   var response = await Dio().post(URL + 'register', data: formData);
   var convertDataToJson = jsonDecode(response.toString());
   if (convertDataToJson['status'] != 'undone') {
      return 'done';
   } else {
      return 'undone';
   }
}