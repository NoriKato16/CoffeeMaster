import 'package:flutter/material.dart';
import 'package:flutter_lab2/pages/about.dart';
import 'package:logger/logger.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/home_page.dart'; 
import 'pages/splashScreen.dart';
import 'package:flutter/material.dart';
import 'services/notification_service.dart';
import 'providers/ConfigurationData.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ConfigurationData(),
      child: const MyApp(),
    ),
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.brown,
        ),
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      home: const SplashScreen(),
  
    );
  }
}
