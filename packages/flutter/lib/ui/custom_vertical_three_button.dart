import 'package:flutter/material.dart';

// ===========================================================================
// 1. GENERIC MODEL UNTUK ITEM MENU
// ===========================================================================
class PremiumPopupItem<T> {
  final String title;       // Teks menu (Misal: "Edit Data")
  final T value;           // Nilai di balik layar (Misal: String 'edit', atau Enum)
  final IconData? icon;     // Ikon samping teks (Opsional)
  final bool isDestructive; // Jika true, otomatis berubah merah (Misal: Menu Hapus)

  PremiumPopupItem({
    required this.title,
    required this.value,
    this.icon,
    this.isDestructive = false,
  });
}

// ===========================================================================
// 2. PREMIUM STANDALONE POPUP MENU WIDGET
// ===========================================================================
class PremiumPopupMenu<T> extends StatelessWidget {
  final List<PremiumPopupItem<T>> items;
  final Function(T) onSelected;
  final IconData icon;
  final Color? iconColor;
  final double iconSize;

  const PremiumPopupMenu({
    Key? key,
    required this.items,
    required this.onSelected,
    this.icon = Icons.more_vert_rounded, // Default pakai titik tiga vertikal membulat
    this.iconColor,
    this.iconSize = 22.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      // Gaya ikon pemicu (Titik Tiga)
      icon: Icon(
        icon,
        color: iconColor ?? const Color(0xFF64748B), // Slate 500 premium
        size: iconSize,
      ),
      // Efek visual box popup yang melayang mewah
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      color: Colors.white,
      elevation: 6,
      offset: const Offset(0, 4), // Geser sedikit ke bawah biar gak nutupin tombol titik tiganya
      onSelected: onSelected,
      itemBuilder: (BuildContext context) {
        return items.map((PremiumPopupItem<T> item) {
          // Atur warna dinamis. Kalau merusak/destructive pakai warna merah rose.
          final Color activeColor = item.isDestructive 
              ? const Color(0xFFEF4444) // Red 500
              : const Color(0xFF334155); // Slate 700

          return PopupMenuItem<T>(
            value: item.value,
            height: 42, // Tinggi baris yang ideal dan pas
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Render ikon jika diisi
                if (item.icon != null) ...[
                  Icon(item.icon, color: activeColor, size: 18),
                  const SizedBox(width: 12),
                ],
                // Teks Menu
                Text(
                  item.title,
                  style: TextStyle(
                    color: activeColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}