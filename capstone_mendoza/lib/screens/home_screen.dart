import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'attendance_list_screen.dart';
import 'qr_screen.dart';
import 'scanner_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _idCtrl = TextEditingController(text: '2024-001');

  @override
  void dispose() {
    _idCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance • BSIT 3A')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Teacher', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          FilledButton.icon(
            icon: const Icon(Icons.qr_code),
            label: const Text('Start Session / Generate QR'),
            onPressed: () async {
              final code = await firestoreService.startSession();
              if (!mounted) return;
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => QrScreen(sessionCode: code)));
            },
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.list),
            label: const Text('Attendance List'),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AttendanceListScreen())),
          ),
          const Divider(height: 48),
          Text('Student', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          TextField(
            controller: _idCtrl,
            decoration: const InputDecoration(
              labelText: 'Student ID',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            icon: const Icon(Icons.camera_alt),
            label: const Text('Scan QR to Mark Present'),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ScannerScreen(studentId: _idCtrl.text.trim()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}