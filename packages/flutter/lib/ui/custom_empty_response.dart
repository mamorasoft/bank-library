import 'package:flutter/material.dart';

class CustomEmptyResponse extends StatelessWidget {
  final String title;
  final String? subtitle;
  
  // Slot untuk visual (Bisa Ikon, Gambar Asset, Svg, atau kosong)
  final IconData? icon;
  final Widget? customImage;
  
  // Slot untuk Tombol Aksi (Opsional)
  final String? actionButtonText;
  final VoidCallback? onActionPressed;
  
  // Kustomisasi Warna & Ukuran
  final Color? iconColor;
  final double iconSize;
  final EdgeInsetsGeometry padding;

  const CustomEmptyResponse({
    Key? key,
    this.title = "Tidak Ada Data",
    this.subtitle,
    this.icon = Icons.folder_open_outlined, // Default pakai icon folder kosong elegan
    this.customImage,
    this.actionButtonText,
    this.onActionPressed,
    this.iconColor,
    this.iconSize = 70.0,
    this.padding = const EdgeInsets.all(32.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: padding,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. BAGIAN VISUAL (Prioritaskan customImage jika ada, kalau tidak ada pakai Icon)
            if (customImage != null)
              customImage!
            else if (icon != null)
              Icon(
                icon,
                size: iconSize,
                color: iconColor ?? theme.hintColor.withOpacity(0.4),
              ),
            
            const SizedBox(height: 20),
            
            // 2. TEXT TITLE
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF1E293B), // Warna Slate 800 premium
                fontSize: 16,
                // fontWeight: FontWeight.wait700,
                letterSpacing: -0.2,
              ),
            ),
            
            // 3. TEXT SUBTITLE (Hanya muncul jika diisi)
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
            ],
            
            // 4. ACTION BUTTON (Hanya muncul jika teks & fungsi aksi diisi)
            if (actionButtonText != null && onActionPressed != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: onActionPressed,
                child: Text(
                  actionButtonText!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}