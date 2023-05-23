
import 'package:deprem_ve_toplanma_alanlari/widgets/home_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.black,
            appBarTheme: const AppBarTheme(backgroundColor: Colors.black)),
        debugShowCheckedModeBanner: false,
        title: 'Deprem',
        home: const HomePage());
  }
}
