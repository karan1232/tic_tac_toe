import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tic_tac_toe/screens/game_screen.dart';
import 'package:tic_tac_toe/widgets/button.dart';

import '../constants.dart';
import 'appState.dart';

class SelectSide extends ConsumerWidget {
  const SelectSide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Material(
        child: SafeArea(
            child: Container(
      height: size.height,
      width: size.width,
      color: Colors.white,
      child: Column(
        children: [
          ClipPath(
              clipper: CurveClipper(),
              child: Container(
                width: size.width,
                height: size.width * 0.46,
                child: Row(children: [const Spacer(),FittedBox(fit: BoxFit.scaleDown,child: Text(
                  "Against ${ref.read(appState).opponent == PlayAgainst.human ? "Human" : "Computer"}",
                  style:  TextStyle(color: Colors.white,fontSize: size.width * 0.1),
                ),),const Spacer()],),
                color: skyBlue,
              )),
          const SizedBox(
            height: 32,
          ),
          const Text("Choose your side"),
          const Spacer(),
          const ChooseSymbol(),
          const Spacer(),
          TTTbutton(
            buttonName: "Start Game",
            buttonColor: orangish,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const GameScreen()));
            },
          ),
          const SizedBox(height: 40)
        ],
      ),
    )));
  }
}

class ChooseSymbol extends ConsumerStatefulWidget {
  const ChooseSymbol({Key? key}) : super(key: key);

  @override
  _ChooseSymbolState createState() => _ChooseSymbolState();
}

class _ChooseSymbolState extends ConsumerState<ChooseSymbol> {
  int selectedSymbol = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
                child: GestureDetector(
                    onTap: () {
                      toggle(0);
                      ref.read(appState).selectedSymbol = PlayerSelectedSymbol.x;
                      ref.read(appState).selectedSymbol;
                    },
                    child: Image.asset(
                      x,
                      color: selectedSymbol == 0 ? orangish : Colors.grey,
                      height: 80,
                    ))),
            Expanded(
                child: GestureDetector(
                    onTap: () {
                      toggle(1);
                      ref.read(appState).selectedSymbol = PlayerSelectedSymbol.o;
                      ref.read(appState).selectedSymbol;
                    },
                    child: Image.asset(
                      o,
                      color: selectedSymbol == 1 ? skyBlue : Colors.grey,
                      height: 80,
                    )))
          ],
        ));
  }

  toggle(int newNumber) {
    setState(() {
      selectedSymbol = newNumber;
    });
  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    int curveHeight = 24;
    Offset controlPoint = Offset(size.width / 2, size.height + curveHeight);
    Offset endPoint = Offset(size.width, size.height - curveHeight);

    Path path = Path()
      ..lineTo(0, size.height - curveHeight)
      ..quadraticBezierTo(
          controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
