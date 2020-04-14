import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserLocation{
  Position currentLocation;
  LatLng _latLng;
  Future<Position> locateUser() async {
    return Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
  getUserLocation() async {
    currentLocation = await locateUser();
    _latLng = LatLng(currentLocation.latitude, currentLocation.longitude);
    print('center $_latLng');
  }
  LatLng getLatLng(){
    return _latLng;
  }
  updateLatLng(){
    getUserLocation();
  }
}