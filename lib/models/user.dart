import 'car.dart';

class User {
  String id;
  String nationalId;
  String name;
  String email;
  String phoneNumber;
  String licenseID;
  Car car;
  String uPhoto;
  User(
  {this.id,
        this.nationalId,
        this.name,
        this.email,
        this.phoneNumber,
        this.licenseID,
        this.car,
        this.uPhoto
});
}
