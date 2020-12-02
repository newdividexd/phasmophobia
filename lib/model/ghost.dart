import 'package:phasmophobiaevidence/model/utils.dart';

enum Evidence {
  freezing,
  orbs,
  spirit_box,
  writing,
  emf_5,
  fingerprints,
}

const String _evidenceEnum = "Evidence.";

extension EvidenceExtension on Evidence {
  String get labbel {
    String string = this.toString().substring(_evidenceEnum.length).replaceAll('_', ' ');
    return string.capitalize;
  }
}

class Ghost {
  final String name;
  final String quote;
  final Set<Evidence> evidence;
  final Map<String, dynamic> info;
  final List<Conditional> conditionals;

  static List<Ghost> _entries = List();

  const Ghost(this.name, this.quote, this.evidence, this.info, this.conditionals);

  static List<Ghost> get entries => _entries;

  static set entries(List<Ghost> entries) {
    if (Ghost._entries.isEmpty) {
      Ghost._entries = entries;
    }
  }
}

class Case {
  final String condition;
  final String result;

  Case(this.condition, this.result);
}

class Conditional {
  final List<Case> cases;

  Conditional(this.cases);
}
