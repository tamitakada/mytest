import 'package:flutter/material.dart';
import 'package:mytest/exams/exam_taking/pages/exam_result.dart';

import 'core/pages/home_page.dart';
import 'exams/exam_making/pages/pages.dart';
import 'exams/exam_taking/pages/pages.dart';

import 'constants.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
            color: Colors.white,
          ),
          displaySmall: TextStyle(
            fontFamily: 'Smart',
            fontSize: 20,
            color: Constants.white,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Smart',
            fontSize: 18,
            color: Colors.white
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
        '/exams/home': (context) => const ExamHomePage(),
        '/exams/lives': (context) => const LivesExamPage(),
        '/exams/full': (context) => const FullExamPage(),
        '/exams/infinite': (context) => const FullExamPage(),
        '/exams/result': (context) => const ExamResultPage(),
        '/exams/timed': (context) => const TimedExamPage()
      },
    );
  }
}
