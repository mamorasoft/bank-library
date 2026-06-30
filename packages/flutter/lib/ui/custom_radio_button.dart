import 'package:flutter/material.dart';

// ===========================================================================
// 1. GENERIC MODEL FOR RADIO OPTION
// ===========================================================================
class PremiumRadioOption<T> {
  final String label;       // Judul opsi (Misal: "Laki-laki", "Pekerja Tetap")
  final String? subtitle;   // Deskripsi tambahan (Opsional, hanya muncul di mode Card)
  final T value;           // Nilai asli untuk database (Misal: "L", 1, atau object)

  PremiumRadioOption({required this.label, required this.value, this.subtitle});
}

// ===========================================================================
// 2. PREMIUM STANDALONE RADIO GROUP WIDGET
// ===========================================================================
class PremiumRadioGroup<T> extends StatelessWidget {
  final String label;
  final List<PremiumRadioOption<T>> options;
  final T? selectedValue;
  final Function(T) onChanged;
  
  // Konfigurasi Fleksibilitas
  final bool isRequired;
  final bool useCardStyle;     // True = Card Mewah, False = Bulatan Compact biasa
  final bool isHorizontal;     // True = Menyamping, False = Menurun
  final double spacing;        // Jarak antar pilihan
  final Color? activeColor;

  const PremiumRadioGroup({
    Key? key,
    required this.label,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    this.isRequired = false,
    this.useCardStyle = true, // Default pakai gaya Card biar SaaS banget
    this.isHorizontal = true,
    this.spacing = 12.0,
    this.activeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = activeColor ?? theme.primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. LABEL UTAMA GROUP
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF334155), // Slate 700
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (isRequired)
              const Text(" *", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),

        // 2. WRAPPER DYNAMIC LAYOUT (Anti-Overflow Layar)
        Wrap(
          direction: isHorizontal ? Axis.horizontal : Axis.vertical,
          spacing: spacing, // Jarak horizontal antar item
          runSpacing: spacing, // Jarak vertikal kalau item nge-wrap ke bawah
          children: options.map((option) {
            final isSelected = selectedValue == option.value;

            // ==========================================
            // VARIASI A: GAYA CARD PREMIUM (MODERN)
            // ==========================================
            if (useCardStyle) {
              return InkWell(
                onTap: () => onChanged(option.value),
                borderRadius: BorderRadius.circular(14),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  // Jika mendatar, bagi space proporsional. Jika menurun, penuhi lebar layar.
                  width: isHorizontal ? (MediaQuery.of(context).size.width - 52) / 2 : double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected ? primaryColor.withOpacity(0.04) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? primaryColor : Colors.grey.withOpacity(0.2),
                      width: isSelected ? 1.8 : 1.2,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Indikator Lingkaran Radio Kustom Beranimasi halus
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? primaryColor : const Color(0xFF94A3B8),
                            width: isSelected ? 6 : 2, // Trik border tebal buat bikin efek titik tengah
                          ),
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // Teks Label & Subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              option.label,
                              style: TextStyle(
                                color: isSelected ? const Color(0xFF1E293B) : const Color(0xFF475569),
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                              ),
                            ),
                            if (option.subtitle != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                option.subtitle!,
                                style: TextStyle(
                                  color: isSelected ? primaryColor.withOpacity(0.7) : const Color(0xFF94A3B8),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // ==========================================
            // VARIASI B: GAYA COMPACT ROW (TRADISIONAL)
            // ==========================================
            return InkWell(
              onTap: () => onChanged(option.value),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? primaryColor : const Color(0xFF94A3B8),
                          width: isSelected ? 5 : 2,
                        ),
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      option.label,
                      style: TextStyle(
                        color: const Color(0xFF334155),
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}