import 'package:flutter/material.dart';

import 'package:phasmophobiaevidence/model/ghost.dart';
import 'package:phasmophobiaevidence/notifiers/evidenceNotifier.dart';
import 'package:provider/provider.dart';

class EvidenceSelector extends StatelessWidget {
  void notify(BuildContext context, void Function(EvidenceNotifier notifier) callback) {
    callback(Provider.of<EvidenceNotifier>(context, listen: false));
  }

  Widget buildButton(EvidenceNotifier notifier, Evidence evidence) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Builder(
        builder: (context) {
          switch (notifier.getState(evidence)) {
            case EvidenceState.Confirmed:
              return RaisedButton(
                child: Text(evidence.labbel),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () => this.notify(context, (notifier) => notifier.unselect(evidence)),
                onLongPress: () => this.notify(context, (notifier) => notifier.discard(evidence)),
              );
            case EvidenceState.Discarded:
              return RaisedButton(
                child: Text(evidence.labbel),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () => this.notify(context, (notifier) => notifier.unselect(evidence)),
                onLongPress: () => this.notify(context, (notifier) => notifier.unselect(evidence)),
              );
            case EvidenceState.Imposible:
              return RaisedButton(
                child: Text(evidence.labbel),
                textColor: Colors.white,
                color: Colors.red[200],
                onPressed: () => null,
                onLongPress: () => this.notify(context, (notifier) => notifier.unselect(evidence)),
              );
            default:
              return RaisedButton(
                child: Text(evidence.labbel),
                color: Theme.of(context).backgroundColor,
                onPressed: () => this.notify(context, (notifier) => notifier.confirm(evidence)),
                onLongPress: () => this.notify(context, (notifier) => notifier.discard(evidence)),
              );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EvidenceNotifier>(
      builder: (context, notifier, child) => Wrap(
        alignment: WrapAlignment.start,
        children: Evidence.values.map((evidence) => this.buildButton(notifier, evidence)).toList(),
      ),
    );
  }
}
