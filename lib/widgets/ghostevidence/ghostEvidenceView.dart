import 'package:flutter/material.dart';
import 'package:phasmophobiaevidence/widgets/ghostevidence/evidenceSelector.dart';
import 'package:phasmophobiaevidence/widgets/ghostevidence/ghostListSelector.dart';

class GhostEvidenceView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EvidenceSelector(),
          GhostSelector(),
        ],
      ),
    );
  }
}
