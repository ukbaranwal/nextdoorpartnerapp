import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class CustomToast {
  static void show(String message, BuildContext context) {
    return Toast.show(message, context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.BOTTOM,
        backgroundRadius: 5);
  }
}
