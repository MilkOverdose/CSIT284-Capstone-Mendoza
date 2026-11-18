import 'package:flutter/material.dart';
import 'package:capstone_mendoza/services/app_state.dart';
import 'attendance_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Attendance • ${AppState.I.className}')),
      body: Center(
        child: FilledButton.icon(
          icon: const Icon(Icons.list),
          label: const Text('View Attendance List'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AttendanceListScreen()),
            );
          },
        ),
      ),
    );
  }
}