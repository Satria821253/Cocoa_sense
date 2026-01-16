# 🌱 COCOA-SENSE

Aplikasi monitoring dan deteksi buah kakao berbasis IoT dan AI untuk meningkatkan produktivitas perkebunan kakao.

## 📱 Status Fitur

### ✅ Fitur yang Sudah Berfungsi

#### 1. **Splash Screen**
- Animasi fade & scale logo
- Auto navigate ke Welcome Screen (3 detik)
- Loading indicator

#### 2. **Welcome Screen**
- Rotated logo container dengan gradient
- Deskripsi aplikasi
- Tombol "Mulai Aplikasi" navigasi ke Main Screen

#### 3. **Home Dashboard**
- Status kebun (nama, jumlah pohon, buah, kesehatan)
- Info capaian panen dan HOK terpakai
- Card deteksi AI
- Sensor realtime (suhu udara dengan chart)
- AppBar dengan logo dan notifikasi

#### 4. **Google Maps**
- Integrasi Google Maps
- GPS tracking realtime
- Animated marker movement (smooth transition)
- Accuracy circle
- Share location via WhatsApp
- Open in Google Maps
- Draggable bottom sheet dengan info lokasi

#### 5. **Camera Scanner**
- Live camera preview
- Permission handling (camera)
- Capture photo langsung dari preview
- Pick image from gallery
- Flash toggle (on/off)
- Animated scanning line
- Corner frame indicators

#### 6. **Photo Result Screen**
- Preview foto fullscreen
- Tombol retake (foto ulang)
- Tombol analisis AI (placeholder)
- Tombol simpan ke galeri (placeholder)

#### 7. **IoT Monitoring**
- Dashboard monitoring sistem
- Real-time sensor data (pH tanah, intensitas cahaya)
- Auto-update data setiap 3 detik
- Status sensor list
- Quick actions (refresh, export, analytics)
- AppBar konsisten dengan Home

#### 8. **Profile Screen**
- Header dengan foto profil
- Info user (nama, fakultas, program)
- Statistik (scan count, land count, level)
- Menu list (pengaturan, bantuan, dll)
- AppBar dengan logo dan notifikasi

#### 9. **Navigation**
- Bottom Navigation Bar dengan 5 tabs
- Floating Action Button (Camera) di tengah
- Rounded top corners
- GetX routing

### ⏳ Fitur yang Belum Berfungsi (Placeholder)

#### 1. **AI Detection**
- Analisis foto buah kakao
- Deteksi penyakit
- Rekomendasi treatment
- *Status: UI ready, perlu integrasi AI model*

#### 2. **IoT Integration**
- Koneksi ke sensor fisik
- Real-time data dari hardware
- *Status: Menggunakan dummy data, perlu API backend*

#### 3. **Data Export**
- Export data sensor ke CSV/Excel
- *Status: Button ready, perlu implementasi*

#### 4. **Save to Gallery**
- Simpan foto hasil capture ke galeri
- *Status: Button ready, perlu implementasi*

#### 5. **User Authentication**
- Login/Register
- Profile management
- *Status: Menggunakan data static*

#### 6. **Backend API**
- Dio HTTP client (sudah di pubspec.yaml)
- Shared preferences untuk local storage
- *Status: Dependencies ready, belum diimplementasi*

#### 7. **Notifications**
- Push notifications
- Alert sistem
- *Status: Icon ready, belum diimplementasi*

## 🛠️ Tech Stack

### Framework & State Management
- **Flutter**: 3.8.1+
- **Dart SDK**: 3.8.1+
- **GetX**: 4.6.6 (State Management & Routing)

### Dependencies (Implemented)
- **google_maps_flutter**: 2.5.0 - Maps integration
- **geolocator**: 10.1.0 - GPS location
- **permission_handler**: 11.0.1 - Runtime permissions
- **camera**: 0.10.5+5 - Camera access
- **image_picker**: 1.0.4 - Gallery picker
- **share_plus**: 7.2.1 - Share functionality
- **url_launcher**: 6.2.2 - Open external URLs

### Dependencies (Declared, Not Implemented)
- **dio**: 5.4.0 - HTTP client
- **shared_preferences**: 2.2.2 - Local storage
- **intl**: 0.18.1 - Date formatting
- **connectivity_plus**: 5.0.2 - Network status

## 📁 Project Structure

