
final String URL = "http://192.168.1.7:8000/api/";
abstract class ApiCaller{
  dynamic get({userData});
  dynamic getById({Data});
  dynamic getAll({userData,requestData});
  dynamic create({userData,carData,rideData,requestData});
  dynamic update({userData});
  dynamic delete({userData});
}