import 'package:flutter/material.dart';

void showCustomSnackBar(String message, BuildContext context, {bool isError = true,int duration = 2}) {

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: isError ? Colors.red : Colors.green,
    content: Text(message),
    duration: Duration(seconds: duration),
  ));
}

