import 'package:quran_flutter/models/tajweed.dart';

class Verse {
  Verse(
      {this.suraID,
      this.verseID,
      this.suraName,
      this.body,
      this.translationEN,
      this.translationID,
      this.tajweedList});

  int suraID;
  int verseID;
  String suraName;
  String body;
  String translationEN = '';
  String translationID = '';
  List<Tajweed> tajweedList = <Tajweed>[];

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
