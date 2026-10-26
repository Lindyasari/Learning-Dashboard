import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';

// Nama: Ni Komang Tri Lindyasari
// NIM: 2415051017

class AddCoursePage extends StatefulWidget {
  const AddCoursePage({super.key});

  @override
  State<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _titleController = TextEditingController();
  final _creditsController = TextEditingController();
  String _status = 'planned';

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    _creditsController.dispose();
    super.dispose();
  }

  Future<void> _saveCourse() async {
    if (!_formKey.currentState!.validate()) return; // Cek validasi wajib isi & angka

    // Buat objek course baru
    final newCourse = Course(
      id: 0, // API akan membuatkan ID otomatis
      code: _codeController.text,
      title: _titleController.text,
      credits: int.parse(_creditsController.text),
      status: _status,
    );

    final provider = context.read<CourseProvider>();
    final success = await provider.addCourse(newCourse);

    if (!mounted) return; // Mencegah error context di Flutter setelah proses await

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil menambahkan mata kuliah')),
      );
      Navigator.pop(context); // Kembali ke halaman sebelumnya
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: ${provider.error}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<CourseProvider>().isSaving;

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Course')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(labelText: 'Kode Mata Kuliah'),
                validator: (value) => value!.isEmpty ? 'Tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul Mata Kuliah'),
                validator: (value) => value!.isEmpty ? 'Tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _creditsController,
                decoration: const InputDecoration(labelText: 'SKS'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Tidak boleh kosong';
                  if (int.tryParse(value) == null) return 'SKS harus berupa angka';
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                initialValue: _status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: const [
                  DropdownMenuItem(value: 'planned', child: Text('Planned')),
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                  DropdownMenuItem(value: 'done', child: Text('Done')),
                ],
                onChanged: (value) => setState(() => _status = value!),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: isSaving ? null : _saveCourse, // Disable saat isSaving true
                child: isSaving
                    ? const CircularProgressIndicator()
                    : const Text('Simpan Course'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}