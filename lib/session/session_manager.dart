import 'package:fe_sektak/models/car.dart';
import 'package:fe_sektak/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  SharedPreferences sharedPreferences;
  User user;
//  String oauthToken;
//  DateTime sessionExpire;
  SessionManager._privateConstructor();

  static final SessionManager _instance = SessionManager._privateConstructor();

  factory SessionManager() {
    return _instance;
  }
  getSessionManager() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  loadSession() {
    List<String> userData = sharedPreferences.getStringList('user');
    print(userData);
    List<String> list = userData[8].split(',');
    list[0] = list[0].substring(1);
    list[list.length-1] = list[list.length-1].substring(0,list[list.length-1].length-1);
//    print(list);
//    logout();
    user = new User(
        id: userData[0],
        nationalId: userData[1],
        name: userData[2],
        email: userData[3],
        phoneNumber: userData[4],
        rate: double.parse(userData[5]),
        numberOfServices: int.parse(userData[6]),
        totalReview: double.parse(userData[7]),
        car: Car(list[0], list[1], list[2],list[3]),
        uPhoto: userData[9]);
  }

  createSession(User user) {
    this.user = user;
//    this.oauthToken = oauthToken;
    sharedPreferences.setStringList('user', user.toList());
//    sharedPreferences.setString(
//        'sessionExpire', DateTime.now().add(Duration(days: 30)).toString());
//    sharedPreferences.setString('oauthToken', oauthToken);
  }

  bool isLoggin() {
    return (sharedPreferences.containsKey("user"));
  }

  User getUser() {
    return user;
  }

  logout() {
    sharedPreferences.clear();
  }

//  String getOauthToken() {
//    return oauthToken;
//  }
}
