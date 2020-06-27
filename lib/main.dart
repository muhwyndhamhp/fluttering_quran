import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_flutter/services/verses_service.dart';

import 'home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<VerseService>(
          create: (_) => VerseService(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: HomePage(),
      ),
    );
  }
}
