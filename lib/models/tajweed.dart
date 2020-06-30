class Tajweed {
  Tajweed({this.suraID, this.verseID, this.start, this.end, this.rule});

  int suraID;
  int verseID;
  int start;
  int end;
  String rule;

  factory Tajweed.fromJSON(Map<String, dynamic> map, int suraID, int verseID) {
    return Tajweed(
        suraID: suraID,
        verseID: verseID,
        start: map['start'],
        end: map['end'],
        rule: map['rule']);
  }

  factory Tajweed.fromMap(Map<String, dynamic> map) {
    return Tajweed(
        suraID: map['suraID'],
        verseID: map['verseID'],
        start: map['start'],
        end: map['end'],
        rule: map['rule']);
  }

  Map<String, dynamic> toMap() {
    return {
      'suraID': suraID,
      'verseID': verseID,
      'start': start,
      'end': end,
      'rule': rule
    };
  }
}
