import 'package:geolocator/geolocator.dart';

class PositionUtil {
  /// Mendapatkan titik koordinat GPS (Latitude & Longitude) saat ini.
  /// Sudah dilengkapi dengan sistem pengecekan Izin dan status GPS otomatis.
  static Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Cek apakah fitur Lokasi/GPS di HP user sedang menyala
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Lempar error agar ditangkap oleh UI (bisa dimunculkan sebagai Snackbar/Dialog)
      throw Exception('GPS tidak aktif. Mohon nyalakan fitur lokasi (GPS) di HP Anda.');
    }

    // 2. Cek apakah aplikasi sudah punya izin akses lokasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Jika belum, minta izin pop-up ke user
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Izin akses lokasi ditolak. Aplikasi butuh lokasi untuk melanjutkan.');
      }
    }

    // 3. Cek jika user memblokir akses lokasi secara permanen (Don't ask again)
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Izin lokasi diblokir permanen. Silakan buka Pengaturan HP untuk mengizinkan.');
    }

    // 4. Jika semua aman, ambil koordinat dengan akurasi tinggi (butuh waktu beberapa detik)
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// Menghitung jarak antara dua titik koordinat (dalam satuan Meter).
  /// Sangat berguna untuk fitur "Absensi harus dalam radius 50 meter dari titik kantor/proyek".
  static double calculateDistanceInMeters({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }
}