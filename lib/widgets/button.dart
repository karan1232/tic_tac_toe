import 'package:flutter/material.dart';

import '../constants.dart';

class TTTbutton extends StatelessWidget {
  const TTTbutton(
      {Key? key,
      this.buttonName = "name",
      this.onTap,
      this.buttonColor = skyBlue})
      : super(key: key);

  final String buttonName;
  final Function()? onTap;
  final Color buttonColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap,child:Container(
      margin: const EdgeInsets.symmetric(horizontal: 64),
      width: size.width,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
          color: buttonColor, borderRadius: BorderRadius.circular(22)),
      child: Center(
          child: Text(
        buttonName,
        style: const TextStyle(color: Colors.white),
      )),
    ));
  }
}
