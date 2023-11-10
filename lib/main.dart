import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stream4u/HomeScreen.dart';
import 'package:stream4u/MovieScreen.dart';
//import 'package:webview_flutter/webview_flutter.dart';
import 'firebase_options.dart';
import 'package:stream4u/onboding_screen.dart';
import 'package:stream4u/testeAPI.dart';
//import 'package:webview_flutter_web/webview_flutter_web.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
 // WebViewPlatform.instance = WebWebViewPlatform();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stream 4U',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFEEF1F8),
        primarySwatch: Colors.blue,
        fontFamily: "Intel",
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          errorStyle: TextStyle(height: 0),
          border: defaultInputBorder,
          enabledBorder: defaultInputBorder,
          focusedBorder: defaultInputBorder,
          errorBorder: defaultInputBorder,
        ),
      ),
      //home: const OnboardingScreen(),
      //home: const testeAPI(),
      home: const HomeScreen(),
      //home: const MovieScreen(),
    );
  }
}

const defaultInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(16)),
  borderSide: BorderSide(
    color: Color(0xFFDEE3F2),
    width: 1,
  ),
);
