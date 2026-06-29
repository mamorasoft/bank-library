import 'package:intl/intl.dart';

/// Format currency amount
///
/// [amount] The amount to format
/// [currency] Currency code (e.g., 'USD', 'EUR')
/// [locale] Locale string (e.g., 'en_US', 'id_ID')
String formatCurrency(double amount, [String currency = 'USD', String locale = 'en_US']) {
  try {
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: _getCurrencySymbol(currency),
      decimalDigits: 2,
    );
    return formatter.format(amount);
  } catch (e) {
    // Fallback formatting
    return '$currency ${amount.toStringAsFixed(2)}';
  }
}

/// Convert amount between currencies
///
/// [amount] The amount to convert
/// [fromCurrency] Source currency code
/// [toCurrency] Target currency code
/// [rates] Exchange rates map
double convertCurrency(
  double amount,
  String fromCurrency,
  String toCurrency,
  Map<String, double> rates,
) {
  if (fromCurrency == toCurrency) {
    return amount;
  }
  
  // Convert to base currency (USD) first, then to target currency
  final fromRate = rates[fromCurrency] ?? 1.0;
  final toRate = rates[toCurrency] ?? 1.0;
  
  final inUSD = amount / fromRate;
  return inUSD * toRate;
}

/// Parse currency string to number
///
/// [currencyString] String with currency formatting
double parseCurrency(String currencyString) {
  // Remove currency symbols and separators, keep decimal point
  final cleaned = currencyString.replaceAll(RegExp(r'[^0-9.-]'), '');
  return double.tryParse(cleaned) ?? 0.0;
}

/// Get currency symbol for currency code
String _getCurrencySymbol(String currency) {
  const symbols = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'JPY': '¥',
    'IDR': 'Rupiah',
    'SGD': 'S\$',
    'MYR': 'RM',
  };
  return symbols[currency] ?? currency;
}
