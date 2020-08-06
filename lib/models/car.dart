class Car {
  String carLicenseId;
  String licenseId;
  String carModel;
  String color;
  Car(this.carLicenseId, this.carModel, this.color, this.licenseId);
  toList() {
    return [carLicenseId, carModel, color, licenseId];
  }
}
