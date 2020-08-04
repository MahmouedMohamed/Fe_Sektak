import 'package:flutter/material.dart';

Widget textField(labelText,selectedColor, status, type, controller,[selectedIcon,hint]) {
  return Padding(
    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        labelText: labelText,
        labelStyle: TextStyle(color: selectedColor),
        icon: selectedIcon!=null? Icon(
          selectedIcon,
          size: 30,
          color: selectedColor,
        ):Icon(selectedIcon,size: 0),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide(color: selectedColor),
        ),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: selectedColor),
            borderRadius: BorderRadius.all(Radius.circular(30))),
        focusColor: selectedColor,
      ),
      obscureText: status,
      keyboardType: type,
    ),
  );
}
