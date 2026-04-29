# 📱 Habit Tracker App

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.9.2-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)

**Aplikasi pelacak kebiasaan harian berbasis Flutter dengan tampilan modern dan fitur lengkap.**

</div>

---

## 📖 Deskripsi

**Habit Tracker App** adalah aplikasi mobile yang dirancang untuk membantu pengguna membangun dan mempertahankan kebiasaan positif setiap hari. Aplikasi ini dibangun menggunakan **Flutter** dengan arsitektur **MVC (Model-View-Controller)** menggunakan **GetX** sebagai state management.

Aplikasi ini mendukung dua bahasa (**Bahasa Indonesia** dan **English**), dua tema tampilan (**Light & Dark Mode**), penyimpanan lokal menggunakan **SQLite**, serta notifikasi pengingat harian. Cocok digunakan sebagai alat bantu produktivitas sehari-hari.

---

## ✨ Fitur Utama

- ✅ **Tambah, Edit & Hapus Kebiasaan** — Kelola daftar kebiasaan dengan mudah
- 📊 **Statistik & Progress** — Visualisasi perkembangan kebiasaan menggunakan grafik (`fl_chart`)
- 🔥 **Streak Tracking** — Hitung streak harian dan streak terbaik secara otomatis
- 🔔 **Notifikasi Harian** — Pengingat otomatis menggunakan `flutter_local_notifications`
- 🌙 **Dark Mode / Light Mode** — Tema terang dan gelap yang bisa diubah di pengaturan
- 🌐 **Multi-bahasa** — Mendukung Bahasa Indonesia dan English
- 📂 **Kategori Kebiasaan** — Kelompokkan kebiasaan berdasarkan kategori
- 🕓 **Riwayat Kebiasaan** — Lihat rekam jejak penyelesaian kebiasaan
- 👤 **Profil Pengguna** — Simpan nama dan jurusan pengguna
- 📖 **Panduan Penggunaan** — Halaman petunjuk penggunaan aplikasi
- 🔍 **Fitur Pencarian** — Cari kebiasaan berdasarkan nama

---

## 🛠️ Dependencies

### Production Dependencies

| Package | Versi | Fungsi |
|---|---|---|
| `get` | ^4.6.6 | State management, routing, dan dependency injection |
| `sqflite` | ^2.3.0 | Database lokal SQLite untuk penyimpanan data kebiasaan |
| `path` | ^1.8.3 | Utilitas path untuk lokasi database SQLite |
| `http` | ^1.1.0 | HTTP client untuk komunikasi dengan server/API |
| `google_fonts` | ^6.2.1 | Font Poppins dari Google Fonts |
| `flutter_slidable` | ^3.0.0 | Widget swipe (geser) pada kartu kebiasaan |
| `intl` | ^0.18.1 | Internasionalisasi dan format tanggal/angka |
| `fl_chart` | ^0.66.0 | Visualisasi grafik statistik kebiasaan |
| `flutter_local_notifications` | ^17.0.0 | Notifikasi lokal pengingat harian |
| `timezone` | ^0.9.2 | Zona waktu untuk penjadwalan notifikasi |
| `cupertino_icons` | ^1.0.8 | Ikon bergaya iOS |
| `shared_preferences` | ^2.5.5 | Penyimpanan preferensi pengguna (tema, bahasa, profil) |
| `flutter_timezone` | ^5.0.2 | Deteksi zona waktu perangkat secara otomatis |

### Dev Dependencies

| Package | Versi | Fungsi |
|---|---|---|
| `flutter_test` | sdk: flutter | Framework pengujian Flutter |
| `flutter_lints` | ^3.0.0 | Aturan linting untuk kualitas kode Dart |

---

## 👤 User

Aplikasi ini ditujukan untuk:

- **Pelajar & Mahasiswa** yang ingin membangun kebiasaan belajar yang konsisten
- **Profesional** yang ingin melacak kebiasaan produktivitas harian
- **Siapapun** yang ingin memulai dan mempertahankan kebiasaan positif dalam kehidupan sehari-hari

**Target Platform:** Android (minimum SDK disesuaikan dengan konfigurasi `build.gradle`)

---

## 🚀 How to Install

### Prasyarat

Pastikan perangkat dan environment kamu sudah memiliki:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) versi **3.x** atau lebih baru
- [Dart SDK](https://dart.dev/get-dart) versi **^3.9.2**
- [Android Studio](https://developer.android.com/studio) atau [VS Code](https://code.visualstudio.com/) dengan ekstensi Flutter
- Android Emulator atau perangkat Android fisik

---

### Langkah Instalasi

**1. Clone repositori ini**

```bash
git clone https://github.com/salsabilaoktaria-pixel/habit_tracker_app.git
cd habit_tracker_app
```

**2. Install semua dependencies**

```bash
flutter pub get
```

**3. Jalankan aplikasi**

Pastikan emulator atau perangkat Android sudah terhubung, lalu jalankan:

```bash
flutter run
```

**4. Build APK (opsional)**

Untuk menghasilkan file APK siap install:

```bash
flutter build apk --release
```

File APK akan tersedia di: `build/app/outputs/flutter-apk/app-release.apk`

---

### Troubleshooting

- Jika ada error terkait `timezone`, pastikan `flutter_timezone` sudah terinstall dengan benar dan jalankan `flutter pub get` kembali.
- Jika notifikasi tidak muncul, pastikan izin notifikasi sudah diberikan di pengaturan perangkat.
- Untuk Android 13+, izin notifikasi perlu diminta secara eksplisit melalui aplikasi.

---

## 🗂️ Struktur Proyek

```
lib/
├── main.dart                    # Entry point aplikasi
├── models/
│   └── habit_model.dart         # Model data Habit
├── controllers/
│   ├── habit_controller.dart    # Logika bisnis kebiasaan
│   └── settings_controller.dart # Logika pengaturan aplikasi
├── services/
│   ├── database_service.dart    # Layanan SQLite
│   ├── notification_service.dart# Layanan notifikasi
│   ├── api_service.dart         # Layanan HTTP/API
│   └── translation_service.dart # Layanan multi-bahasa
├── repositories/
│   └── habit_repository.dart    # Repository pattern untuk data
└── views/
    ├── habit_list_view.dart      # Halaman utama daftar kebiasaan
    ├── habit_form_view.dart      # Form tambah/edit kebiasaan
    ├── habit_detail_view.dart    # Detail kebiasaan
    ├── habit_stats_view.dart     # Statistik & grafik
    ├── history_view.dart         # Riwayat kebiasaan
    ├── settings_view.dart        # Pengaturan aplikasi
    ├── about_view.dart           # Tentang aplikasi
    ├── guide_view.dart           # Panduan penggunaan
    └── widgets/
        └── habit_card.dart       # Widget kartu kebiasaan
```

---

## 📄 License

Proyek ini dilisensikan di bawah **MIT License** — lihat file [LICENSE](LICENSE) untuk detail lebih lanjut.

---

## 👨‍💻 Author

**salsabilaoktaria-pixel**
- GitHub: [@salsabilaoktaria-pixel](https://github.com/salsabilaoktaria-pixel)

---