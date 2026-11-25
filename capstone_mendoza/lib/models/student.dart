import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String id;
  final String name;
  final bool present;
  final DateTime? timeMarked;

  Student(this.id, this.name, {this.present = false, this.timeMarked});

  factory Student.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return Student(
      doc.id,
      d['name'] ?? '',
      present: d['present'] ?? false,
      timeMarked: (d['timeMarked'] as Timestamp?)?.toDate(),
    );
  }
}