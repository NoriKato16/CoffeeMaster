import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'providers/ConfigurationData.dart';
import 'services/notification_service.dart';
import 'pages/splashScreen.dart';

Future<void> _startup() async {
  try {
    
    await NotificationService.instance.init().timeout(const Duration(seconds: 3));
  } catch (_) {
   
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
 
  unawaited(_startup());

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
  final scale = context.watch<ConfigurationData>().textScale; // 0.9..1.4
  return MaterialApp(
    title: 'Coffee Master',
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown)),
    builder: (context, child) {
      final factor = scale.clamp(0.8, 2.0);
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(
  
          textScaler: TextScaler.linear(factor),
        ),
        child: child!,
      );
    },
    home: const SplashScreen(),
  );
}
}