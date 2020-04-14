import 'package:flutter/material.dart';

Widget textField(labelText, selectedIcon, selectedColor, status, type) {
  return Padding(
    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
    child: TextField(
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: selectedColor),
        icon: Icon(
          selectedIcon,
          size: 30,
          color: selectedColor,
        ),
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
