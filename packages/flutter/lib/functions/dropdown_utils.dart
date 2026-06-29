import 'package:flutter/material.dart';

class DropdownUtil {
  /// 1. Generate dari List String Biasa
  /// Sangat cocok untuk dropdown statis.
  /// Contoh data: ['Laki-laki', 'Perempuan', 'Lainnya']
  static List<DropdownMenuItem<String>> fromStringList(List<String> items) {
    return items.map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
  }

  /// 2. Generate dari Map (Key-Value)
  /// Cocok jika value yang dikirim ke database berbeda dengan teks di layar.
  /// Contoh data: { 1: 'Admin', 2: 'Staff', 3: 'User' }
  static List<DropdownMenuItem<T>> fromMap<T>(Map<T, String> mapItems) {
    return mapItems.entries.map((entry) {
      return DropdownMenuItem<T>(
        value: entry.key,
        child: Text(entry.value),
      );
    }).toList();
  }

  /// 3. Generate dari List JSON / Data API (FUNGSI SAKTI)
  /// Sangat cocok saat menarik data dinamis dari Supabase/Database.
  /// Bosku tinggal sebutkan nama kolom untuk 'value' dan kolom untuk 'label'.
  static List<DropdownMenuItem<dynamic>> fromApiData({
    required List<Map<String, dynamic>> dataList,
    required String valueKey,
    required String labelKey,
  }) {
    return dataList.map((item) {
      return DropdownMenuItem<dynamic>(
        value: item[valueKey],
        child: Text(item[labelKey].toString()), // Pastikan jadi string untuk UI
      );
    }).toList();
  }
}