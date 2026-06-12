/// Validate bank account number format
///
/// Returns true if the account number is valid
bool validateAccountNumber(String accountNumber, [String bankCode = '']) {
  // Remove any spaces or special characters
  final cleanNumber = accountNumber.replaceAll(RegExp(r'[^0-9]'), '');
  
  // Basic validation: account number should be between 8-16 digits
  if (cleanNumber.length < 8 || cleanNumber.length > 16) {
    return false;
  }
  
  return true;
}

/// Validate IBAN (International Bank Account Number)
///
/// Returns true if the IBAN is valid
bool validateIBAN(String iban) {
  final cleanIban = iban.toUpperCase().replaceAll(' ', '');
  
  if (cleanIban.length < 15 || cleanIban.length > 34) {
    return false;
  }
  
  // Move first 4 characters to the end
  final rearranged = cleanIban.substring(4) + cleanIban.substring(0, 4);
  
  // Replace letters with numbers (A=10, B=11, ..., Z=35)
  String numericIban = '';
  for (int i = 0; i < rearranged.length; i++) {
    final char = rearranged[i];
    if (RegExp(r'[A-Z]').hasMatch(char)) {
      numericIban += (char.codeUnitAt(0) - 'A'.codeUnitAt(0) + 10).toString();
    } else {
      numericIban += char;
    }
  }
  
  // Calculate mod 97
  BigInt remainder = BigInt.parse(numericIban);
  return remainder % BigInt.from(97) == BigInt.one;
}

/// Format account number with spaces for readability
///
/// [groupSize] specifies number of digits per group (default: 4)
String formatAccountNumber(String accountNumber, [int groupSize = 4]) {
  final cleanNumber = accountNumber.replaceAll(RegExp(r'[^0-9]'), '');
  final regex = RegExp('.{1,$groupSize}');
  return regex.allMatches(cleanNumber).map((m) => m.group(0)).join(' ');
}
