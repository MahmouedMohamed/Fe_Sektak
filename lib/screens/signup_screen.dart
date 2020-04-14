import 'dart:io';

import 'package:connection_status_bar/connection_status_bar.dart';
import 'package:fe_sektak/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  List<String> countries = ['Egypt'];
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _selectedCountry;
  bool hasCar = false;
  Future<File> imageFile;
  String _path = "";
  Future<File> pickImageFromGallery(ImageSource source) {
    return imageFile = ImagePicker.pickImage(source: source);
  }

  _getPath(ImageSource source) async {
    final file =
        await pickImageFromGallery(source); // the method return Future<File>
    setState(() {
      _path = file.path;
    });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
//          return Image.file(
//            snapshot.data,
//            width: 300,
//            height: 300,
//          );
          return Text('${_path}');
        } else if (snapshot.error != null) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _dropDownMenuItems = buildDropDownMenuItems(countries);
    _selectedCountry = _dropDownMenuItems[0].value;
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
            ConnectionStatusBar(),
            Image.asset(
              'assets/images/road.png',
              alignment: Alignment.topCenter,
              fit: BoxFit.scaleDown,
              scale: 2.5,
            ),
            textField('Full name', Icons.person, Colors.blue, false, null),
            textField('Email', Icons.email, Colors.blue, false, null),
            textField('Password', Icons.lock, Colors.blue, true, null),
            textField('Mobile Number', Icons.mobile_screen_share, Colors.blue,
                false, TextInputType.number),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Text('Country :'),
              SizedBox(
                width: 10,
              ),
              DropdownButton(
                value: _selectedCountry,
                items: _dropDownMenuItems,
                onChanged: onChangedDropdownItem,
                icon: Icon(Icons.arrow_drop_down),
              )
            ]),
            CheckboxListTile(
              title: Text('Has a Car? '),
              value: hasCar,
              onChanged: onChange,
              secondary: const Icon(Icons.directions_car),
              subtitle: Text('Yes'),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Visibility(
                  child: RaisedButton(
                    child: Text("Select Image from Gallery"),
                    onPressed: () {
//                    _getPath(ImageSource.gallery);           /////////////////////////////to begin in back end
                    },
                  ),
                  visible: hasCar ? true : false,
                ),
//                showImage()                      /////////////////////////////to begin in back end
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.file_upload,
                    semanticLabel: 'haffd',
                  ),
                  onPressed: () {
//                    _getPath(ImageSource.gallery);           /////////////////////////////to begin in back end
                  },
                ),
                Text('Click Here To upload Your National ID'),
              ],
            ),
            RaisedButton(
              onPressed: () {},
              child: Text('Signup'),
            )
          ],
        ),
      ))),
    );
  }

  onChangedDropdownItem(String selectedCountry) {
    setState(() {
      _selectedCountry = selectedCountry;
    });
  }
}
