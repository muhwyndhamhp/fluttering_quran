import 'package:flutter/cupertino.dart';
import 'package:quran_flutter/data/database.dart';
import 'package:quran_flutter/models/verse.dart';

class VerseService with ChangeNotifier {
  List<Verse> verseList = <Verse>[];

  void getVerseBySura(int suraID) async {
    final dbHelper = DatabaseHelper.instance;
    verseList = await dbHelper.getVerseBySura(suraID);
    notifyListeners();
  }

  void getVerseStartFrom(int suraID, int verseID) async {
    final dbHelper = DatabaseHelper.instance;
    verseList = await dbHelper.getVersesStartFrom(suraID, verseID);
    notifyListeners();
  }
}
