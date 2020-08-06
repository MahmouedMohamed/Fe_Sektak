import 'car.dart';

class User {
  String id;
  String nationalId;
  String name;
  String email;
  String phoneNumber;
  Car car;
  String uPhoto;
  double rate;
  int numberOfServices;
  double totalReview;
  User(
      {this.id,
      this.nationalId,
      this.name,
      this.email,
      this.phoneNumber,
      this.car,
      this.rate,
      this.numberOfServices,
      this.totalReview,
      this.uPhoto});

  List<String> toList() {
    return [
      id,
      nationalId,
      name,
      email,
      phoneNumber,
      rate.toString(),
      numberOfServices.toString(),
      totalReview.toString(),
      car == null
          ? [null, null, null, null].toString()
          : car.toList().toString(),
      uPhoto
    ];
  }
}
