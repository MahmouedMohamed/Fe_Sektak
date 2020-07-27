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
//    sessionExpire =
//        DateTime.parse(sharedPreferences.getString('sessionExpire'));
//    if (sessionExpire.isBefore(DateTime.now())) {
      logout();
//    }
    List<String> userData = sharedPreferences.getStringList('user');
    user = new User(
        id: userData[0],
        nationalId: userData[1],
        name: userData[2],
        email: userData[3],
        phoneNumber: userData[4],
        licenseId: userData[5],
        car: Car(userData[6][0], userData[6][1], userData[6][2]),
        uPhoto: userData[7]);
//    oauthToken = sharedPreferences.getString('oauthToken');
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
