class ErrorCreator {
  List<String> getRegisterErrorsFromJson(json) {
    List<String> errors = new List<String>();
    List.generate(9, (index) => errors.add(null));
    List<dynamic> errorDetails = json;
    errorDetails.forEach((errorDetail) {
      if (errorDetail.toString().contains('The name'))
        errors[0] = errorDetail;
      else if (errorDetail.toString().contains('The email'))
        errors[1] = errorDetail;
      else if (errorDetail.toString().contains('The password'))
        errors[2] = errorDetail;
      else if (errorDetail.toString().contains('national id'))
        errors[3] = errorDetail;
      else if (errorDetail.toString().contains('phone number'))
        errors[4] = errorDetail;
      else if (errorDetail.toString().contains('The license'))
        errors[5] = errorDetail;
      else if (errorDetail.toString().contains('model'))
        errors[6] = errorDetail;
      else if (errorDetail.toString().contains('color'))
        errors[7] = errorDetail;
      else if (errorDetail.toString().contains('user license'))
        errors[8] = errorDetail;
    });
    return errors;
  }

  getEditProfileErrorsFromJson(json) {
    List<String> errors = new List<String>();
    List.generate(7, (index) => errors.add(null));
    List<dynamic> errorDetails = json;
    errorDetails.forEach((errorDetail) {
      if (errorDetail.toString().contains('The name'))
        errors[0] = errorDetail;
      else if (errorDetail.toString().contains('phone number'))
        errors[1] = errorDetail;
      else if (errorDetail.toString().contains('model'))
        errors[2] = errorDetail;
      else if (errorDetail.toString().contains('color'))
        errors[3] = errorDetail;
      else if (errorDetail.toString().contains('The license'))
        errors[4] = errorDetail;
      else if (errorDetail.toString().contains('user license'))
        errors[5] = errorDetail;
      else if (errorDetail.toString().contains('The password'))
        errors[6] = errorDetail;
    });
    return errors;
  }
}
