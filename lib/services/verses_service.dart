import 'package:flutter/cupertino.dart';
import 'package:quran_flutter/data/database.dart';
import 'package:quran_flutter/models/verse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerseService with ChangeNotifier {
  List<Verse> verseList = <Verse>[];
  SharedPreferences pref;
  int scrollIndex = 0;

  void getVerseBySura(int suraID) async {
    final dbHelper = DatabaseHelper.instance;
    verseList = await dbHelper.getVerseBySura(suraID);
    notifyListeners();
  }

  void getOnStartVerseList() async {
    final dbHelper = DatabaseHelper.instance;
    pref = await SharedPreferences.getInstance();

    int suraID = pref.getInt('suraID');
    int verseID = pref.getInt('verseID');

    if (suraID != null) {
      verseList += await dbHelper.getVersesStartFrom(suraID, 1);
    } else {
      verseList += await dbHelper.getVersesStartFrom(1, 1);
    }
    notifyListeners();

    delayedScrollCall(verseID);
  }

  void getVerseStartFrom(int suraID, int verseID) async {
    final dbHelper = DatabaseHelper.instance;

    verseList += await dbHelper.getVersesStartFrom(suraID, verseID);

    notifyListeners();
  }

  void delayedScrollCall(int scrollPosition) async {
    scrollIndex = scrollPosition;
    notifyListeners();
    // Future.delayed(const Duration(milliseconds: 500), () {
    //   scrollIndex = scrollPosition;
    //   notifyListeners();
    // });
  }

  void saveLastReadState(int suraID, int verseID) async {
    if (pref == null) {
      pref = await SharedPreferences.getInstance();
    }
    pref.setInt('suraID', suraID);
    pref.setInt('verseID', verseID);
  }
}
