import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:phasmophobiaevidence/model/ghost.dart';

enum EvidenceState {
  Confirmed,
  Discarded,
  Imposible,
  Unspecified,
}

class EvidenceNotifier extends ChangeNotifier {
  final Set<Evidence> _confirmed = Set();
  final Set<Evidence> _discarded = Set();

  Set<Evidence> _imposible;
  List<Ghost> _viable;

  EvidenceNotifier() {
    this._imposible = Set();
    this._viable = Ghost.entries;
  }

  bool _isViable(Ghost ghost) {
    final Set<Evidence> evidence = ghost.evidence;
    return evidence.containsAll(this._confirmed) && evidence.intersection(this._discarded).isEmpty;
  }

  void update() {
    this._viable = Ghost.entries.where(this._isViable).toList();

    this._imposible = Set();
    this._imposible.addAll(Evidence.values);
    this._imposible.removeAll(this._viable.map((g) => g.evidence).expand((e) => e));
    this._imposible.removeAll(this._confirmed);
    this._imposible.removeAll(this._discarded);

    this.notifyListeners();
  }

  void confirm(Evidence evidence) {
    this._confirmed.add(evidence);
    this._discarded.remove(evidence);
    this.update();
  }

  void discard(Evidence evidence) {
    this._confirmed.remove(evidence);
    this._discarded.add(evidence);
    this.update();
  }

  void unselect(Evidence evidence) {
    this._confirmed.remove(evidence);
    this._discarded.remove(evidence);
    this.update();
  }

  EvidenceState getState(Evidence evidence) {
    if (this._confirmed.contains(evidence)) {
      return EvidenceState.Confirmed;
    } else if (this._discarded.contains(evidence)) {
      return EvidenceState.Discarded;
    } else if (this._imposible.contains(evidence)) {
      return EvidenceState.Imposible;
    } else {
      return EvidenceState.Unspecified;
    }
  }

  UnmodifiableListView<Evidence> remaining(Ghost ghost) {
    return UnmodifiableListView(ghost.evidence.difference(this._confirmed));
  }

  UnmodifiableListView<Ghost> get viable => UnmodifiableListView(_viable);
}
