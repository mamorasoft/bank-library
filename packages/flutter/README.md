# Bank Library - Flutter Package

A comprehensive banking utilities package for Flutter applications.

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  bank_library: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Import the package

```dart
import 'package:bank_library/bank_library.dart';
```

## Components

### BankAccountInput

A validated input widget for bank account numbers.

```dart
BankAccountInput(
  label: 'Account Number',
  placeholder: 'Enter account number',
  required: true,
  showValidation: true,
  errorMessage: 'Invalid account number',
  bankCode: 'BCA',
  onChanged: (value) {
    print('Account number: $value');
  },
  onValidate: (isValid) {
    print('Is valid: $isValid');
  },
)
```

**Properties:**
- `label`: Label text for the input
- `placeholder`: Placeholder text
- `initialValue`: Initial value
- `required`: Mark as required field
- `showValidation`: Show validation icon
- `errorMessage`: Custom error message
- `bankCode`: Bank code for validation
- `onChanged`: Callback when value changes
- `onValidate`: Callback when validation state changes

### CurrencyInput

A formatted input widget for currency amounts.

```dart
CurrencyInput(
  label: 'Amount',
  placeholder: '0.00',
  required: true,
  currency: 'USD',
  locale: 'en_US',
  showConverted: true,
  convertedCurrency: 'EUR',
  conversionRate: 0.85,
  onChanged: (value) {
    print('Amount: $value');
  },
)
```

**Properties:**
- `label`: Label text for the input
- `placeholder`: Placeholder text
- `initialValue`: Initial numeric value
- `required`: Mark as required field
- `currency`: Currency code (e.g., 'USD')
- `locale`: Locale string (e.g., 'en_US')
- `showConverted`: Show converted amount
- `convertedCurrency`: Target currency for conversion
- `conversionRate`: Exchange rate
- `onChanged`: Callback when value changes

## Functions

### Account Validation

```dart
import 'package:bank_library/functions/functions.dart';

// Validate account number
bool isValid = validateAccountNumber('1234567890');

// Validate IBAN
bool isValidIBAN = validateIBAN('GB82WEST12345698765432');

// Format account number
String formatted = formatAccountNumber('1234567890'); // "1234 5678 90"
```

### Currency Functions

```dart
import 'package:bank_library/functions/functions.dart';

// Format currency
String formatted = formatCurrency(1234.56, 'USD', 'en_US'); // "\$1,234.56"

// Convert currency
Map<String, double> rates = {'USD': 1.0, 'EUR': 0.85, 'IDR': 15000.0};
double converted = convertCurrency(100, 'USD', 'EUR', rates); // 85.0

// Parse currency string
double amount = parseCurrency('\$1,234.56'); // 1234.56
```

## Requirements

- Flutter >=3.0.0
- Dart SDK >=3.0.0 <4.0.0

## License

MIT
