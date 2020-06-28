import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:quran_flutter/services/verses_service.dart';

import 'models/verse.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fluttering Quran'),
      ),
      body: Center(
        child: Consumer<VerseService>(
          builder: (context, verseService, child) {
            if (verseService.verseList.isEmpty) {
              verseService.getVerseStartFrom(1, 1);
              return Text('DAFTAR KOSONG!');
            } else {
              return NotificationListener(
                  // ignore: missing_return
                  onNotification: (ScrollNotification scrollInfo) {
                    /// This code below works as pagination mechanism
                    /// before reaching bottom most of the ListView, we shall call
                    /// verseService.getVerseStartFrom()
                    if (scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent - 200)
                      verseService.getVerseStartFrom(
                          verseService.verseList.last.suraID,
                          verseService.verseList.last.verseID + 1);

                    ///This one for listening to the top most ayah on screen,
                    ///used for remembering the last state of the screen, allowing
                    ///for last read feature.
                    ///This feature is using the Metadata Widget to contains the
                    ///verse related to the inflated Child inside it.
                    if (scrollInfo is ScrollEndNotification) {
                      Future.microtask(() {
                        Verse currentVerse = getMeta(0, 40, context);
                        print(
                            "scrollling to ${currentVerse.suraName} ayah ${currentVerse.verseID}");
                      });
                    }
                  },
                  child: ListView.builder(
                    itemCount: verseService.verseList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _listViewItemBuilder(
                          verseService.verseList[index]);
                    },
                  ));
            }
          },
        ),
      ),
    );
  }

  T getMeta<T>(double x, double y, BuildContext context) {
    var renderBox = context.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset(x, y));

    HitTestResult result = HitTestResult();
    WidgetsBinding.instance.hitTest(result, offset);

    for (var i in result.path) {
      if (i.target is RenderMetaData) {
        var d = i.target as RenderMetaData;
        if (d.metaData is T) {
          return d.metaData as T;
        }
      }
    }
    return null;
  }

  _listViewItemBuilder(Verse verse) => verse.verseID != 0
      ? MetaData(
          metaData: verse,
          behavior: HitTestBehavior.translucent,
          child: _listItemVerseBuilder(verse),
        )
      : MetaData(
          metaData: verse,
          behavior: HitTestBehavior.translucent,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Text(verse.suraName),
          ),
        );

  _listItemVerseBuilder(Verse verse) => Card(
          child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Text(
                verse.body,
                textAlign: TextAlign.end,
                style: TextStyle(fontSize: 21),
              ),
            ),
            Text(verse.translationID.replaceAll("\\", "")),
          ],
        ),
      ));
}
