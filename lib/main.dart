import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:phasmophobiaevidence/ghostLoad.dart';

import 'package:phasmophobiaevidence/widgets/thin.dart';
import 'package:phasmophobiaevidence/widgets/wide.dart';
import 'package:phasmophobiaevidence/notifiers/evidenceNotifier.dart';
import 'package:phasmophobiaevidence/notifiers/ghostNotifier.dart';
import 'package:phasmophobiaevidence/notifiers/themeNotifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Future.wait<dynamic>([
    loadEntries(),
    SharedPreferences.getInstance(),
  ]).then((value) => runApp(
        ChangeNotifierProvider<ThemeNotifier>(
          create: (context) => ThemeNotifier(value[1]),
          child: PhasmophobiaEvidence(),
        ),
      ));
}

class PhasmophobiaEvidence extends StatelessWidget {
  Widget buildResponsive(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > constraints.maxHeight) {
          return Wide();
        } else {
          return Thin();
        }
      },
    );
  }

  Widget buildNotifiers(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EvidenceNotifier>(create: (context) => EvidenceNotifier()),
        ChangeNotifierProvider<GhostNotifier>(create: (context) => GhostNotifier()),
      ],
      builder: (context, child) => this.buildResponsive(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, notifier, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Phasmophobia Evidence',
        theme: notifier.theme,
        home: buildNotifiers(context),
      ),
    );
  }
}
