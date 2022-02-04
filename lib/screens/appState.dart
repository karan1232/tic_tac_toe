import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';

final appState = ChangeNotifierProvider((ref) => AppState());

class AppState extends ChangeNotifier
{
  late PlayAgainst opponent;
  PlayerSelectedSymbol selectedSymbol = PlayerSelectedSymbol.x;

  int activePlayer = 1;

  void setActivePlayer(int currentPlayer)
  {
    activePlayer = currentPlayer;
    notifyListeners();
  }
}