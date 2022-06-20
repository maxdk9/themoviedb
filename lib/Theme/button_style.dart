import 'package:flutter/material.dart';

class AppButtonStyle{
  static const Color frameColor = const Color(0xFF01B4E4);
  static final ButtonStyle linkButtonStyle= ButtonStyle(
    foregroundColor: MaterialStateProperty.all(frameColor),
    textStyle: MaterialStateProperty.all(
        const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
  );
}