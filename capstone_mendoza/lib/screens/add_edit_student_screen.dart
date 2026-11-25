import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/firestore_service.dart';

class AddEditStudentScreen extends StatefulWidget {
  final Student? student; // null = add, not null = edit
  const AddEditStudentScreen({super.key, this.student});

  @override
  State<AddEditStudentScreen> createState() => _AddEditStudentScreenState();
}

class _AddEditStudentScreenState extends State<AddEditStudentScreen> {
  late final _idCtrl = TextEditingController(text: widget.student?.id ?? '');
  late final _nameCtrl = TextEditingController(text: widget.student?.name ?? '');

  bool get _isEdit => widget.student != null;

  @override
  void dispose() {
    _idCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final id = _idCtrl.text.trim();
    final name = _nameCtrl.text.trim();
    if (id.isEmpty || name.isEmpty) return;

    if (_isEdit) {
      await firestoreService.updateName(id, name);
    } else {
      await firestoreService.addStudent(id, name);
    }
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit Student' : 'Add Student')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _idCtrl,
              enabled: !_isEdit, // ID is the document key
              decoration: const InputDecoration(
                  labelText: 'Student ID', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                  labelText: 'Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _save, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}