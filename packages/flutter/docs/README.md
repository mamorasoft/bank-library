# Bank Library — Flutter Functions Reference

Panduan lengkap penggunaan modul `functions/` dari `bank_library` di Flutter.

## Daftar Isi

1. [Pendahuluan](#pendahuluan)
2. [Quick Start](#quick-start)
3. [Account Validator](#3-account-validator-account_validatordart)
4. [Currency Converter](#4-currency-converter-currency_converterdart)
5. [Currency Util](#5-currency-util-currency_utilsdart)
6. [Date Util](#6-date-util-date_utilsdart)
7. [API Util](#7-api-util-api_utilsdart)
8. [Storage Util](#8-storage-util-storage_utilsdart)
9. [File Compress Util](#9-file-compress-util-file_compress_utilsdart)
10. [Position Util](#10-position-util-position_utilsdart)
11. [GCS Util](#11-gcs-util-gcs_utilsdart)
12. [Device Util](#12-device-util-device_utilsdart)
13. [Dropdown Util](#13-dropdown-util-dropdown_utilsdart)
14. [Pola Penggunaan Umum](#14-pola-penggunaan-umum-common-patterns)
15. [Catatan & Caveats](#15-catatan--caveats)
16. [Referensi](#16-referensi)

---

## 1. Pendahuluan

Modul `functions/` menyediakan utilitas siap pakai untuk:

- Validasi nomor rekening & IBAN
- Format & konversi mata uang
- Pemformatan tanggal Indonesia
- HTTP client (Dio wrapper)
- Penyimpanan lokal (SharedPreferences)
- Kompresi gambar sebelum upload
- GPS & perhitungan jarak
- Google Cloud Storage signed URL
- Device info & dropdown helper

### Ringkasan Modul

| File | Kelas / Fungsi | Tipe | Ter-export |
|------|---------------|------|------------|
| `account_validator.dart` | `validateAccountNumber()`, `validateIBAN()`, `formatAccountNumber()` | Fungsi mandiri | Ya |
| `api_utils.dart` | `ApiUtil` | Kelas statis | Ya |
| `currency_converter.dart` | `formatCurrency()`, `convertCurrency()`, `parseCurrency()` | Fungsi mandiri | Ya |
| `currency_utils.dart` | `CurrencyUtil` | Kelas statis | Ya |
| `date_utils.dart` | `DateUtil` | Kelas statis | Ya |
| `file_compress_utils.dart` | `FileCompressUtil` | Kelas statis | Ya |
| `gcs_utils.dart` | `GcsUtil` | Kelas statis | Ya |
| `position_utils.dart` | `PositionUtil` | Kelas statis | Ya |
| `storage_utils.dart` | `StorageUtil` | Kelas statis | Ya |
| `device_utils.dart` | `DeviceUtil` | Kelas statis | **Tidak** |
| `dropdown_utils.dart` | `DropdownUtil` | Kelas statis | **Tidak** |

Dua file terakhir (`device_utils.dart` dan `dropdown_utils.dart`) belum dimasukkan ke barrel export dan memerlukan import manual.

---

## 2. Quick Start

### Instalasi

Tambahkan di `pubspec.yaml`:

```yaml
dependencies:
  bank_library: ^1.0.0
```

Kemudian jalankan:

```bash
flutter pub get
```

### Import Statement

```dart
// Semua API (functions + UI widgets)
import 'package:bank_library/bank_library.dart';

// Hanya functions
import 'package:bank_library/functions/functions.dart';
```

### Setup `main.dart`

Beberapa modul memerlukan inisialisasi sebelum digunakan.

```dart
import 'package:flutter/material.dart';
import 'package:bank_library/bank_library.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageUtil.init(); // Wajib dipanggil sebelum runApp()
  runApp(const MyApp());
}
```

### Permission Android (`android/app/src/main/AndroidManifest.xml`)

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.INTERNET"/>
```

### Permission iOS (`ios/Runner/Info.plist`)

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Aplikasi memerlukan lokasi untuk fitur absensi.</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Aplikasi memerlukan lokasi untuk fitur absensi.</string>
```

---

## 3. Account Validator (`account_validator.dart`)

Validasi nomor rekening bank dan IBAN internasional, serta pemformatan nomor rekening agar lebih mudah dibaca.

### `validateAccountNumber`

```dart
bool validateAccountNumber(String accountNumber, [String bankCode = ''])
```

Membersihkan karakter non-digit dan memvalidasi panjang 8-16 digit.

```dart
bool isValid = validateAccountNumber('1234567890'); // true (10 digit)
bool isInvalid = validateAccountNumber('1234');      // false (4 digit)
bool cleansed = validateAccountNumber('1234 567 890'); // true (spasi diabaikan)
```

### `validateIBAN`

```dart
bool validateIBAN(String iban)
```

Memvalidasi IBAN menggunakan algoritma mod-97 standar internasional.

```dart
bool valid = validateIBAN('GB82WEST12345698765432'); // true
bool invalid = validateIBAN('DE27500105175001051234'); // false (angka salah)
```

### `formatAccountNumber`

```dart
String formatAccountNumber(String accountNumber, [int groupSize = 4])
```

Mengelompokkan digit dengan spasi untuk keterbacaan.

```dart
String formatted = formatAccountNumber('1234567890123'); // "1234 5678 9012 3"
String smallGroup = formatAccountNumber('1234567890', groupSize: 3); // "123 456 789 0"
```

---

## 4. Currency Converter (`currency_converter.dart`)

Format, konversi, dan parsing mata uang.

### `formatCurrency`

```dart
String formatCurrency(double amount, [String currency = 'USD', String locale = 'en_US'])
```

```dart
print(formatCurrency(1234.56));                        // "$1,234.56"
print(formatCurrency(50000, 'IDR'));                   // "Rp50.000,00"
print(formatCurrency(999.9, 'SGD', 'en_SG'));          // "S$999.90"
print(formatCurrency(0, 'JPY', 'ja_JP'));              // "￥0"
```

Simbol yang didukung: `USD`, `EUR`, `GBP`, `JPY`, `IDR`, `SGD`, `MYR`.

### `convertCurrency`

```dart
double convertCurrency(double amount, String fromCurrency, String toCurrency, Map<String, double> rates)
```

Konversi via USD sebagai intermediate currency.

```dart
Map<String, double> rates = {
  'USD': 1.0,
  'EUR': 0.85,
  'IDR': 15000.0,
};

double converted = convertCurrency(100, 'USD', 'IDR', rates); // 1500000.0
double same = convertCurrency(100, 'USD', 'USD', rates);     // 100.0
```

### `parseCurrency`

```dart
double parseCurrency(String currencyString)
```

Mengubah string yang diformat menjadi angka (strip simbol & separator).

```dart
double parsed = parseCurrency('$1,234.56'); // 1234.56
double cleaned = parseCurrency('Rp50.000'); // 50000.0
```

---

## 5. Currency Util (`currency_utils.dart`)

Kelas statis khusus untuk format Rupiah Indonesia.

### `formatToRupiah`

```dart
static String formatToRupiah(dynamic amount, {bool withSymbol = true, int decimalDigits = 0})
```

```dart
print(CurrencyUtil.formatToRupiah(50000));           // "Rp 50.000"
print(CurrencyUtil.formatToRupiah(50000, withSymbol: false)); // "50.000"
print(CurrencyUtil.formatToRupiah('150000'));         // "Rp 150.000" (string otomatis diparse)
print(CurrencyUtil.formatToRupiah(null));             // "Rp 0"
print(CurrencyUtil.formatToRupiah(1234.5, decimalDigits: 2)); // "Rp 1.234,50"
```

### `formatCompactRupiah`

```dart
static String formatCompactRupiah(dynamic amount)
```

Format singkatan untuk angka besar.

```dart
print(CurrencyUtil.formatCompactRupiah(50000));   // "Rp 50rb"
print(CurrencyUtil.formatCompactRupiah(1000000));  // "Rp 1,0jt"
print(CurrencyUtil.formatCompactRupiah(15000000)); // "Rp 15,0jt"
```

### `cleanNumberInput`

```dart
static int cleanNumberInput(String input)
```

Menghapus semua karakter non-digit.

```dart
print(CurrencyUtil.cleanNumberInput('Rp 50.000'));  // 50000
print(CurrencyUtil.cleanNumberInput('abc123'));     // 123
print(CurrencyUtil.cleanNumberInput(''));           // 0
```

---

## 6. Date Util (`date_utils.dart`)

Kelas statis untuk pemformatan tanggal Indonesia. Semua metode menerima string ISO (`"yyyy-MM-dd"` atau `"yyyy-MM-ddTHH:mm:ss"`) dan menghasilkan output berbahasa Indonesia.

### `formatToIndoDate`

```dart
static String formatToIndoDate(String? isoString, {String format = 'dd MMM yyyy'})
```

```dart
print(DateUtil.formatToIndoDate('2026-06-26'));       // "26 Jun 2026"
print(DateUtil.formatToIndoDate('2026-06-26', format: 'EEEE, dd MMM yyyy')); // "Jumat, 26 Jun 2026"
print(DateUtil.formatToIndoDate(null));                // "-"
print(DateUtil.formatToIndoDate('invalid'));           // "-"
```

### `calculateDaysFromNow`

```dart
static int calculateDaysFromNow(String? targetDateIso)
```

```dart
int days = DateUtil.calculateDaysFromNow('2026-07-01'); // 5 (hari dari sekarang)
int past = DateUtil.calculateDaysFromNow('2025-01-01');  // negatif (sudah lewat)
int zero = DateUtil.calculateDaysFromNow(null);         // 0
```

### `getMonthName`

```dart
static String getMonthName(String? isoString, {bool isShort = false})
```

```dart
print(DateUtil.getMonthName('2026-02-15')); // "Februari"
print(DateUtil.getMonthName('2026-02-15', isShort: true)); // "Feb"
```

### `getMonthNameFromNumber`

```dart
static String getMonthNameFromNumber(int monthNumber, {bool isShort = false})
```

```dart
print(DateUtil.getMonthNameFromNumber(6));  // "Juni"
print(DateUtil.getMonthNameFromNumber(12, isShort: true)); // "Des"
print(DateUtil.getMonthNameFromNumber(13)); // "-" (out of range)
```

### `getDayName`

```dart
static String getDayName(String? isoString, {bool isShort = false})
```

```dart
print(DateUtil.getDayName('2026-06-26')); // "Jumat"
print(DateUtil.getDayName('2026-06-26', isShort: true)); // "Jum"
```

### `getDayNameFromNumber`

```dart
static String getDayNameFromNumber(int dayNumber, {bool isShort = false})
```

```dart
print(DateUtil.getDayNameFromNumber(1));  // "Senin"
print(DateUtil.getDayNameFromNumber(5, isShort: true)); // "Jum"
print(DateUtil.getDayNameFromNumber(7));  // "Minggu"
print(DateUtil.getDayNameFromNumber(0));  // "-" (out of range)
```

### `formatToTime`

```dart
static String formatToTime(String? isoString, {String format = 'HH:mm'})
```

```dart
print(DateUtil.formatToTime('2026-06-26T14:30:00')); // "14:30"
print(DateUtil.formatToTime('2026-06-26T08:05:00', format: 'hh:mm a')); // "08:05 AM"
```

### `formatToFullDateTime`

```dart
static String formatToFullDateTime(String? isoString)
```

Shortcut untuk format `"dd MMM yyyy, HH:mm"`.

```dart
print(DateUtil.formatToFullDateTime('2026-06-26T14:30:00')); // "26 Jun 2026, 14:30"
```

---

## 7. API Util (`api_utils.dart`)

Wrapper Dio (v4 ke bawah) dengan konfigurasi bawaan (timeout 30 detik) dan inject token Bearer otomatis.

### `postCall`

```dart
Future<dynamic> postCall({
  required String path,
  dynamic params,
  String? token,
  Options? options,
  Map<String, dynamic>? queryParams,
  bool isDebug = false,
})
```

POST request. Otomatis mengubah `Map<String, dynamic>` params menjadi `FormData`.

```dart
dynamic response = await ApiUtil.postCall(
  path: '/api/payments',
  params: {'amount': 50000, 'account': '1234567890'},
  token: 'your-token-here',
);

// Upload dengan file (otomatis jadi FormData)
Map<String, dynamic> uploadParams = {
  'recipient': 'John Doe',
  'proof': receiptFile, // File object
};
dynamic response = await ApiUtil.postCall(
  path: '/api/payments/proof',
  params: uploadParams,
  token: 'your-token-here',
);
```

### `getCall`

```dart
Future<dynamic> getCall({
  required String path,
  String? token,
  Options? options,
  Map<String, dynamic>? queryParams,
  bool isDebug = false,
})
```

```dart
dynamic users = await ApiUtil.getCall(
  path: '/api/users',
  token: 'your-token-here',
  queryParams: {'page': 1, 'limit': 10},
);
```

### `putCall`

```dart
Future<dynamic> putCall({
  required String path,
  dynamic params,
  String? token,
  Options? options,
  Map<String, dynamic>? queryParams,
  bool isDebug = false,
})
```

Sama seperti `postCall` untuk body conversion.

```dart
dynamic result = await ApiUtil.putCall(
  path: '/api/users/1',
  params: {'name': 'Updated Name', 'role': 'admin'},
  token: 'your-token-here',
);
```

### `deleteCall`

```dart
Future<dynamic> deleteCall({
  required String path,
  dynamic data,
  String? token,
  Options? options,
  Map<String, dynamic>? queryParams,
  bool isDebug = false,
})
```

DELETE request. Body data tidak di-convert otomatis ke FormData.

```dart
dynamic result = await ApiUtil.deleteCall(
  path: '/api/users/1',
  token: 'your-token-here',
);
```

### Tabel Parameter

| Parameter | Tipe | Wajib | Deskripsi |
|-----------|------|-------|-----------|
| `path` | `String` | Ya | Endpoint URL (misal `/api/payments`) |
| `params` / `data` | `dynamic` | Tidak | Body payload (JSON atau File) |
| `token` | `String?` | Tidak | Bearer token untuk autentikasi |
| `options` | `Options?` | Tidak | Custom Dio Options |
| `queryParams` | `Map<String, dynamic>?` | Tidak | Query string parameters |
| `isDebug` | `bool` | Tidak | Logging via `dart:developer` (default: `false`) |

---

## 8. Storage Util (`storage_utils.dart`)

Wrapper SharedPreferences untuk penyimpanan lokal.

### `init` (Wajib)

```dart
static Future<void> init()
```

Harus dipanggil di `main.dart` sebelum `runApp()`.

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageUtil.init();
  runApp(const MyApp());
}
```

### Getter / Setter

```dart
// String
static Future<bool> setString(String key, String value)
static String getString(String key, {String def = ""})

// Boolean
static Future<bool> setBool(String key, bool value)
static bool getBool(String key, {bool def = false})

// Integer
static Future<bool> setInt(String key, int value)
static int getInt(String key, {int def = 0})
```

```dart
await StorageUtil.setString('theme', 'dark');
String theme = StorageUtil.getString('theme'); // "dark"

String missing = StorageUtil.getString('non_existent', def: 'light'); // "light"

await StorageUtil.setInt('notifications_count', 5);
int count = StorageUtil.getInt('notifications_count'); // 5
```

### `saveUserSession`

```dart
static Future<void> saveUserSession({required String token, required String role, required String userId})
```

Menyimpan token, role, userId, dan flag login secara bersamaan.

```dart
await StorageUtil.saveUserSession(
  token: 'eyJhbGciOiJIUzI1NiIs...',
  role: 'admin',
  userId: 'abc-123-def',
);
```

### `clearSession`

```dart
static Future<void> clearSession()
```

Membersihkan semua data SharedPreferences (logout).

```dart
await StorageUtil.clearSession();
```

### Konstanta Key

| Constant | Value | Digunakan Untuk |
|----------|-------|----------------|
| `keyAuthToken` | `"auth_token"` | Menyimpan JWT / session token |
| `keyUserRole` | `"user_role"` | Role pengguna (admin, siswa, guru, dll) |
| `keyUserId` | `"user_id"` | ID unik pengguna |
| `keyIsLoggedIn` | `"is_logged_in"` | Flag status login (boolean) |

```dart
bool isLoggedIn = StorageUtil.getBool(StorageUtil.keyIsLoggedIn);
String role = StorageUtil.getString(StorageUtil.keyUserRole);
```

---

## 9. File Compress Util (`file_compress_utils.dart`)

Kompresi gambar sebelum upload untuk mengurangi ukuran bandwidth.

### `compressImage`

```dart
static Future<File> compressImage(File file, {
  int quality = 70,
  int minWidth = 1024,
  int minHeight = 1024,
})
```

Hanya memproses file `jpg`/`jpeg`/`png`. File lain dikembalikan apa adanya.

```dart
File compressed = await FileCompressUtil.compressImage(originalFile);

// Kustomisasi
File compressedHD = await FileCompressUtil.compressImage(
  originalFile,
  quality: 85,
  minWidth: 2048,
  minHeight: 2048,
);

// File PDF dikembalikan apa adanya (tidak diproses)
File pdfResult = await FileCompressUtil.compressImage(pdfFile);
```

### `scanAndCompressMap`

```dart
static Future<Map<String, dynamic>> scanAndCompressMap(Map<String, dynamic> params)
```

Memindai map secara rekursif dan kompres otomatis semua nilai bertipe `File` atau `List<File>`.

```dart
Map<String, dynamic> uploadParams = {
  'recipient': 'John Doe',
  'proof': receiptFile,                    // File tunggal
  'photos': [photo1, photo2, photo3],     // List<File>
  'amount': 50000,                         // String/int — tidak diproses
};

Map<String, dynamic> compressed = await FileCompressUtil.scanAndCompressMap(uploadParams);

// Kirim ke API
await ApiUtil.postCall(
  path: '/api/payments',
  params: compressed,
  token: 'your-token',
);
```

---

## 10. Position Util (`position_utils.dart`)

Helper GPS dan perhitungan jarak menggunakan `geolocator`.

### `getCurrentPosition`

```dart
static Future<Position> getCurrentPosition()
```

Memeriksa layanan GPS, izin, dan mengembalikan koordinat dengan akurasi tinggi.

```dart
try {
  Position pos = await PositionUtil.getCurrentPosition();
  print('Lat: ${pos.latitude}, Lng: ${pos.longitude}');
  // Lat: -6.2088, Lng: 106.8456
} catch (e) {
  print(e.toString());
  // "GPS tidak aktif. Mohon nyalakan fitur lokasi (GPS) di HP Anda."
}
```

Pengecualian yang mungkin terlempar:

| Kondisi | Pesan |
|---------|-------|
| GPS mati | `GPS tidak aktif. Mohon nyalakan fitur lokasi (GPS) di HP Anda.` |
| Izin ditolak | `Izin akses lokasi ditolak. Aplikasi butuh lokasi untuk melanjutkan.` |
| Blokir permanen | `Izin lokasi diblokir permanen. Silakan buka Pengaturan HP untuk mengizinkan.` |

### `calculateDistanceInMeters`

```dart
static double calculateDistanceInMeters({
  required double startLatitude,
  required double startLongitude,
  required double endLatitude,
  required double endLongitude,
})
```

Menghitung jarak Haversine antara dua titik koordinat.

```dart
double meters = await PositionUtil.calculateDistanceInMeters(
  startLatitude: -6.2088,
  startLongitude: 106.8456,
  endLatitude: -6.2042,
  endLongitude: 106.8167,
);
print('$meters meter'); // ~3142 meter

// Use case: cek absensi dalam radius 50m
double distance = PositionUtil.calculateDistanceInMeters(
  startLatitude: officeLat,
  startLongitude: officeLng,
  endLatitude: userLat,
  endLongitude: userLng,
);
if (distance <= 50) {
  // Izinkan absensi
}
```

---

## 11. GCS Util (`gcs_utils.dart`)

Pengambilan signed URL untuk akses file di Google Cloud Storage.

### `getSignedUrl`

```dart
static Future<String> getSignedUrl({
  required String path,
  required String fileName,
  required String token,
  required String signedApiUrl,
})
```

Manggil backend API untuk mendapatkan signed URL. Jika gagal, fallback ke URL default.

```dart
String url = await GcsUtil.getSignedUrl(
  path: 'documents/invoices',
  fileName: 'inv-2026-001.pdf',
  token: 'your-token',
  signedApiUrl: '/api/files/signed-url',
);
print(url); // "https://storage.googleapis.com/bucket-name/documents/invoices/inv-2026-001.pdf"
```

> **Catatan**: URL fallback masih menggunakan placeholder `bucket-name`. Pastikan endpoint backend (`signedApiUrl`) mengembalikan URL yang benar sebelum bergantung pada fallback.

---

## 12. Device Util (`device_utils.dart`)

**WARNING**: File ini belum di-export dari barrel. Impor manual diperlukan.

```dart
import 'package:bank_library/functions/device_utils.dart';
```

### `getScreenSize`

```dart
static Size getScreenSize(BuildContext context)
```

```dart
Size size = DeviceUtil.getScreenSize(context);
double width = size.width;
```

### `isTablet`

```dart
static bool isTablet(BuildContext context)
```

```dart
bool isTablet = DeviceUtil.isTablet(context);
```

### `isConnected`

```dart
static Future<bool> isConnected()
```

```dart
bool online = await DeviceUtil.isConnected();
```

---

## 13. Dropdown Util (`dropdown_utils.dart`)

**WARNING**: File ini belum di-export dari barrel. Impor manual diperlukan.

```dart
import 'package:bank_library/functions/dropdown_utils.dart';
```

### `fromStringList`

```dart
static List<DropdownMenuItem<String>> fromStringList(List<String> items)
```

Dari list string statis.

```dart
List<String> genders = ['Laki-laki', 'Perempuan', 'Lainnya'];
List<DropdownMenuItem<String>> items = DropdownUtil.fromStringList(genders);
```

```dart
DropdownButton<String>(
  items: DropdownUtil.fromStringList(['Admin', 'User', 'Guru']),
  onChanged: (val) => print(val),
)
```

### `fromMap`

```dart
static List<DropdownMenuItem<T>> fromMap<T>(Map<T, String> mapItems)
```

Dari map key-value (value untuk display, key dikirim ke backend).

```dart
Map<int, String> roles = {1: 'Admin', 2: 'Staff', 3: 'User'};
List<DropdownMenuItem<int>> items = DropdownUtil.fromMap(roles);
```

### `fromApiData`

```dart
static List<DropdownMenuItem<dynamic>> fromApiData({
  required List<Map<String, dynamic>> dataList,
  required String valueKey,
  required String labelKey,
})
```

Dari data JSON API (respons paling umum).

```dart
List<Map<String, dynamic>> banks = [
  {'code': 'BCA', 'name': 'Bank Central Asia'},
  {'code': 'BNI', 'name': 'Bank Negara Indonesia'},
  {'code': 'BRI', 'name': 'Bank Rakyat Indonesia'},
];

List<DropdownMenuItem<String>> items = DropdownUtil.fromApiData(
  dataList: banks,
  valueKey: 'code',
  labelKey: 'name',
);
```

```dart
// Contoh: nama provinsi dari API
final provinces = await ApiUtil.getCall(path: '/api/provinces', token: token);

DropdownButton<String>(
  items: DropdownUtil.fromApiData(
    dataList: provinces,
    valueKey: 'id',
    labelKey: 'name',
  ),
  onChanged: (provinceId) {
    // kirim provinceId ke backend
  },
)
```

---

## 14. Pola Penggunaan Umum (Common Patterns)

### Simpan Session + Kirim Request

```dart
// Login — simpan session
await StorageUtil.saveUserSession(
  token: response['token'],
  role: response['role'],
  userId: response['id'],
);

// Request berikutnya — cukup tambahkan token
dynamic data = await ApiUtil.postCall(
  path: '/api/payments',
  params: {'amount': 50000, 'account': '1234567890'},
  token: StorageUtil.getString(StorageUtil.keyAuthToken),
);
```

### Upload Foto dengan Kompresi Otomatis

```dart
Future<void> uploadPaymentProof(ImageSource source) async {
  final File imageFile = /* dari image_picker */;

  Map<String, dynamic> params = {
    'recipient': 'John Doe',
    'proof': imageFile,
  };

  // Kompres semua File dalam map secara otomatis
  Map<String, dynamic> compressed = await FileCompressUtil.scanAndCompressMap(params);

  await ApiUtil.postCall(
    path: '/api/payments/proof',
    params: compressed,
    token: StorageUtil.getString(StorageUtil.keyAuthToken),
  );
}
```

### Ambil Lokasi + Hitung Jarak

```dart
Future<void> checkAttendance() async {
  try {
    Position userPos = await PositionUtil.getCurrentPosition();

    double distance = PositionUtil.calculateDistanceInMeters(
      startLatitude: officeLatitude,
      startLongitude: officeLongitude,
      endLatitude: userPos.latitude,
      endLongitude: userPos.longitude,
    );

    if (distance <= 50) {
      // Dalam radius 50m — izinkan absensi
    } else {
      // Terlalu jauh
    }
  } catch (e) {
    // Handle error (GPS off, permission denied, dll)
  }
}
```

### Format Rupiah untuk Tampilan

```dart
// Di UI
Text(CurrencyUtil.formatToRupiah(amount));
// Output: "Rp 50.000"

// Atau versi compact
Text(CurrencyUtil.formatCompactRupiah(15000000));
// Output: "Rp 15,0jt"
```

---

## 15. Catatan & Caveats

### Modul yang Belum Ter-export

Dua file berikut ada di `lib/functions/` tetapi **belum masuk barrel export** (`lib/functions.dart`). Harus menggunakan import manual:

```dart
import 'package:bank_library/functions/device_utils.dart';
import 'package:bank_library/functions/dropdown_utils.dart';
```

### GCS Util Placeholder

Fallback URL di `GcsUtil._buildDefaultUrl` masih menggunakan placeholder `bucket-name`. Pastikan backend API yang dihubungi melalui `signedApiUrl` mengembalikan URL yang valid agar tidak perlu bergantung pada fallback.

### Dio Version

`ApiUtil` dirancang untuk Dio v4 ke bawah (`DioError` untuk error handling). Pastikan dependency `dio` di `pubspec.yaml` cocok.

### Unit Test

Tidak ada unit test untuk modul-modul functions di package ini. Hanya ada widget test untuk layer UI (`BankAccountInput`, `CurrencyInput`). Pertimbangkan untuk menambah test setelah dokumentasi ini dipakai.

---

## 16. Referensi

- `docs/usage.md` — Panduan singkat (quick start monorepo)
- `docs/EXAMPLES.md` — Contoh penggunaan lengkap termasuk UI widgets
- `docs/API.md` — Referensi API lintas platform (Laravel, Vue.js, Flutter)