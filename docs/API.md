# Bank Library API Documentation

This document provides a comprehensive overview of the APIs available across all Bank Library packages.

## Table of Contents

1. [Account Validation](#account-validation)
2. [Currency Operations](#currency-operations)
3. [UI Components](#ui-components)

---

## Account Validation

### validateAccountNumber

Validates a bank account number format.

**Laravel (PHP):**
```php
AccountValidator::validateAccountNumber(string $accountNumber, string $bankCode = ''): bool
```

**Vue.js (TypeScript):**
```typescript
validateAccountNumber(accountNumber: string, bankCode: string = ''): boolean
```

**Flutter (Dart):**
```dart
bool validateAccountNumber(String accountNumber, [String bankCode = ''])
```

**Parameters:**
- `accountNumber`: The account number to validate (8-16 digits)
- `bankCode`: Optional bank code for additional validation

**Returns:** Boolean indicating validity

**Example:**
```php
// PHP
$isValid = AccountValidator::validateAccountNumber('1234567890');
```

```typescript
// TypeScript
const isValid = validateAccountNumber('1234567890');
```

```dart
// Dart
bool isValid = validateAccountNumber('1234567890');
```

---

### validateIBAN

Validates an International Bank Account Number (IBAN).

**Laravel (PHP):**
```php
AccountValidator::validateIBAN(string $iban): bool
```

**Vue.js (TypeScript):**
```typescript
validateIBAN(iban: string): boolean
```

**Flutter (Dart):**
```dart
bool validateIBAN(String iban)
```

**Parameters:**
- `iban`: The IBAN to validate (15-34 characters)

**Returns:** Boolean indicating validity

**Example:**
```php
// PHP
$isValid = AccountValidator::validateIBAN('GB82WEST12345698765432');
```

---

### formatAccountNumber

Formats an account number with spaces for readability.

**Vue.js (TypeScript):**
```typescript
formatAccountNumber(accountNumber: string, groupSize: number = 4): string
```

**Flutter (Dart):**
```dart
String formatAccountNumber(String accountNumber, [int groupSize = 4])
```

**Parameters:**
- `accountNumber`: The account number to format
- `groupSize`: Number of digits per group (default: 4)

**Returns:** Formatted account number string

**Example:**
```typescript
// TypeScript
const formatted = formatAccountNumber('1234567890'); // "1234 5678 90"
```

---

## Currency Operations

### formatCurrency

Formats a currency amount with proper locale formatting.

**Laravel (PHP):**
```php
CurrencyConverter::formatCurrency(float $amount, string $currency = 'USD', string $locale = 'en_US'): string
```

**Vue.js (TypeScript):**
```typescript
formatCurrency(amount: number, currency: string = 'USD', locale: string = 'en-US'): string
```

**Flutter (Dart):**
```dart
String formatCurrency(double amount, [String currency = 'USD', String locale = 'en_US'])
```

**Parameters:**
- `amount`: The numeric amount
- `currency`: Currency code (ISO 4217, e.g., 'USD', 'EUR')
- `locale`: Locale string (e.g., 'en_US', 'id_ID')

**Returns:** Formatted currency string

**Example:**
```php
// PHP
$formatted = CurrencyConverter::formatCurrency(1234.56, 'USD', 'en_US');
// Output: "$1,234.56"
```

```typescript
// TypeScript
const formatted = formatCurrency(1234.56, 'USD', 'en-US');
// Output: "$1,234.56"
```

---

### convertCurrency

Converts an amount between currencies using exchange rates.

**Laravel (PHP):**
```php
CurrencyConverter::convert(float $amount, string $fromCurrency, string $toCurrency, array $rates): float
```

**Vue.js (TypeScript):**
```typescript
convertCurrency(amount: number, fromCurrency: string, toCurrency: string, rates: ExchangeRates): number
```

**Flutter (Dart):**
```dart
double convertCurrency(double amount, String fromCurrency, String toCurrency, Map<String, double> rates)
```

**Parameters:**
- `amount`: The amount to convert
- `fromCurrency`: Source currency code
- `toCurrency`: Target currency code
- `rates`: Exchange rates object/map (relative to USD or base currency)

**Returns:** Converted amount

**Example:**
```php
// PHP
$rates = ['USD' => 1, 'EUR' => 0.85, 'IDR' => 15000];
$converted = CurrencyConverter::convert(100, 'USD', 'EUR', $rates);
// Output: 85.0
```

---

### parseCurrency

Parses a formatted currency string to a numeric value.

**Vue.js (TypeScript):**
```typescript
parseCurrency(currencyString: string): number
```

**Flutter (Dart):**
```dart
double parseCurrency(String currencyString)
```

**Parameters:**
- `currencyString`: String with currency formatting

**Returns:** Numeric value

**Example:**
```typescript
// TypeScript
const amount = parseCurrency('$1,234.56'); // 1234.56
```

---

## UI Components

### BankAccountInput

A validated input component/widget for bank account numbers.

> **Note (Vue.js):** this component is **unstyled by default** — no colors, borders,
> or spacing are applied out of the box. Style it entirely with your own CSS/classes.

**Vue.js Component:**
```vue
<BankAccountInput
  v-model="accountNumber"
  label="Account Number"
  placeholder="Enter account number"
  :required="true"
  :show-validation="true"
  error-message="Invalid account number"
  bank-code="BCA"
  class="my-input-style"
  wrapper-class="my-wrapper-style"
  label-class="my-label-style"
  error-class="my-error-style"
  validation-icon-class="my-icon-style"
  @validate="handleValidation"
/>
```

**Flutter Widget:**
```dart
BankAccountInput(
  label: 'Account Number',
  placeholder: 'Enter account number',
  initialValue: '1234567890',
  required: true,
  showValidation: true,
  errorMessage: 'Invalid account number',
  bankCode: 'BCA',
  decoration: InputDecoration(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
  ),
  style: const TextStyle(fontSize: 16),
  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
  onChanged: (value) => print(value),
  onValidate: (isValid) => print(isValid),
)
```

**Props/Parameters:**
- `label`: Label text
- `placeholder`: Placeholder text
- `required`: Mark as required
- `showValidation`: Show validation icon/indicator
- `errorMessage`: Custom error message
- `bankCode`: Bank code for validation
- `class` / `style` *(Vue, native attrs)*: forwarded directly to the `<input>` element
- `wrapperClass`, `labelClass`, `errorClass`, `validationIconClass` *(Vue)*: extra
  classes applied to the wrapper `<div>`, `<label>`, error message, and validation
  icon respectively
- `decoration` *(Flutter, `InputDecoration?`)*: merged on top of the default
  decoration via `copyWith()` — only the fields you set are overridden, the rest
  (hint text, validation suffix icon, error text) keep their default behavior
- `style`, `labelStyle`, `errorStyle` *(Flutter, `TextStyle?`)*: merged with default
  text styles via `TextStyle.merge()`

---

### CurrencyInput

A formatted input component/widget for currency amounts.

> **Note (Vue.js):** this component is **unstyled by default** — style it entirely
> with your own CSS/classes, see `BankAccountInput` above for the same pattern.

**Vue.js Component:**
```vue
<CurrencyInput
  v-model="amount"
  label="Amount"
  placeholder="0.00"
  :required="true"
  currency="USD"
  locale="en-US"
  :show-converted="true"
  converted-currency="EUR"
  :conversion-rate="0.85"
  class="my-input-style"
  wrapper-class="my-wrapper-style"
  label-class="my-label-style"
  currency-symbol-class="my-symbol-style"
  converted-amount-class="my-converted-style"
/>
```

**Flutter Widget:**
```dart
CurrencyInput(
  label: 'Amount',
  placeholder: '0.00',
  initialValue: 100.0,
  required: true,
  currency: 'USD',
  locale: 'en_US',
  showConverted: true,
  convertedCurrency: 'EUR',
  conversionRate: 0.85,
  decoration: InputDecoration(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
  ),
  style: const TextStyle(fontSize: 16),
  convertedAmountStyle: const TextStyle(fontSize: 14, color: Colors.blue),
  onChanged: (value) => print(value),
)
```

**Props/Parameters:**
- `label`: Label text
- `placeholder`: Placeholder text
- `required`: Mark as required
- `currency`: Currency code
- `locale`: Locale string
- `showConverted`: Show converted amount
- `convertedCurrency`: Target currency for conversion
- `conversionRate`: Exchange rate
- `class` / `style` *(Vue, native attrs)*: forwarded directly to the `<input>` element
- `wrapperClass`, `labelClass`, `currencySymbolClass`, `convertedAmountClass` *(Vue)*:
  extra classes applied to the wrapper, label, currency symbol, and converted amount
  text respectively
- `decoration` *(Flutter, `InputDecoration?`)*: merged on top of the default
  decoration via `copyWith()`
- `style`, `labelStyle`, `convertedAmountStyle` *(Flutter, `TextStyle?`)*: merged with
  default text styles via `TextStyle.merge()`

---

### RupiahInput

A Rupiah-formatted input component (Vue.js only), following the same override
pattern as `BankAccountInput` and `CurrencyInput` above.

> **Note:** unstyled by default — style it entirely with your own CSS/classes.

**Vue.js Component:**
```vue
<RupiahInput
  v-model="amount"
  label="Jumlah"
  error="Wajib diisi"
  class="my-input-style"
  wrapper-class="my-wrapper-style"
  label-class="my-label-style"
  error-class="my-error-style"
/>
```

**Props/Parameters:**
- `class` / `style` *(native attrs)*: forwarded directly to the `<input>` element
- `wrapperClass`, `labelClass`, `errorClass`: extra classes applied to the wrapper
  `<div>`, `<label>`, and error message respectively

---

## Supported Currencies

All packages support standard ISO 4217 currency codes:

- USD - United States Dollar
- EUR - Euro
- GBP - British Pound
- JPY - Japanese Yen
- IDR - Indonesian Rupiah
- SGD - Singapore Dollar
- MYR - Malaysian Ringgit
- And many more...

## Error Handling

All validation functions return boolean values. Components provide built-in error handling with customizable error messages.

## Locale Support

Currency formatting supports all standard locale identifiers:
- `en_US` / `en-US` - English (United States)
- `id_ID` / `id-ID` - Indonesian
- `en_GB` / `en-GB` - English (United Kingdom)
- And more...
