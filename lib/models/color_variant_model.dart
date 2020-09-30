import 'package:flutter/material.dart';

class ColorVariantModel {
  String name;
  Color hexCodeColor;
  ColorVariantModel.fromJson(Map<String, dynamic> parsedJson) {
    name = parsedJson['name'];
    hexCodeColor = _hexToColor(parsedJson['hex_code']);
  }

  Color _hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}
