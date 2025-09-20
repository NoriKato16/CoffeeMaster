import 'package:flutter/material.dart';
import 'package:flutter_lab2/pages/about.dart';
import 'package:logger/logger.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/home_page.dart'; 


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 35, 190, 53),
        ),
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      home: const HomePage(title: 'Coffee Master'),
      //home: ListArtScreen() ,
      //home: ListCreationScreen(),
      //home: AboutScreen(),
    );
  }
}
