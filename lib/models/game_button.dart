import 'package:flutter/material.dart';

class GameButton {
  int id;
  String text;
  Color bg;
  bool enabled;

  GameButton(
      {this.id = 0, this.text = "", this.bg = Colors.grey, this.enabled = true});
}