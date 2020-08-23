import 'package:flutter/material.dart';
import 'package:tongnyampah/utils/color_theme.dart';

class Styles {
  static const ContainerStyle = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(35.0),
      bottomRight: Radius.circular(35.0),
    ),
    boxShadow: <BoxShadow>[
      BoxShadow(
        offset: Offset(0, -10.0),
        color: Colors.black54,
        blurRadius: 30.0,
      )
    ],
  );

  static const TextFeatureCard = TextStyle(
      fontFamily: 'Poppins-Medium', fontSize: 20.0, color: Colors.white);

  static const TitleTextFieldStyle = TextStyle(
    // color: Color(0xFF070707),
    fontFamily: 'Poppins-Medium',
    fontSize: 16.0,
  );

  static const InputTextFieldStyle = TextStyle(
    // color: Colors.grey,
    fontFamily: 'Poppins-Regular',
    fontSize: 14.0,
  );

  static const HintTextFieldStyle = TextStyle(
    color: Colors.grey,
    fontFamily: 'Poppins-Italic',
    fontSize: 14.0,
  );

  static TextStyle alertTitleStyle = TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w800,
      fontFamily: 'Poppins-Medium');

  static TextStyle alertDescriptionStyle = TextStyle(
      fontSize: 14.0,
      fontFamily: 'Poppins-Regular',
      color: Color.fromRGBO(0, 0, 0, .6));

  static TextStyle alertButtonStyle = TextStyle(
      fontSize: 14.0,
      fontFamily: 'Poppins-Medium',
      color: ThemeApp.bluePrimary);
}
