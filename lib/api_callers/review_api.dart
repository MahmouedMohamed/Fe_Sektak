import 'dart:convert';
import 'api_caller.dart';
import 'package:http/http.dart' as http;

class ReviewApi {
  create({userData}) async {
    Map<String, dynamic> body = {
      'userId': userData['userId'].toString(),
      'rate': userData['rate'].toString(),
    };
    var response = await http.post(Uri.encodeFull(URL + 'review'),
        headers: {"Accpet": "application/json"}, body: body);
    var convertDataToJson = jsonDecode(response.body);
    return convertDataToJson['status'];
  }
}
