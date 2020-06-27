import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_flutter/services/verses_service.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final verseService = Provider.of<VerseService>(context, listen: false);
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
              return ListView(
                children:
                    verseService.verseList.map((e) => Text(e.body)).toList(),
              );
            }
          },
        ),
      ),
    );
  }
}
