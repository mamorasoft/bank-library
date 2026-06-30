import 'package:flutter/material.dart';

/// Pilihan tipe dialog untuk menentukan warna dan icon secara otomatis
enum CustomDialogType { success, warning, error, info }

class CustomDialog {
  /// Memunculkan Custom Dialog Premium.
  /// Otomatis adaptif menjadi 1 atau 2 tombol tergantung parameter yang diisi.
  static Future<void> show(
    BuildContext context, {
    required CustomDialogType type,
    required String title,
    required String message,
    String confirmText = "OK",
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        // 1. Setup Icon dan Warna berdasarkan Tipe Dialog
        IconData dialogIcon;
        Color themeColor;

        switch (type) {
          case CustomDialogType.success:
            dialogIcon = Icons.check_circle_rounded;
            themeColor = const Color(0xFF10B981); // Hijau Emerald
            break;
          case CustomDialogType.warning:
            dialogIcon = Icons.warning_amber_rounded;
            themeColor = const Color(0xFFF59E0B); // Amber / Oranye
            break;
          case CustomDialogType.error:
            dialogIcon = Icons.error_outline_rounded;
            themeColor = const Color(0xFFEF4444); // Merah Rose
            break;
          case CustomDialogType.info:
            dialogIcon = Icons.info_outline_rounded;
            themeColor = const Color(0xFF3B82F6); // Biru Info
            break;
        }

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 10,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 2. Lingkaran Ikon Atas (Gaya Geometris Lembut)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: themeColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    dialogIcon,
                    size: 44,
                    color: themeColor,
                  ),
                ),
                const SizedBox(height: 20),

                // 3. Judul / Title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF1E293B), // Slate 800
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 10),

                // 4. Deskripsi / Pesan
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    height: 1.4,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 28),

                // 5. Struktur Tombol (Otomatis 1 atau 2 Tombol Berdampingan)
                Row(
                  children: [
                    // Jika `cancelText` diisi, munculkan Tombol Batal di sebelah kiri
                    if (cancelText != null) ...[
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(); // Tutup dialog dulu
                            if (onCancel != null) onCancel();
                          },
                          child: Text(
                            cancelText,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12), // Jarak antar tombol
                    ],

                    // Tombol Konfirmasi Utama (Selalu Muncul)
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeColor,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(); // Tutup dialog dulu
                          if (onConfirm != null) onConfirm();
                        },
                        child: Text(
                          confirmText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}