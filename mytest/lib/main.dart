import 'package:flutter/material.dart';
import 'package:mytest/exams/exam_taking/pages/exam_result.dart';

import 'core/pages/home.dart';
import 'exams/exam_making/pages/pages.dart';
import 'exams/exam_taking/pages/exam.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Constants.lightBlue),
        useMaterial3: true,
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Smart',
            fontSize: 40,
            color: Colors.white,
            shadows: [
              Shadow(color: Constants.yellow, offset: Offset(10, 10))
            ]
          ),
          displayMedium: TextStyle(
            fontFamily: 'Smart',
            fontSize: 30,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Smart',
            fontSize: 24,
            color: Colors.white
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Smart',
            fontSize: 18,
            color: Colors.white,
          ),
          bodySmall: TextStyle(
            fontFamily: 'Smart',
            fontSize: 14,
            color: Colors.white
          ),
        )
      ),
      routes: {
        '/': (context) => const HomePage(),
        '/exams/home': (context) => const ExamHomePage(),
        '/exams': (context) => const ExamPage(),
        '/exams/result': (context) => const ExamResultPage()
      },
    );
  }
}
