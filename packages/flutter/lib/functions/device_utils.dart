import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class DeviceUtil {
  /// 1. Cek Ukuran Layar (Resolution)
  /// Sangat berguna untuk bikin UI yang otomatis berubah (Responsive)
  /// Contoh: Jika lebar > 600, tampilkan Sidebar, jika < 600, tampilkan BottomNav.
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width > 600;
  }

  /// 2. Cek Koneksi Internet (Online/Offline)
  /// Biar aplikasi bisa nampilin status "Offline" kalau internet mati.
  static Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }
}