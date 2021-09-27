import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:quotes_app/models/quote_model.dart';
import 'package:quotes_app/providers/quote_provider.dart';
import 'package:quotes_app/screens/HomeScreen/home_screen.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Directory directory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(QuoteModelAdapter());
  Box<QuoteModel> quotes = await Hive.openBox<QuoteModel>('quotes');
  runApp(MyApp(
    box: quotes,
  ));
}

class MyApp extends StatelessWidget {
  final Box<QuoteModel> box;
  const MyApp({Key? key, required this.box}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      lazy: false,
      create: (BuildContext context) => QuoteProvider(box),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(),
        home: HomeScreen(),
      ),
    );
  }
}
