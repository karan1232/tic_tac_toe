import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tic_tac_toe/constants.dart';
import 'package:tic_tac_toe/models/game_button.dart';

import 'appState.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
            child: Column(children: [
          Container(
            margin: const EdgeInsets.only(left: 10),
            height: 80,
            width: size.width,
            child: Row(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(Icons.arrow_back_ios),
                    ))
              ],
            ),
          ),
          const CurrentPlayer(),
          const TicTacToe(),
        ])),
      ),
    );
  }
}

class CurrentPlayer extends ConsumerWidget {
  const CurrentPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 60),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                      color: ref.watch(appState).activePlayer == 1
                          ? orangish
                          : Colors.grey,
                      width: ref.watch(appState).activePlayer == 1 ? 4 : 2)),
              child: Image.asset(
                user,
                color: ref.watch(appState).activePlayer == 1
                    ? orangish
                    : Colors.grey,
                height: 40,
              ),
            ),
            const Spacer(),
            const Text(
              "V/S",
              style: TextStyle(fontSize: 22),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                      color: ref.watch(appState).activePlayer == 2
                          ? orangish
                          : Colors.grey,
                      width: ref.watch(appState).activePlayer == 2 ? 4 : 2)),
              child: Image.asset(
                user,
                height: 40,
                color: ref.watch(appState).activePlayer == 2
                    ? orangish
                    : Colors.grey,
              ),
            )
          ],
        ));
  }
}

class TicTacToe extends ConsumerStatefulWidget {
  const TicTacToe({Key? key}) : super(key: key);

  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends ConsumerState<TicTacToe> {
  List winnableSituations = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
    [1, 5, 9],
    [3, 5, 7],
    [1, 4, 7],
    [2, 5, 8],
    [3, 6, 9]
  ];

  late List<GameButton> buttonsList =
      List.generate(9, (index) => GameButton(id: index + 1));
  late List player1 = [];
  late List player2 = [];
  String gameStatus = "";
  Color winnerTextColor = Colors.black;
  int winner = 0;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      IgnorePointer(
          ignoring: ref.read(appState).activePlayer == 2 && ref.read(appState).opponent == PlayAgainst.bot ? true : false,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: size.width * 0.9,
            width: size.width,
            decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage(bg))),
            child: GridView(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: 1),
              children: buttonsList
                  .map((e) => InkWell(
                      onTap: e.enabled ? () => playGame(e) : null,
                      child: Container(
                        color: Colors.white,
                        margin: const EdgeInsets.all(8),
                        child: Center(
                          child: Text(
                            e.text,
                            style: TextStyle(
                                fontSize: 72,
                                color: e.text == "X" ? orangish : skyBlue),
                          ),
                        ),
                      )))
                  .toList(),
            ),
          )),
      const SizedBox(
        height: 60,
      ),
      Text(
        gameStatus,
        style: TextStyle(
            fontSize: 24, fontWeight: FontWeight.w600, color: winnerTextColor),
      )
    ]);
  }

  void playGame(GameButton gb) {
    setState(() {
      if (ref.read(appState).activePlayer == 1) {
        if (ref.read(appState).selectedSymbol == PlayerSelectedSymbol.x) {
          gb.text = "X";
          gb.bg = orangish;
        }
        if (ref.read(appState).selectedSymbol == PlayerSelectedSymbol.o) {
          gb.text = "O";
          gb.bg = skyBlue;
        }

        ref.read(appState).setActivePlayer(2);
        player1.add(gb.id);
      } else {
        if (ref.read(appState).selectedSymbol == PlayerSelectedSymbol.x) {
          gb.text = "O";
          gb.bg = skyBlue;
        }
        if (ref.read(appState).selectedSymbol == PlayerSelectedSymbol.o) {
          gb.text = "X";
          gb.bg = orangish;
        }
        gb.bg = Colors.black;
        ref.read(appState).setActivePlayer(1);
        player2.add(gb.id);
      }
      gb.enabled = false;
       checkWinner();
      if (winner == 0) {
        if (buttonsList.every((p) => p.text != "")) {
          gameStatus = "Game Tied";
        } else if (gameStatus == "") {
          ref.read(appState).activePlayer == 2 &&
                  ref.read(appState).opponent != PlayAgainst.human
              ? autoPlay()
              : null;
        }
      }
    });
  }

  void autoPlay() async {
    var emptyCells = [];
    var list = List.generate(9, (i) => i + 1);
    for (var cellID in list) {
      if (!(player1.contains(cellID) || player2.contains(cellID))) {
        emptyCells.add(cellID);
      }
    }

    var r = Random();
    var randIndex = r.nextInt(emptyCells.length - 1);
    var cellID = emptyCells[randIndex];
    int i = buttonsList.indexWhere((p) => p.id == cellID);
    int wait = Random().nextInt(3);
    await Future.delayed(Duration(seconds: wait));
    playGame(buttonsList[i]);
  }

  void checkWinner() {
    for (List data in winnableSituations) {
      if (player1.contains(data[0]) &&
          player1.contains(data[1]) &&
          player1.contains(data[2])) {
        setState(() {
          winner = 1;
          setColor();
          gameStatus = "Player 1 won";
          disableAllButtons();
        });
      }
      if (player2.contains(data[0]) &&
          player2.contains(data[1]) &&
          player2.contains(data[2])) {
        setState(() {
          winner = 2;
          setColor();
          if(ref.read(appState).opponent == PlayAgainst.bot)
            {
              gameStatus = "Computer won";
            }
          else{gameStatus = "Player 2 won";}
          disableAllButtons();
        });
      }
    }
  }

  void setColor() {
    if(winner != 0)
      {
        if (ref.read(appState).selectedSymbol == PlayerSelectedSymbol.x && winner == 1 ) {
          winnerTextColor = orangish;
        } if(ref.read(appState).selectedSymbol == PlayerSelectedSymbol.o && winner == 1) {
          winnerTextColor = skyBlue;
        }
        if (ref.read(appState).selectedSymbol == PlayerSelectedSymbol.x && winner == 2 ) {winnerTextColor = skyBlue;}
        if(ref.read(appState).selectedSymbol == PlayerSelectedSymbol.o && winner == 2) {winnerTextColor = orangish;}
      }
  }

  void resetGame() {
    setState(() {
      player1 = [];
      player2 = [];
      gameStatus = "";
    });
  }

  void disableAllButtons() {
    buttonsList.forEach((element) {
      element.enabled = false;
    });
  }
}
