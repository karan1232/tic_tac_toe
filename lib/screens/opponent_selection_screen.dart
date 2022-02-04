import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tic_tac_toe/screens/appState.dart';
import 'package:tic_tac_toe/screens/select_side.dart';
import 'package:tic_tac_toe/widgets/button.dart';

import '../constants.dart';

class OpponentSelectionScreen extends ConsumerWidget {
  const OpponentSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,ref) {
    size = MediaQuery.of(context).size;

    return SizedBox(
        height: size.height,
        width: size.width,
        child: SafeArea(
            child: Column(
              children: [
                const Spacer(
                  flex: 1,
                ),
                const Text(
                  "Su",
                  style: TextStyle(
                      color: skyBlue, fontSize: 72, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Tic Tac Toe",
                  style: TextStyle(
                      fontSize: 20, color: orangish, fontWeight: FontWeight.w700),
                ),
                const Spacer(
                  flex: 1,
                ),
                TTTbutton(
                  buttonName: "Play with Bot",
                  onTap: () {
                    ref.read(appState).opponent = PlayAgainst.bot;
                    Navigator.push(context,
                        MaterialPageRoute(builder: (ctx) => const SelectSide(),));
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TTTbutton(
                  buttonName: "Play with friend",
                  buttonColor: orangish,onTap: () {
                  ref.read(appState).opponent = PlayAgainst.human;
                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => const SelectSide()));
                },
                ),
                const Spacer(
                  flex: 2,
                ),
              ],
            )));
  }
}