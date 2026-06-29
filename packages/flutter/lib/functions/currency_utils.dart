import 'package:intl/intl.dart';

class CurrencyUtil {
  static String formatToRupiah(dynamic amount, {bool withSymbol = true, int decimalDigits = 0}) {
    if (amount == null) return withSymbol ? 'Rp 0' : '0';

    try {
      num value = _parseToNum(amount);
      
      final format = NumberFormat.currency(
        locale: 'id_ID',
        symbol: withSymbol ? 'Rp ' : '',
        decimalDigits: decimalDigits,
      );
      
      return format.format(value);
    } catch (e) {
      return withSymbol ? 'Rp 0' : '0';
    }
  }

 
  static String formatCompactRupiah(dynamic amount) {
    if (amount == null) return 'Rp 0';

    try {
      num value = _parseToNum(amount);
      
      final format = NumberFormat.compactCurrency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 1, 
      );
      
      return format.format(value);
    } catch (e) {
      return 'Rp 0';
    }
  }

  static int cleanNumberInput(String input) {
    if (input.isEmpty) return 0;
    
    String cleanString = input.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(cleanString) ?? 0;
  }

  static num _parseToNum(dynamic value) {
    if (value is num) return value;
    if (value is String) return num.tryParse(value) ?? 0;
    return 0;
  }
}