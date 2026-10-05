import 'package:flutter/material.dart';

const String studentName = 'Ni Komang Tri Lindyasari';
const String studentId = '2415051017';

void main() {
  runApp(const DebuggingChallengeApp());
}

class DebuggingChallengeApp extends StatelessWidget {
  const DebuggingChallengeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tahap 16 - Debugging',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const DebugChallengeScreen(),
    );
  }
}

class DebugChallengeScreen extends StatefulWidget {
  const DebugChallengeScreen({super.key});

  @override
  State<DebugChallengeScreen> createState() => _DebugChallengeScreenState();
}

class _DebugChallengeScreenState extends State<DebugChallengeScreen> {
  // Flag untuk mencegah Navigasi Ganda (Kasus D)
  bool _isNavigating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 16 - $studentName', style: TextStyle(fontSize: 16)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      // PERBAIKAN KASUS C: SingleChildScrollView membungkus seluruh body
      // agar saat keyboard muncul, layar bisa di-scroll dan tidak overflow.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // KASUS A: RenderFlex Overflow pada Row
            // ==========================================
            const Text('Kasus A: RenderFlex Overflow', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.red.shade50,
              child: Row(
                children: [
                  const Icon(Icons.info, color: Colors.red),
                  const SizedBox(width: 8),
                  // PERBAIKAN KASUS A: Menggunakan Expanded agar teks yang panjang
                  // tidak memakan ruang ke samping tanpa batas, melainkan turun ke baris baru.
                  Expanded(
                    child: Text('$studentId - $studentName - teks ini sengaja dibuat sangat panjang untuk mendemonstrasikan bagaimana widget Expanded dapat menyelamatkan layout Row dari error garis kuning-hitam di ujung layar.'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ==========================================
            // KASUS B: Vertical viewport unbounded height
            // ==========================================
            const Text('Kasus B: Unbounded Height di ListView', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              height: 150, // Container memberikan batas tinggi yang jelas (bounded)
              decoration: BoxDecoration(border: Border.all(color: Colors.deepPurple)),
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.all(8.0), child: Text('Header Kolom')),
                  // PERBAIKAN KASUS B: ListView dibungkus dengan Expanded saat
                  // berada di dalam Column agar tingginya terkalkulasi dengan benar.
                  Expanded(
                    child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return ListTile(
                          dense: true,
                          leading: const Icon(Icons.check_circle_outline),
                          title: Text('Data Item ${index + 1}'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ==========================================
            // KASUS C: Keyboard Overflow
            // ==========================================
            const Text('Kasus C: Keyboard Overflow', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Tap untuk buka keyboard',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // ==========================================
            // KASUS D: Navigasi Ganda
            // ==========================================
            const Text('Kasus D: Navigasi Ganda', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                // PERBAIKAN KASUS D: Tombol dinonaktifkan sementara (null) jika _isNavigating bernilai true
                onPressed: _isNavigating ? null : () async {
                  setState(() { _isNavigating = true; }); // Kunci tombol
                  
                  // Push ke halaman baru
                  await Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const HalamanDummy())
                  );
                  
                  // Buka kunci tombol saat kembali ke layar ini
                  if (mounted) {
                    setState(() { _isNavigating = false; });
                  }
                },
                child: const Text('Buka Halaman (Aman dari Double-Tap)'),
              ),
            ),
            
            // Memberikan jarak ekstra di bawah agar keyboard punya ruang untuk scroll
            const SizedBox(height: 300),
          ],
        ),
      ),
    );
  }
}

class HalamanDummy extends StatelessWidget {
  const HalamanDummy({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman Baru')),
      body: const Center(child: Text('Kembali untuk mencoba lagi.')),
    );
  }
}