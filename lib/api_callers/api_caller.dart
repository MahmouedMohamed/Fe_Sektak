
final String URL = "http://192.168.1.8:8000/api/";
abstract class ApiCaller{
  dynamic get({userData});
  dynamic getAll({userData});
  dynamic create({userData,carData});
  dynamic update({userData});
  dynamic delete({userData});
}