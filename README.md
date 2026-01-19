# Teman Solat (Mualaf)

Aplikasi mobile (Flutter) untuk membantu **mualaf/pemula** belajar sholat dengan pendekatan **Rukun Sholat**.  
Setiap rukun punya halaman sendiri berisi **materi inti**, **sunnah (opsional)**, media (animasi/video), latihan, dan (fase berikutnya) **koreksi gerakan via kamera (on-device)**.

> Offline-first: **konten** disimpan di **JSON assets**, sedangkan **progress & settings** disimpan lokal memakai **Hive**.

---

## Fitur (MVP)
- Daftar rukun (checklist)
- Detail rukun (tab **Inti (Sah)** / **Sunnah (Opsional)**)
- Latihan per rukun (tanpa kamera) + progress lokal (Hive)
- Settings & About/Disclaimer (privasi & tujuan aplikasi)

*(Opsional/Fase lanjut: koreksi gerakan per rukun via pose detection on-device)*

---

## Getting Started

### Prerequisites
- Flutter SDK (stable)
- Android SDK + device/emulator yang terhubung
- (Opsional) VS Code + Flutter/Dart extensions

Cek environment:
```bash
flutter doctor
```

### Install dependencies
Di root project (sejajar `pubspec.yaml`):
```bash
flutter pub get
```

### Jalankan aplikasi
Pastikan device terbaca:
```bash
flutter devices
```

Run:
```bash
flutter run
```

Hot reload:
- Tekan `r` saat `flutter run` masih berjalan.

---

## Konsep Data (Offline-first)

### Konten (statis) — JSON assets
- Disimpan di folder `assets/contents/`
- Contoh:
  - `assets/contents/rukun/index.json` (list rukun untuk halaman daftar)
  - `assets/contents/rukun/{id}.json` (detail per rukun)

### Progress & Settings (dinamis) — Hive
- Disimpan lokal di device
- Box:
  - `settings` (mis. ukuran teks, preferensi tampilan)
  - `progress` (openedCount, practiceCount, attempt koreksi, dll)

---

## Struktur Folder

```
assets/
  contents/
    rukun/
      index.json            # daftar rukun (ringkas)
      ruku.json             # detail rukun (1 rukun = 1 file)
  media/                    # animasi/video (placeholder)
  audio/                    # audio bacaan (opsional)

lib/
  main.dart                 # entrypoint + init Hive + ProviderScope
  app/
    app.dart                # MaterialApp.router + theme
    router.dart             # route definitions (go_router)
  data/
    content_repo.dart       # load JSON assets (rootBundle.loadString)
    providers.dart          # Riverpod providers untuk repo & data
  features/
    home/                   # halaman Home/Dashboard
    rukun/                  # daftar rukun + detail rukun + (practice/camera nanti)
    settings/               # halaman settings
    about/                  # disclaimer & privacy
  shared/
    widgets/                # reusable UI components (badge, card, etc.)
    utils/                  # helper functions (optional)
```

### Penjelasan singkat
- **assets/**: semua file statis yang ter-bundle ke aplikasi (JSON/media/audio).
- **lib/app/**: konfigurasi app (router, theme, app entry).
- **lib/data/**: layer data (repo untuk baca JSON, provider untuk state).
- **lib/features/**: fitur per modul layar (home, rukun, settings, about).
- **lib/shared/**: komponen reusable & util umum (biar tidak duplikasi).

---

## Catatan Penting
- Assets harus didaftarkan di `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/contents/
    - assets/media/
    - assets/audio/
```

- Setelah ubah assets, lakukan restart (hot reload tidak selalu reload assets):
```bash
flutter clean
flutter pub get
flutter run
```

---

## Disclaimer
Aplikasi ini adalah **alat bantu belajar**, bukan pengganti guru/ustadz.  
Jika ada perbedaan praktik, gunakan tab **Sunnah (Opsional)** sebagai tambahan yang tidak menghakimi.