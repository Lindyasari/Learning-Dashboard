# Course Data Manager (Mini Project Integrasi)

**Nama**: Ni Komang Tri Lindyasari  
**NIM**: 2415051017  

## Deskripsi Aplikasi
Course Data Manager adalah aplikasi pengelolaan katalog mata kuliah yang dibangun menggunakan Flutter. Aplikasi ini merupakan puncak pengembangan dari Course Explorer v2 yang kini dilengkapi dengan integrasi fitur CRUD (Create, Read, Update, Delete) penuh, navigasi responsif, *state management* terpusat, serta penanganan *error state* yang tangguh.

## Cara Menjalankan
1. Pastikan Flutter SDK sudah terpasang di sistem.
2. Clone repository ini: `git clone https://github.com/Lindyasari/Learning-Dashboard.git`
3. Buka terminal di folder proyek dan jalankan `flutter pub get` untuk mengunduh dependensi.
4. Jalankan aplikasi pada emulator atau perangkat fisik menggunakan perintah `flutter run`.

## Tanggung Jawab Layer / Folder (Arsitektur)
Aplikasi ini telah diaudit dan mengimplementasikan *Clean Architecture* (*Separation of Concerns*) dengan arah dependensi yang ketat: `Screen/Widget -> Provider -> Repository -> Service/Data Source`.
- **`models/`**: Menyimpan cetakan objek struktur data (`Course`).
- **`services/`**: Menangani detail teknis pengambilan data mentah dan komunikasi langsung dengan *backend* (API/BaaS).
- **`repositories/`**: Menyediakan lapisan abstraksi (*interface*) yang menghubungkan sumber data dengan pengelola *state*.
- **`providers/`**: Mengelola *business logic* dan *async state* (loading, empty, error, success) sebagai *Single Source of Truth* tanpa menyimpan `BuildContext`.
- **`screens/`**: Berisi halaman-halaman antarmuka utama yang hanya bereaksi terhadap perubahan *state* dari Provider.
- **`widgets/`**: Berisi potongan-potongan komponen UI (*reusable components*).

## Backend & Data Source yang Digunakan
- **Active Backend (Tahap 16-18)**: Aplikasi ini saat ini terintegrasi penuh dengan **Supabase** (PostgreSQL) sebagai *Backend as a Service* (BaaS) untuk menangani operasi database *real-time* dan penyimpanan data persisten secara aman menggunakan *publishable key*.
- **Catatan REST API (Historis Tahap 1)**: Sebelumnya melakukan *fetching* data dasar melalui endpoint `https://course-api-pearl.vercel.app/courses` dengan HTTP Method GET (200 OK) yang menghasilkan JSON field: `id`, `code`, `title`, `credits`, dan `status`.