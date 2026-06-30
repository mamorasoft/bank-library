import 'package:flutter/material.dart';

class PremiumAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final bool centerTitle;
  final bool showBackButton;
  
  // Widget kustom jika ingin mengganti leading (misal: foto profil di kiri)
  final Widget? leadingWidget;
  
  // List aksi di sebelah kanan (Bisa diisi ikon notifikasi, foto profil, dll)
  final List<Widget>? actions;
  
  // Fitur Instan Tombol Titik Tiga (PopupMenu)
  final bool showThreeDotMenu;
  final List<String>? threeDotItems;
  final Function(String)? onThreeDotSelected;

  final Color? backgroundColor;
  final double elevation;
  final bool showBottomBorder;

  const PremiumAppBar({
    Key? key,
    required this.title,
    this.subtitle,
    this.centerTitle = false,
    this.showBackButton = true,
    this.leadingWidget,
    this.actions,
    this.showThreeDotMenu = false,
    this.threeDotItems,
    this.onThreeDotSelected,
    this.backgroundColor,
    this.elevation = 0,
    this.showBottomBorder = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Siapkan list actions secara dinamis
    List<Widget> activeActions = [];
    if (actions != null) {
      activeActions.addAll(actions!);
    }

    // Jika showThreeDotMenu aktif, otomatis injeksi PopupMenuButton di paling kanan
    if (showThreeDotMenu && threeDotItems != null) {
      activeActions.add(
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert_rounded, color: Colors.grey[800]),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          onSelected: onThreeDotSelected,
          itemBuilder: (BuildContext context) {
            return threeDotItems!.map((String item) {
              return PopupMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              );
            }).toList();
          },
        ),
      );
    }

    return AppBar(
      backgroundColor: backgroundColor ?? Colors.white,
      elevation: elevation,
      centerTitle: centerTitle,
      
      // 1. SETTINGAN TOMBOL KIRI (LEADING)
      leading: leadingWidget ?? (showBackButton && Navigator.canPop(context)
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.grey[800], size: 20),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null),
      
      // 2. SETTINGAN JUDUL & SUBTITLE (STACKED CLEAN STYLE)
      title: Column(
        crossAxisAlignment: centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF1E293B), // Slate 800 premium
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ],
      ),
      
      // 3. SETTINGAN AKSI KANAN
      actions: activeActions,
      
      // 4. GARIS BAWAH HALUS (Biar layout kelihatan terstruktur rapi)
      bottom: showBottomBorder
          ? PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: Colors.grey.withOpacity(0.15),
                height: 1.0,
              ),
            )
          : null,
    );
  }

  // Wajib diisi karena implements PreferredSizeWidget
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}