import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:phasmophobiaevidence/widgets/ghostUtils.dart' as utils;
import 'package:phasmophobiaevidence/notifiers/ghostNotifier.dart';
import 'package:phasmophobiaevidence/widgets/ghostdescription/ghostDescription.dart';
import 'package:phasmophobiaevidence/widgets/ghostevidence/ghostEvidenceView.dart';

class Wide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Evidence')),
      drawer: utils.buildDrawer(context),
      body: LayoutBuilder(
        builder: (context, constraints) => Consumer<GhostNotifier>(
          builder: (context, notifier, child) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: constraints.maxWidth / 2,
                child: GhostEvidenceView(),
              ),
              SizedBox(
                width: constraints.maxWidth / 2,
                child: GhostDescription(notifier.selected),
              )
            ],
          ),
        ),
      ),
    );
  }
}
