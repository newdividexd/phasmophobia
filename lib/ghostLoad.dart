import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:phasmophobiaevidence/model/ghost.dart';

const String _evidenceEnum = "Evidence.";

List<T> _parseEntries<T>(dynamic entryDef, T Function(dynamic) parseEntry) {
  if (entryDef is List) {
    return entryDef.map(parseEntry).toList();
  } else {
    return [parseEntry(entryDef)];
  }
}

MapEntry<String, dynamic> _parseInfo(String entryName, dynamic entryDef) {
  dynamic value;
  switch (entryName) {
    case "power":
      value = entryDef.toString();
      break;
    case "strengths":
    case "weaknesses":
    case "data":
      value = _parseEntries(entryDef, (entry) => entry.toString());
      break;
  }
  return MapEntry(entryName, value);
}

void _resolveKey(String reference, int brk, Map<String, dynamic> data) {
  int brkend = reference.lastIndexOf(']');
  String key = reference.substring(brk + 1, brkend);
  String subReference = reference.substring(0, brk);
  dynamic subData = _resolve(subReference, data);
  if (subData is List) {
    data[reference] = subData[int.parse(key)];
  } else if (subData is Map) {
    data[reference] = subData[key];
  }
}

dynamic _resolve(String reference, Map<String, dynamic> data) {
  if (!data.containsKey(reference)) {
    int brk = reference.lastIndexOf('[');
    if (brk != -1) {
      _resolveKey(reference, brk, data);
    } else {
      throw ArgumentError('$reference not in ${data.keys.toList()}');
    }
  }
  return data[reference];
}

String _parseReplace(String format, Map<String, dynamic> data) {
  String result = format;
  String reference;
  dynamic value;
  while (result.indexOf('\${') != -1) {
    int start = result.indexOf('\${');
    int end = result.indexOf('}');
    reference = result.substring(start + 2, end);
    value = _resolve(reference, Map.from(data));
    if (value is List) {
      value = value[0];
    }
    result = result.substring(0, start) + value + result.substring(end + 1);
  }
  return result;
}

Conditional _parseConditional(dynamic conditionalDef) {
  String condition = conditionalDef['condition'];
  List<Case> cases = List<Case>.from(conditionalDef['cases'].map((current) {
    String caseCondition = _parseReplace(condition, {
      'case': current['value'],
    });
    return Case(caseCondition, current['result']);
  }));
  return Conditional(cases);
}

List<Conditional> _parseConditionals(dynamic conditionals) {
  if (conditionals == null) {
    return [];
  } else {
    return _parseEntries(conditionals, _parseConditional);
  }
}

Evidence parseEvidence(dynamic evidence) {
  String evidenceName = evidence.toString();
  if (!evidenceName.startsWith(_evidenceEnum)) {
    evidenceName = _evidenceEnum + evidenceName;
  }
  return Evidence.values.firstWhere((e) => e.toString() == evidenceName);
}

Future<void> loadEntries() async {
  if (Ghost.entries.isNotEmpty) {
    return Future.value();
  } else {
    final data = await rootBundle.loadString('assets/ghostEntries.json');
    List<dynamic> ghostsDef = json.decode(data);
    Ghost.entries = ghostsDef.map((ghostDef) {
      String name = ghostDef['name'];
      Set<Evidence> evidence = Set<Evidence>.from(ghostDef['evidence'].map(parseEvidence));
      Map<String, dynamic> info = Map<String, dynamic>.from(ghostDef['info'].map(_parseInfo));
      String quote = _parseReplace(ghostDef['quote'], info);
      List<Conditional> conditionals = _parseConditionals(ghostDef['conditionals']);
      return Ghost(name, quote, evidence, info, conditionals);
    }).toList();
  }
}
