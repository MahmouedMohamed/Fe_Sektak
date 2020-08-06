import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget textField(String labelText, Color selectedColor, bool status,
    TextInputType type, TextEditingController controller,error,
    [IconData selectedIcon, String hint]) {
  return Padding(
    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
    child: TextField(
      style: GoogleFonts.delius(color: selectedColor),
      controller: controller,
      decoration: InputDecoration(
        errorText: error,
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30)),borderSide: BorderSide(color: Colors.red)),
        errorStyle: TextStyle(color: Colors.red[100]),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30)),borderSide: BorderSide(color: Colors.red)),
        hintText: hint,
        labelText: labelText,
        labelStyle: GoogleFonts.delius(color: selectedColor),
        icon: selectedIcon != null
            ? Icon(
                selectedIcon,
                size: 30,
                color: selectedColor,
              )
            : Icon(selectedIcon, size: 0),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide(color: selectedColor),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: selectedColor),
            borderRadius: BorderRadius.all(Radius.circular(30))),
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
