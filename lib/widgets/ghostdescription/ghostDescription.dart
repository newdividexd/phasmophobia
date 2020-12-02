import 'dart:math';

import 'package:flutter/material.dart';

import 'package:phasmophobiaevidence/model/ghost.dart';
import 'package:phasmophobiaevidence/model/utils.dart';

import 'package:phasmophobiaevidence/widgets/ghostUtils.dart' as utils;

Ghost getOrDefault(Ghost ghost) {
  if (ghost == null) {
    ghost = Ghost.entries[Random().nextInt(Ghost.entries.length)];
  }
  return ghost;
}

class GhostDescription extends StatelessWidget {
  final Ghost _ghost;

  GhostDescription(Ghost ghost) : this._ghost = getOrDefault(ghost);

  Widget buildEvidence(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: utils.buildGhostEvidence(context, this._ghost.evidence),
    );
  }

  List<Widget> buildSection(BuildContext context, MapEntry<String, dynamic> entry) {
    return <Widget>[
      SizedBox(height: 10),
      Padding(
        padding: EdgeInsets.only(left: 10),
        child: Text(entry.key.capitalize, style: Theme.of(context).textTheme.headline6),
      ),
      SizedBox(height: 10),
      if (entry.value is String)
        Padding(
          padding: EdgeInsets.only(left: 20, top: 5),
          child: utils.buildSpan(context, entry.value),
        ),
      if (entry.value is List)
        ...entry.value.map((e) => Padding(
              padding: EdgeInsets.only(left: 20, top: 5),
              child: utils.buildSpan(context, e),
            )),
    ];
  }

  List<Widget> buildSections(BuildContext context) {
    return this._ghost.info.entries.map((entry) => this.buildSection(context, entry)).expand((e) => e).toList();
  }

  List<Widget> buildConditionals(BuildContext context) {
    return this
        ._ghost
        .conditionals
        .map(
          (conditional) => conditional.cases
              .map((current) => [
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text('If ' + current.condition, style: Theme.of(context).textTheme.headline6),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 5),
                      child: utils.buildSpan(context, current.result),
                    ),
                  ])
              .expand((e) => e),
        )
        .expand((e) => e)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            utils.buildGhostNameHeader(context, this._ghost),
            SizedBox(height: 10),
            this.buildEvidence(context),
            SizedBox(height: 10),
            Center(child: utils.buildSpan(context, this._ghost.quote)),
            ...this.buildSections(context),
            ...this.buildConditionals(context),
          ],
        ),
      ),
    );
  }
}
