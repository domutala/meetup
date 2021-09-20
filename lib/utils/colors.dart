import 'dart:math';
import 'package:flutter/material.dart';

Color xPrimary = Colors.purple.shade400;
Color xLight = Colors.white;
Color xDark = Colors.black;
Color xTransparent = Colors.transparent;

Color randomColor({double alpha = 1}) {
  var r = Random().nextInt(250);
  var g = Random().nextInt(250);
  var b = Random().nextInt(250);

  return Color.fromRGBO(r, g, b, alpha);
}
