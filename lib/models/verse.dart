class Verse {
  Verse(
      {this.suraID,
      this.verseID,
      this.suraName,
      this.body,
      this.translationEN,
      this.translationID});

  int suraID;
  int verseID;
  String suraName;
  String body;
  String translationEN = '';
  String translationID = '';

  factory Verse.fromMap(Map<String, dynamic> map) => Verse(
      suraID: map['suraID'],
      verseID: map['verseID'],
      suraName: map['suraName'],
      body: map['body'],
      translationEN: map['translationEN'],
      translationID: map['translationID']);

  Map<String, dynamic> toMap() => {
        'suraID': suraID,
        'verseID': verseID,
        'suraName': suraName,
        'body': body,
        'translationEN': translationEN,
        'translationID': translationID
      };
}
