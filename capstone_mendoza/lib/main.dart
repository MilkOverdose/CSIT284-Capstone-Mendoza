import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(const AttendanceApp());

class AttendanceApp extends StatelessWidget {
  const AttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance Checker',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const HomeScreen(),
    );
  }
}