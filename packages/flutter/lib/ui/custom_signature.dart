import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class PremiumSignaturePad extends StatelessWidget {
  final SignatureController controller;
  final double height;
  final Color? backgroundColor;
  final double borderRadius;
  
  // Konfigurasi Tombol Kontrol Bawaan
  final bool showControls;
  final String clearText;
  final String undoText;
  final Color? activeColor;

  const PremiumSignaturePad({
    Key? key,
    required this.controller,
    this.height = 220.0,
    this.backgroundColor = const Color(0xFFF8FAFC), // Warna abu-abu slate super terang
    this.borderRadius = 16.0,
    this.showControls = true,
    this.clearText = "Bersihkan",
    this.undoText = "Urungkan (Undo)",
    this.activeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = activeColor ?? theme.primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. KANVAS TANDA TANGAN (Wrapped with Premium Border & Shadow)
        Container(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius - 1.5),
            child: Signature(
              controller: controller,
              backgroundColor: backgroundColor!,
              height: height,
            ),
          ),
        ),
        
        // 2. TOMBOL KONTROL UTALITAS (Clear & Undo)
        if (showControls) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Tombol Undo (Urungkan goresan terakhir)
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[600],
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onPressed: () => controller.undo(),
                icon: const Icon(Icons.undo_rounded, size: 16),
                label: Text(
                  undoText,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 8),
              
              // Tombol Clear (Hapus semua goresan)
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFEF4444), // Warna merah rose alarm
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onPressed: () => controller.clear(),
                icon: const Icon(Icons.delete_outline_rounded, size: 16),
                label: Text(
                  clearText,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ]
      ],
    );
  }
}