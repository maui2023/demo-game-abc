# EduMiQa 🧸 — Kembara Pembelajaran Kanak-Kanak Ceria!

Aplikasi mudah alih Flutter interaktif yang menyeronokkan untuk kanak-kanak. Menggabungkan pembelajaran asas abjad, Jawi, nombor, Text-to-Speech (TTS), sistem multi-profil tempatan, papan pendahulu (leaderboard), serta permainan mini runner 2D "Subway Math Runner".

## 🚀 Pautan Muat Turun APK (Android)
- **Untuk Telefon Pintar (ARM64 - Ringan ~18MB)**:
  👉 **[Muat Turun EduMiQa_final.apk](EduMiQa_final.apk)**
- **Untuk Emulator PC / Pemasangan Universal (Universal ~50MB)**:
  👉 **[Muat Turun EduMiQa_universal.apk](EduMiQa_universal.apk)**

---

## ⭐ Ciri-Ciri Utama Aplikasi

1. **Pembelajaran Lengkap (Full Decks)**
   - **Abjad A-Z**: Penerangan perkataan dwibahasa (Inggeris & Melayu) berserta emoji visual (26 kad).
   - **Huruf Jawi**: Dari Alif (ا) hingga Ya (ي) berserta perkataan contoh (29 kad).
   - **Nombor 0-9**: Kad nombor dengan visual objek boleh dikira bagi membantu kanak-kanak memvisualisasikan kuantiti (10 kad).

2. **Audio Sebutan Pintar (Text-To-Speech)**
   - Setiap kad pembelajaran dibekalkan dengan butang **Dengar Sebutan 🔊** untuk membolehkan kanak-kanak mendengar sebutan bahasa Melayu yang betul.

3. **Matematik Visual (Math Ria)**
   - Operasi tambah (+) dan tolak (-) interaktif.
   - Operasi penolakan dipaparkan secara intuitif dengan **melapkan (faded)** dan **memangkah (red cross ❌)** bilangan strawberi yang ditolak.

4. **Permainan Arkade: Subway Math Runner 🏃**
   - Menghidupkan kaedah pembelajaran gamifikasi. Kanak-kanak mengawal Dino (`🦖`) melompat atau bertukar laluan untuk memecahkan pagar jawapan matematik yang betul bagi mengumpul mata bintang sambil mengelak halangan.

5. **Sistem Multi-Profil Tempatan**
   - Menyokong pendaftaran lebih daripada satu profil adik dalam satu peranti dengan penyimpanan data bintang berasingan secara tempatan.

---

## 🛠️ Langkah Menjalankan Kod Sumber Secara Tempatan

### Prasyarat
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (versi 3.22.x ke atas) dipasang pada komputer anda.
- Peranti Android / Emulator sedang aktif.

### Langkah Pemasangan & Pelancaran
1. Masuk ke direktori projek:
   ```bash
   cd eduverse_kids
   ```
2. Jalankan muat turun pakej/keperluan (dependencies):
   ```bash
   flutter pub get
   ```
3. Lancarkan aplikasi pada peranti/emulator yang disambungkan:
   ```bash
   flutter run
   ```

### Cara Membina Installer APK (Android)
Untuk membina APK release khusus 64-bit yang dioptimumkan:
```bash
flutter build apk --target-platform android-arm64 --release
```
Fail APK boleh diambil di direktori: `build/app/outputs/flutter-apk/app-release.apk`
