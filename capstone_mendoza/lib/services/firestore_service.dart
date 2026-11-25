import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:capstone_mendoza/models/student.dart';
import '../models/dummy_data.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _students =>
      _db.collection('students');
  CollectionReference<Map<String, dynamic>> get _sessions =>
      _db.collection('sessions');

  // ---------- CREATE ----------
  Future<void> addStudent(String id, String name) {
    return _students.doc(id).set({
      'name': name,
      'present': false,
      'timeMarked': null,
    });
  }

  // ---------- READ ----------
  Stream<List<Student>> streamStudents() {
    return _students
        .orderBy('name')
        .snapshots()
        .map((snap) => snap.docs.map(Student.fromDoc).toList());
  }

  Future<bool> studentExists(String id) async =>
      (await _students.doc(id).get()).exists;

  // ---------- UPDATE ----------
  Future<void> updateName(String id, String name) =>
      _students.doc(id).update({'name': name});

  Future<void> setPresent(String id, bool present) {
    return _students.doc(id).update({
      'present': present,
      'timeMarked': present ? FieldValue.serverTimestamp() : null,
    });
  }

  Future<void> resetAll() async {
    final snap = await _students.get();
    final batch = _db.batch();
    for (final d in snap.docs) {
      batch.update(d.reference, {'present': false, 'timeMarked': null});
    }
    await batch.commit();
  }

  // ---------- DELETE ----------
  Future<void> deleteStudent(String id) => _students.doc(id).delete();

  // ---------- SEED DUMMY DATA ----------
  Future<void> seedDummyData() async {
    final batch = _db.batch();
    for (final s in dummyStudents) {
      batch.set(_students.doc(s.id), {
        'name': s.name,
        'present': false,
        'timeMarked': null,
      });
    }
    await batch.commit();
  }

  // ---------- SESSION WORKFLOW ----------
  Future<String> startSession() async {
    // close old sessions
    final old = await _sessions.where('active', isEqualTo: true).get();
    for (final d in old.docs) {
      await d.reference.update({'active': false});
    }
    await resetAll();

    final now = DateTime.now();
    final code =
        'SESSION-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${now.millisecondsSinceEpoch % 100000}';
    await _sessions.doc(code).set({
      'active': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return code;
  }

  /// Called by the student's scanner. Returns a message to show.
  Future<String> markPresentFromScan(String studentId, String code) async {
    final session = await _sessions.doc(code).get();
    if (!session.exists || session.data()?['active'] != true) {
      return 'Invalid or expired QR code';
    }
    if (!await studentExists(studentId)) {
      return 'Student ID "$studentId" not found';
    }
    await setPresent(studentId, true);
    return 'Marked present ✓';
  }
}

final firestoreService = FirestoreService();