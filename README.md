# Course Explorer v2 - State Management & Architecture

**Nama**: Ni Komang Tri Lindyasari  
**NIM**: 2415051017  

## Tanggung Jawab Layer / Folder
Aplikasi ini telah diaudit dan mengimplementasikan *Separation of Concerns* dengan arah dependensi yang ketat: `Screen/Widget -> Provider -> Repository -> Service/Data Source`.

* **`models/`**: Menyimpan cetakan objek struktur data (`Course`).
* **`services/`**: Menangani detail teknis pengambilan data mentah (parsing JSON dari `rootBundle`).
* **`repositories/`**: Menyediakan lapisan abstraksi (*interface*) antara sumber data dan pengelola *state*.
* **`providers/`**: Mengelola *business logic* dan *async state* (loading, error, success) sebagai Single Source of Truth tanpa menyimpan `BuildContext`.
* **`screens/`**: Berisi halaman-halaman antarmuka utama yang hanya bereaksi terhadap perubahan *state* dari Provider.
* **`widgets/`**: Berisi potongan-potongan komponen UI yang dapat digunakan berulang kali.