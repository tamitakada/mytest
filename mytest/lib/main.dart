import 'dart:io';

import 'package:flutter/material.dart';

import 'package:window_size/window_size.dart';

import 'core/pages/home_page.dart';
import 'test_taking/pages/exam_result.dart';
import 'test_taking/pages/test_page.dart';

import 'constants.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('マイテスト');
    setWindowMinSize(const Size(800, 500));
    setWindowFrame(const Rect.fromLTWH(100, 100, 1000, 650));
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'マイテスト',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Constants.salmon),
        useMaterial3: true,
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Smart',
            fontSize: 32,
            color: Constants.salmon,
          ),
          displayMedium: TextStyle(
            fontFamily: 'Smart',
            fontSize: 30,
            color: Constants.charcoal,
          ),
          displaySmall: TextStyle(
            fontFamily: 'Smart',
            fontSize: 20,
            color: Constants.charcoal,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Smart',
            fontSize: 18,
            color: Constants.charcoal
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Smart',
            fontSize: 14,
            color: Constants.charcoal
          ),
          bodySmall: TextStyle(
            fontFamily: 'Smart',
            fontSize: 12,
            color: Constants.charcoal
          ),
        )
      ),
      routes: {
        '/': (context) => const HomePage(),
        '/exams/lives': (context) => const TestPage(mode: TestMode.lives),
        '/exams/full': (context) => const TestPage(mode: TestMode.full),
        '/exams/practice': (context) => const TestPage(mode: TestMode.practice),
        '/exams/result': (context) => const TestResultPage(),
      },
    );
  }
}
