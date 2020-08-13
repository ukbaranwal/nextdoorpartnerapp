import 'package:flutter/material.dart';

class WalkThroughModel {
  Color _color;
  String _heading;
  String _subHeading;
  String _assetImagePath;

  WalkThroughModel(
      this._color, this._heading, this._subHeading, this._assetImagePath);

  String get assetImagePath => _assetImagePath;

  String get subHeading => _subHeading;

  String get heading => _heading;

  Color get color => _color;
}
