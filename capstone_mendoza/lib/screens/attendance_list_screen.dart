import 'package:flutter/material.dart';
import 'package:capstone_mendoza/services/app_state.dart';

class AttendanceListScreen extends StatelessWidget {
  const AttendanceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance List')),
      body: ListenableBuilder(
        listenable: AppState.I,
        builder: (context, _) {
          final students = AppState.I.students;
          final present = students.where((s) => s.present).length;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text('Present: $present / ${students.length}'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (_, i) {
                    final s = students[i];
                    return ListTile(
                      leading: Icon(
                        s.present ? Icons.check_circle : Icons.cancel_outlined,
                        color: s.present ? Colors.green : Colors.grey,
                      ),
                      title: Text(s.name),
                      subtitle: Text(s.id),
                      trailing: Text(s.present ? 'Present' : 'Absent'),
                      onTap: () => AppState.I.toggle(s),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}