```
lib/
├── controllers/              # GetX Controllers
│   ├── camera_controller.dart
│   ├── main_controller.dart
│   ├── map_controller.dart
│   └── monitoring_controller.dart
├── routes/                   # App Routes
│   └── app_routes.dart
├── screen/                   # UI Screens
│   ├── splash_screen.dart
│   ├── welcome_screen.dart
│   ├── main_screen.dart
│   ├── home_screen.dart
│   ├── map_screen.dart
│   ├── camera_scan_screen.dart
│   ├── photo_result_screen.dart
│   ├── monitoring_screen.dart
│   ├── profile_screen.dart
│   └── widget/              # Reusable Widgets
│       ├── card/
│       ├── map_screen_helpers.dart
│       ├── monitoring_widgets.dart
│       └── profile_*.dart
└── main.dart                # Entry Point
```

## 🚀 Setup & Installation

### Prerequisites
- Flutter SDK 3.8.1 or higher
- Dart SDK 3.8.1 or higher
- Android Studio / VS Code
- Android SDK (untuk Android)
- Xcode (untuk iOS)
- Physical Device atau Emulator

### Step-by-Step Installation

#### 1. Clone Repository
```bash
git clone https://github.com/YOUR_USERNAME/cocoa_sense.git
cd cocoa_sense
```

#### 2. Install Dependencies
```bash
flutter pub get
```

#### 3. Setup Google Maps API Key

