import 'dart:ui';
import 'package:flutter/material.dart';

class PremiumLoading {
  /// Memunculkan Loading Overlay dengan efek blur Glassmorphism privat.
  /// Panggil: PremiumLoading.show(context, message: "Loading data...");
  static void show(BuildContext context, {String message = "Mohon tunggu..."}) {
    showDialog(
      context: context,
      barrierDismissible: false, // User tidak bisa klik luar untuk close
      builder: (BuildContext context) {
        return PopScope(
          canPop: false, // Kunci tombol back fisik HP
          child: Stack(
            children: [
              // Lapisan Blur Glassmorphism Background
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                child: Container(
                  color: Colors.black.withOpacity(0.15),
                ),
              ),
              
              // Kotak Loading Tengah
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.88),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.6)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 20,
                        spreadRadius: 4,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Indikator Spinner Premium
                      const SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 3.5,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)), // Warna tema biru premium
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Teks Status
                      Text(
                        message,
                        style: const TextStyle(
                          color: Color(0xFF1E293B),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.none,
                          fontFamily: 'Sans-Serif',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Menutup Loading Overlay setelah proses kelar.
  /// Panggil: PremiumLoading.hide(context);
  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}