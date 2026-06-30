import 'package:flutter/material.dart';

// ===========================================================================
// 1. GENERIC MODEL FOR DROPDOWN ITEM
// ===========================================================================
/// Model generic agar dropdown bisa menampung ID dan Nama objek sekaligus.
class PremiumDropdownItem<T> {
  final String label; // Teks yang muncul di layar (Misal: "Ahmad Fauzi")
  final T value;      // Data asli di belakang layar (Misal: ID Karyawan atau Object Karyawan)

  PremiumDropdownItem({required this.label, required this.value});
}

// ===========================================================================
// 2. PREMIUM STANDALONE DROPDOWN SEARCH WIDGET
// ===========================================================================
class PremiumDropdownSearch<T> extends StatelessWidget {
  final String label;
  final String hint;
  final List<PremiumDropdownItem<T>> items;
  final PremiumDropdownItem<T>? selectedItem;
  final Function(PremiumDropdownItem<T>?) onChanged;
  final IconData? prefixIcon;
  final bool isRequired;

  const PremiumDropdownSearch({
    Key? key,
    required this.label,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.selectedItem,
    this.prefixIcon,
    this.isRequired = false,
  }) : super(key: key);

  /// Fungsi untuk memunculkan Bottom Sheet Pencarian yang Premium
  void _showSearchBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    List<PremiumDropdownItem<T>> filteredItems = List.from(items);
    final searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Biar bottom sheet bisa naik saat keyboard muncul
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              // Otomatis menyesuaikan tinggi berdasarkan keyboard HP
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Garis Handle Atas Bottom Sheet
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Judul Bottom Sheet
                  Text(
                    "Pilih $label",
                    style: const TextStyle(
                      color: Color(0xFF1E293B),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // INPUT FIELD PENCARIAN (SEARCH BAR)
                  TextField(
                    controller: searchController,
                    onChanged: (query) {
                      // Filter data secara real-time
                      setModalState(() {
                        filteredItems = items
                            .where((item) => item.label
                                .toLowerCase()
                                .contains(query.toLowerCase()))
                            .toList();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Cari data di sini...",
                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.primaryColor, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // LIST HASIL DATA / PENCARIAN
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.4, // Batasi tinggi list maks 40% layar
                    ),
                    child: filteredItems.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32.0),
                            child: Center(
                              child: Text(
                                "Data tidak ditemukan",
                                style: TextStyle(color: Colors.grey[400], fontSize: 14),
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final isCurrentSelected = selectedItem?.label == item.label;

                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                                title: Text(
                                  item.label,
                                  style: TextStyle(
                                    color: isCurrentSelected ? theme.primaryColor : const Color(0xFF334155),
                                    fontWeight: isCurrentSelected ? FontWeight.bold : FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                trailing: isCurrentSelected
                                    ? Icon(Icons.check_circle_rounded, color: theme.primaryColor, size: 20)
                                    : null,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                onTap: () {
                                  onChanged(item);
                                  Navigator.pop(context); // Tutup sheet
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label Atas Input
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF334155),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (isRequired)
              const Text(" *", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),

        // BOX CONTAINER DROPDOWN (Yg menyerupai form input premium)
        InkWell(
          onTap: () => _showSearchBottomSheet(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                if (prefixIcon != null) ...[
                  Icon(prefixIcon, color: const Color(0xFF64748B), size: 20),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    selectedItem != null ? selectedItem!.label : hint,
                    style: TextStyle(
                      color: selectedItem != null ? const Color(0xFF1E293B) : Colors.grey[400],
                      fontSize: 14,
                      fontWeight: selectedItem != null ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey[500], size: 22),
              ],
            ),
          ),
        ),
      ],
    );
  }
}