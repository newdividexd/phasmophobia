import 'package:flutter/material.dart';

import 'package:phasmophobiaevidence/model/ghost.dart';

class GhostNotifier extends ChangeNotifier {
  Ghost _selected;

  void onGhost(Ghost selected) {
    this._selected = selected;
    this.notifyListeners();
  }

  Ghost get selected => _selected;
}
