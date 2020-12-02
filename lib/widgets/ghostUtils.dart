import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:phasmophobiaevidence/model/ghost.dart';

import 'package:phasmophobiaevidence/notifiers/themeNotifier.dart';

const List<Color> _accents = [Colors.red, Colors.orange, Colors.yellow, Colors.lime, Colors.green];

Widget buildGhostNameHeader(BuildContext context, Ghost ghost) {
  return Container(
    alignment: Alignment.centerLeft,
    child: Text(ghost.name, style: Theme.of(context).textTheme.headline6),
    decoration: BoxDecoration(
      color: Theme.of(context).backgroundColor,
      borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
    ),
    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
  );
}

List<Widget> buildGhostEvidence(BuildContext context, Iterable<Evidence> evidence) {
  return evidence
      .map((evidence) => Container(
            margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
            padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Text(evidence.labbel),
          ))
      .toList();
}

List<TextSpan> _buildTextSpan(BuildContext context, String part) {
  List<TextSpan> spans = [];
  if (part.contains(']')) {
    List<String> formatted = part.split(']');
    part = formatted[1];
    formatted = formatted[0].split(',');
    spans.add(TextSpan(
      text: formatted[0],
      style: TextStyle(
        color: _accents[int.parse(formatted[1]) + 2],
        fontWeight: FontWeight.bold,
      ),
    ));
  }
  if (part.isNotEmpty) {
    spans.add(TextSpan(text: part, style: Theme.of(context).textTheme.bodyText2));
  }
  return spans;
}

RichText buildSpan(BuildContext context, String format) {
  List<String> parts = format.split('[');
  return RichText(
    text: TextSpan(
      children: parts.map((part) => _buildTextSpan(context, part)).expand((span) => span).toList(),
    ),
  );
}

Drawer buildDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      children: [
        DrawerHeader(child: Text('Options')),
        Row(
          children: [
            SizedBox(width: 10),
            Text('Night mode'),
            SizedBox(width: 10),
            Icon(Icons.wb_sunny),
            Switch(
              onChanged: (value) {
                Provider.of<ThemeNotifier>(context, listen: false).dark = value;
              },
              value: Provider.of<ThemeNotifier>(context, listen: false).dark,
            ),
            Icon(Icons.nights_stay),
          ],
        )
      ],
    ),
  );
}
