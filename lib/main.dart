import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:specno_client/Screens/landing_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp],
    );
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      title: 'Office',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: const Color(0xFFFFFFFF),
        ),
        // useMaterial3: true,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.black, // Change cursor color here
        ),
        scaffoldBackgroundColor: Color.fromARGB(255, 247, 255, 254),
      ),
      home: const LandingScreen(),
    );
  }
}
