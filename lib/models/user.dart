import 'car.dart';

class User {
  String id;
  String nationalId;
  String name;
  String email;
  String phoneNumber;
  String licenseId;
  Car car;
  String uPhoto;
  User(
      {this.id,
      this.nationalId,
      this.name,
      this.email,
      this.phoneNumber,
      this.licenseId,
      this.car,
      this.uPhoto});

  List<String> toList() {
    return [
      id,
      nationalId,
      name,
      email,
      phoneNumber,
      licenseId,
      car.toList(),
      uPhoto
    ];
  }
}
