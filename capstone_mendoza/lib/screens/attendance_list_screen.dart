import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/firestore_service.dart';
import 'add_edit_student_screen.dart';

class AttendanceListScreen extends StatelessWidget {
  const AttendanceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_upload),
            tooltip: 'Load dummy students',
            onPressed: () => firestoreService.seedDummyData(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset all',
            onPressed: () => firestoreService.resetAll(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.person_add),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const AddEditStudentScreen())),
      ),
      body: StreamBuilder<List<Student>>(
        stream: firestoreService.streamStudents(),
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final students = snap.data!;
          if (students.isEmpty) {
            return const Center(
                child: Text('No students yet. Tap the cloud icon to load dummy data.'));
          }
          final present = students.where((s) => s.present).length;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text('Present: $present / ${students.length}',
                    style: Theme.of(context).textTheme.titleMedium),
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
                      onTap: () => firestoreService.setPresent(s.id, !s.present),
                      trailing: PopupMenuButton<String>(
                        onSelected: (v) {
                          if (v == 'edit') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => AddEditStudentScreen(student: s)),
                            );
                          } else {
                            firestoreService.deleteStudent(s.id);
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'edit', child: Text('Edit')),
                          PopupMenuItem(value: 'delete', child: Text('Delete')),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}