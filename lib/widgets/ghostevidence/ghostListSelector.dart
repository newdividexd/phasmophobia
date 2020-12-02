import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:phasmophobiaevidence/model/ghost.dart';

import 'package:phasmophobiaevidence/widgets/ghostUtils.dart' as utils;
import 'package:phasmophobiaevidence/notifiers/evidenceNotifier.dart';
import 'package:phasmophobiaevidence/notifiers/ghostNotifier.dart';

class GhostSelector extends StatelessWidget {
  void onGhostSelected(BuildContext context, Ghost selected) {
    Provider.of<GhostNotifier>(context, listen: false).onGhost(selected);
  }

  Widget buildGhostEntry(BuildContext context, EvidenceNotifier notifier, Ghost ghost) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Card(
        elevation: 5,
        child: InkWell(
          onTap: () => this.onGhostSelected(context, ghost),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              utils.buildGhostNameHeader(context, ghost),
              Wrap(
                alignment: WrapAlignment.start,
                children: utils.buildGhostEvidence(context, notifier.remaining(ghost)),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                child: utils.buildSpan(context, ghost.quote),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EvidenceNotifier>(
      builder: (context, notifier, child) => Expanded(
          child: ListView(
        children: notifier.viable.map((ghost) => this.buildGhostEntry(context, notifier, ghost)).toList(),
      )),
    );
  }
}
