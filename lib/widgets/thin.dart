import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:phasmophobiaevidence/model/ghost.dart';

import 'package:phasmophobiaevidence/widgets/ghostUtils.dart' as utils;
import 'package:phasmophobiaevidence/notifiers/ghostNotifier.dart';
import 'package:phasmophobiaevidence/widgets/ghostdescription/ghostDescription.dart';
import 'package:phasmophobiaevidence/widgets/ghostevidence/ghostEvidenceView.dart';

class Thin extends StatelessWidget {
  Widget buildEvidence(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Evidence')),
      drawer: utils.buildDrawer(context),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: GhostEvidenceView(),
      ),
    );
  }

  Widget buildGhost(BuildContext context, Ghost ghost) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ghost'),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Provider.of<GhostNotifier>(context, listen: false).onGhost(null);
          },
        ),
      ),
      drawer: utils.buildDrawer(context),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: GhostDescription(ghost),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GhostNotifier>(
      builder: (context, notifier, child) {
        if (notifier.selected == null) {
          return this.buildEvidence(context);
        } else {
          return this.buildGhost(context, notifier.selected);
        }
      },
    );
  }
}
