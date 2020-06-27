import 'dart:io';
import 'package:fe_sektak/api_callers/post.dart';
import 'package:fe_sektak/models/car.dart';
import 'package:fe_sektak/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';
import 'package:image_picker/image_picker.dart';
class SignupScreen extends StatefulWidget {
  static const String id='SignUp_Screen';
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool hasCar = false;
  File carImage;
  File idImage;
  TextEditingController fullName = new TextEditingController();
  TextEditingController nationalId = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController mobileNumber = new TextEditingController();
  TextEditingController carNumber = new TextEditingController();
  TextEditingController carColor = new TextEditingController();
  TextEditingController carModel = new TextEditingController();
  TextEditingController licenceId = new TextEditingController();
  Future<File> pickImageFromGallery(ImageSource source) {
    return ImagePicker.pickImage(source: source);
  }

  getPath(kind,ImageSource source) async {
    kind=='car'?
    this.carImage =
        await pickImageFromGallery(source):
    this.idImage =
        await pickImageFromGallery(source);
  }

  @override
  void initState() {
    super.initState();
  }

  void onChange(bool status) {
    setState(() {
      hasCar = status;
    });
  }

  List<DropdownMenuItem<String>> buildDropDownMenuItems(List countries) {
    List<DropdownMenuItem<String>> list = List();
    for (String country in countries) {
      list.add(
        DropdownMenuItem(
          value: country,
          child: Text(country),
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Material(
          child: SingleChildScrollView(
              child: Container(
        color: Colors.white,
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(top: 30, bottom: 20),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            Image.asset(
              'assets/images/road.png',
              alignment: Alignment.topCenter,
              fit: BoxFit.scaleDown,
              scale: 2.5,
            ),
            textField('Full name', Icons.person, Colors.blue, false, null,fullName),
            textField('Email', Icons.email, Colors.blue, false, null,email),
            textField('Password', Icons.lock, Colors.blue, true, null,password),
            textField('Mobile Number', Icons.mobile_screen_share, Colors.blue,
                false, TextInputType.number,mobileNumber),
            textField('National ID', Icons.mobile_screen_share, Colors.blue,
                false, TextInputType.number,nationalId),
            CheckboxListTile(
              title: Text('Have a Car? '),
              value: hasCar,
              onChanged: onChange,
              secondary: const Icon(Icons.directions_car),
              controlAffinity: ListTileControlAffinity.leading,
            ),
                Visibility(
                  child: Column(
                children: <Widget>[
                  RaisedButton(
                    child: Text("Upload Car ID from Gallery"),
                    onPressed: () async {
                      getPath('car',ImageSource.gallery);           /////////////////////////////to begin in back end
                    },
                  ),
                  textField('Licence ID', Icons.directions_car, Colors.blue, false, null,licenceId),
                  textField('Car Number', Icons.directions_car, Colors.blue, false, null,carNumber),
                  textField('Car Color', Icons.color_lens, Colors.blue, false, null,carColor),
                  textField('Car Model', Icons.local_car_wash, Colors.blue, false, null,carModel),
                ],
                  ),
                  visible: hasCar ? true : false,
                ),
//                showImage()                      /////////////////////////////to begin in back end

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.file_upload,
                  ),
                  onPressed: () {
                    getPath('id',ImageSource.gallery);           /////////////////////////////to begin in back end
                  },
                ),
                Text('Click Here To upload Your National ID'),
              ],
            ),
            RaisedButton(
              onPressed: () async {
                String status= await register(
                  fullName.text,
                  email.text,
                  password.text,
                  mobileNumber.text,
                  nationalId.text,
                  licenceId.text,
                  new Car(
                    carNumber.text,
                    carColor.text,
                    carModel.text
                  ),
                  carImage,
                  idImage
                );
                if(status=='done'){
                  /// Navigate to login page
                }
                else{
                  /// Toast Or Show Errors
                }
              },
              child: Text('Signup'),
            )
          ],
        ),
      ))),
    );
  }
}
