import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'attendance_list_screen.dart';

class QrScreen extends StatelessWidget {
  final String sessionCode;
  const QrScreen({super.key, required this.sessionCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Session QR')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QrImageView(data: sessionCode, size: 260, backgroundColor: Colors.white),
            const SizedBox(height: 16),
            Text(sessionCode),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AttendanceListScreen())),
              child: const Text('View Live Attendance'),
            ),
          ],
        ),
      ),
    );
  }
}