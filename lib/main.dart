import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_demo/data/db_helper.dart';
import 'package:sqlite_demo/data/db_provider.dart';
import 'package:sqlite_demo/data/theme_provider.dart';
import 'package:sqlite_demo/pages/home_page.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => DBProvider(
        dbHelper: DBHelper.getInstance,
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: context.watch<ThemeProvider>().getThemeData()
          ? ThemeMode.dark
          : ThemeMode.light,
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ).copyWith(
        textTheme: GoogleFonts.josefinSansTextTheme(),
      ),
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.josefinSansTextTheme(),
      ),
      home: const HomePage(),
    );
  }
}