**Dapatkan API Key:**
1. Buka [Google Cloud Console](https://console.cloud.google.com/)
2. Buat project baru atau pilih existing project
3. Enable **Maps SDK for Android** dan **Maps SDK for iOS**
4. Buat credentials (API Key)
5. (Optional) Restrict API key untuk keamanan

**Android Setup:**

Edit `android/app/src/main/AndroidManifest.xml`:
```xml
<application>
    <meta-data
        android:name="com.google.android.geo.API_KEY"
        android:value="YOUR_GOOGLE_MAPS_API_KEY_HERE"/>
</application>
```

**iOS Setup:**

Edit `ios/Runner/AppDelegate.swift`:
```swift
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY_HERE")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

#### 4. Add Logo Asset

Pastikan file logo ada di `assets/OIP.png`

#### 5. Verify Permissions

**Android** - `android/app/src/main/AndroidManifest.xml` sudah include:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-feature android:name="android.hardware.camera" android:required="false" />
```

**iOS** - `ios/Runner/Info.plist` perlu ditambahkan:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Aplikasi memerlukan akses lokasi untuk fitur peta</string>
<key>NSCameraUsageDescription</key>
<string>Aplikasi memerlukan akses kamera untuk scan buah kakao</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Aplikasi memerlukan akses galeri untuk memilih foto</string>
```

#### 6. Run Application

```bash
# Check connected devices
flutter devices

# Run on connected device
flutter run

# Run in release mode
flutter run --release
```

## 📱 Screenshots & Features Detail

### 1. Splash Screen
- Logo fade & scale animation
- Auto navigate setelah 3 detik
- Loading indicator

### 2. Welcome Screen
- Rotated logo container (45°)
- Gradient text "COCOA-SENSE"
- Deskripsi aplikasi
- Button "Mulai Aplikasi"

### 3. Home Screen
- **AppBar**: Logo + "COCOA-SENSE" + "BERANDA" + Notifikasi
- **Garden Status Card**: Nama kebun, jumlah pohon, buah, kesehatan
- **Info Cards**: Capaian panen (Kg/Bln), HOK terpakai
- **Feature Card**: Deteksi AI dengan icon camera
- **Sensor Realtime**: Suhu udara dengan line chart

### 4. Map Screen
- **AppBar**: Logo + "COCOA-SENSE" + "PETA KEBUN" + Notifikasi
- **Google Maps**: Fullscreen dengan current location
- **Animated Marker**: Smooth movement saat lokasi update
- **Accuracy Circle**: Menunjukkan akurasi GPS
- **Bottom Sheet**: 
  - Info lokasi (koordinat, akurasi)
  - Tombol Share (WhatsApp)
  - Tombol Open in Google Maps
- **Floating Buttons**: Zoom in, Zoom out, Current location

### 5. Camera Scanner
- **Live Preview**: Real-time camera feed
- **Scanning Frame**: Kotak hijau dengan corner indicators
- **Animated Line**: Scanning line bergerak vertikal
- **Controls**:
  - Gallery button (kiri)
  - Capture button (tengah, besar)
  - Flash toggle (kanan)
- **Close Button**: Top-left untuk kembali

### 6. Photo Result Screen
- **Preview**: Fullscreen photo
- **Top Bar**: Close button + Retake button
- **Bottom Actions**:
  - "Analisis dengan AI" (hijau, primary)
  - "Simpan ke Galeri" (outline putih)

### 7. Monitoring Screen
- **AppBar**: Logo + "COCOA-SENSE" + "MONITORING SISTEM" + Notifikasi
- **Status Card**: Icon pulse, jumlah sensor aktif
- **Metric Cards**: pH Tanah, Intensitas Cahaya (auto-update)
- **Sensor List**: Status sensor per area
- **Quick Actions**: Refresh, Export, Analytics

### 8. Profile Screen
- **AppBar**: Logo + "COCOA-SENSE" + "PROFIL AKUN" + Notifikasi
- **Profile Header**: Foto, nama, fakultas, program
- **Statistics**: Scan count, Land count, Level
- **Menu List**: Pengaturan, Bantuan, Tentang, Logout
- **Footer**: Version info

## 🎮 Alur Aplikasi (User Flow)

```
┌─────────────────┐
│  Splash Screen  │ (3 detik, auto navigate)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Welcome Screen  │ (Tombol "Mulai Aplikasi")
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────────────────┐
│           Main Screen (Bottom Nav)          │
├─────────┬─────────┬─────────┬──────────────┤
│  Home   │   Map   │ Camera  │  Monitoring  │ Profile
└─────────┴─────────┴────┬────┴──────────────┴────────┘
                         │
                         ▼
              ┌──────────────────────┐
              │  Camera Scan Screen  │
              │  - Live Preview      │
              │  - Capture Photo     │
              │  - Pick from Gallery │
              └──────────┬───────────┘
                         │
                         ▼
              ┌──────────────────────┐
              │ Photo Result Screen  │
              │  - Preview           │
              │  - Analisis AI       │
              │  - Simpan            │
              │  - Retake            │
              └──────────────────────┘
```

### Detail Flow per Screen:

1. **Splash → Welcome → Main**
   - User tidak bisa skip splash (3 detik)
   - Welcome screen hanya muncul sekali (bisa ditambah shared_preferences)
   - Main screen adalah home utama

2. **Bottom Navigation**
   - 5 tabs: Home, Map, Camera (FAB), Monitoring, Profile
   - Camera di tengah sebagai FAB
   - Setiap tab punya AppBar konsisten

3. **Camera Flow**
   - Tap FAB Camera → Request permission → Camera preview
   - Capture photo → Photo Result Screen
   - Pick gallery → Photo Result Screen
   - Photo Result: Analisis AI / Simpan / Retake

4. **Map Flow**
   - Auto request location permission
   - Show current location dengan animated marker
   - Bottom sheet: Info lokasi, Share, Open in Google Maps

5. **Monitoring Flow**
   - Auto-update sensor data setiap 3 detik
   - Refresh manual, Export data, View analytics

## 🔧 Troubleshooting

### Camera tidak muncul / Loading terus
1. Pastikan permission CAMERA sudah ditambahkan di AndroidManifest.xml
2. Uninstall app dari device
3. Run ulang: `flutter run`
4. Allow permission saat diminta

### Google Maps tidak muncul
1. Pastikan API Key sudah benar
2. Enable Maps SDK for Android/iOS di Google Cloud Console
3. Check billing account aktif
4. Restart app

### GPS tidak akurat
1. Pastikan GPS device aktif
2. Test di outdoor (bukan indoor)
3. Tunggu beberapa saat untuk GPS lock

### Build error
```bash
flutter clean
flutter pub get
flutter run
```

## 📚 Documentation

- [DEPENDENCY_ANALYSIS.md](DEPENDENCY_ANALYSIS.md) - Analisis dependencies
- [IMPLEMENTATION_CHECK.md](IMPLEMENTATION_CHECK.md) - Checklist implementasi

## 🚧 Roadmap / TODO

### High Priority
- [ ] Integrasi AI model untuk deteksi buah kakao
- [ ] Backend API untuk data sensor realtime
- [ ] Implementasi save to gallery
- [ ] User authentication (login/register)

### Medium Priority
- [ ] Export data sensor ke CSV/Excel
- [ ] Push notifications
- [ ] Offline mode dengan local storage
- [ ] Multi-language support

### Low Priority
- [ ] Dark mode
- [ ] Tutorial/onboarding
- [ ] Analytics dashboard
- [ ] Report generation

## 🤝 Contributing

1. Fork the project
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License.

## 👥 Team

**IPB University 2026**
- Fakultas Pertanian
- Program Studi Agronomi

## 📞 Contact

For questions or support, please contact:
- Email: nagarasatria104@gmail.com
- No Telp : 082116927632

---

**Version:** 1.0.0  
**Status:** Development (UI Complete, Backend Pending) 🚧  
**Last Updated:** December 2024  
**Flutter Version:** 3.8.1+  
**Minimum SDK:** Android 21+ / iOS 12+
