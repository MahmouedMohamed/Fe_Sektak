class Car{
  String carLicenseId;
  String carModel;
  String color;
  Car(this.carLicenseId,this.carModel,this.color);

  toList() {
    return [carLicenseId,carModel,color];
  }
}