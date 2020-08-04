
final String URL = "http://192.168.1.8:8000/api/";
abstract class ApiCaller{
  dynamic get({userData,requestData});
  dynamic getById({Data});
  dynamic getAll({userData,requestData});
  dynamic create({userData,carData,rideData,requestData});
  dynamic update({userData,rideData,requestData});
  dynamic delete({userData,rideData,requestData});
}