import 'package:flutter/material.dart';
import 'package:capstone_mendoza/models/student.dart';
import 'package:capstone_mendoza/models/dummy_data.dart';

class AppState extends ChangeNotifier {
  static final AppState I = AppState._();
  AppState._();

  final String className = 'BSIT 3A';
  String? sessionId;
  String currentStudentId = '';

  final List<Student> students = dummyStudents;
  void startSession() {
    for (final s in students) {
      s.present = false;
    }
    final d = DateTime.now();
    sessionId =
        'SESSION-${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}-${d.millisecondsSinceEpoch % 100000}';
    notifyListeners();
  }

  String markPresent(String scannedCode) {
    if (sessionId == null || scannedCode != sessionId) {
      return 'Invalid or expired QR code';
    }
    final match = students.where((s) => s.id == currentStudentId);
    if (match.isEmpty) return 'Student ID "$currentStudentId" not in class';
    match.first.present = true;
    notifyListeners();
    return 'Marked present ✓';
  }

  void toggle(Student s) {
    s.present = !s.present;
    notifyListeners();
  }

  void resetAll() {
  for (final s in students) {
    s.present = false;
  }
  notifyListeners();
}
}