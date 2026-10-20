import 'package:flutter/material.dart';

import 'catalog_page.dart';
import 'store.dart';

void main() => runApp(GemStoreApp());

class GemStoreApp extends StatelessWidget {
  GemStoreApp({super.key, Store? store}) : store = store ?? Store();
  final Store store;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'GemStore',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF3A2C27),
        primary: const Color(0xFF3A2C27),
        surface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF6F5F3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    ),
    home: CatalogPage(store: store),
  );
}
