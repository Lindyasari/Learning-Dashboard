import 'package:flutter/material.dart';

const String studentName = 'Ni Komang Tri Lindyasari';
const String studentId = '2415051017';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _komentarController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _komentarController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      setState(() => _isLoading = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _komentarController.clear();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Feedback berhasil dikirim!'), backgroundColor: Colors.green),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const CircleAvatar(radius: 40, backgroundColor: Colors.deepPurple, child: Icon(Icons.person, size: 40, color: Colors.white)),
          const SizedBox(height: 16),
          const Text(studentName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Text('NIM: $studentId', style: TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 32),
          
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Kirim Feedback', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _komentarController,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Tulis Komentar (Min. 5 karakter)', border: OutlineInputBorder()),
                      validator: (value) => (value == null || value.trim().isEmpty) ? 'Wajib diisi' : (value.length < 5 ? 'Minimal 5 karakter' : null),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity, height: 45,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
                        child: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}