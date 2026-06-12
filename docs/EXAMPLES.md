# Bank Library - Usage Examples

This document provides practical examples of using the Bank Library across different platforms.

## Table of Contents

1. [Laravel Examples](#laravel-examples)
2. [Vue.js Examples](#vuejs-examples)
3. [Flutter Examples](#flutter-examples)

---

## Laravel Examples

### Basic Account Validation

```php
<?php

use BankLibrary\Laravel\Function\AccountValidator;

// Validate a simple account number
$accountNumber = '1234567890';
$isValid = AccountValidator::validateAccountNumber($accountNumber);

if ($isValid) {
    echo "Valid account number";
} else {
    echo "Invalid account number";
}

// Validate with bank code
$isValid = AccountValidator::validateAccountNumber('1234567890', 'BCA');
```

### IBAN Validation

```php
<?php

use BankLibrary\Laravel\Function\AccountValidator;

$iban = 'GB82WEST12345698765432';
$isValid = AccountValidator::validateIBAN($iban);

if ($isValid) {
    echo "Valid IBAN";
}
```

### Currency Formatting in Laravel Controller

```php
<?php

namespace App\Http\Controllers;

use BankLibrary\Laravel\Function\CurrencyConverter;
use Illuminate\Http\Request;

class PaymentController extends Controller
{
    public function show($amount)
    {
        // Format currency for display
        $formatted = CurrencyConverter::formatCurrency($amount, 'USD', 'en_US');
        
        return view('payment.show', [
            'amount' => $formatted
        ]);
    }
    
    public function convert(Request $request)
    {
        $amount = $request->input('amount');
        $from = $request->input('from');
        $to = $request->input('to');
        
        // Get exchange rates (from API or database)
        $rates = [
            'USD' => 1,
            'EUR' => 0.85,
            'IDR' => 15000,
        ];
        
        $converted = CurrencyConverter::convert($amount, $from, $to, $rates);
        
        return response()->json([
            'original' => $amount,
            'converted' => $converted,
            'formatted' => CurrencyConverter::formatCurrency($converted, $to)
        ]);
    }
}
```

---

## Vue.js Examples

### Basic Component Usage

```vue
<template>
  <div class="payment-form">
    <h2>Payment Information</h2>
    
    <BankAccountInput
      v-model="accountNumber"
      label="Bank Account Number"
      :required="true"
      :show-validation="true"
      error-message="Please enter a valid account number"
      @validate="handleAccountValidation"
    />
    
    <CurrencyInput
      v-model="amount"
      label="Amount"
      :required="true"
      currency="USD"
      locale="en-US"
      :show-converted="true"
      converted-currency="EUR"
      :conversion-rate="0.85"
    />
    
    <button @click="submitPayment" :disabled="!isFormValid">
      Submit Payment
    </button>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { BankAccountInput, CurrencyInput } from '@bank-library/vuejs';

const accountNumber = ref('');
const amount = ref(0);
const isFormValid = ref(false);

function handleAccountValidation(isValid: boolean) {
  isFormValid.value = isValid && amount.value > 0;
}

function submitPayment() {
  console.log('Payment submitted:', {
    accountNumber: accountNumber.value,
    amount: amount.value,
  });
}
</script>
```

### Using Functions Directly

```vue
<script setup lang="ts">
import {
  validateAccountNumber,
  validateIBAN,
  formatAccountNumber,
  formatCurrency,
  convertCurrency,
} from '@bank-library/vuejs';

// Account validation
const accountNumber = '1234567890';
const isValid = validateAccountNumber(accountNumber);
console.log('Is valid:', isValid);

// IBAN validation
const iban = 'GB82WEST12345698765432';
const isValidIBAN = validateIBAN(iban);
console.log('IBAN is valid:', isValidIBAN);

// Format account number
const formatted = formatAccountNumber('1234567890');
console.log('Formatted:', formatted); // "1234 5678 90"

// Currency operations
const formattedAmount = formatCurrency(1234.56, 'USD', 'en-US');
console.log('Formatted amount:', formattedAmount); // "$1,234.56"

const rates = { USD: 1, EUR: 0.85, IDR: 15000 };
const converted = convertCurrency(100, 'USD', 'EUR', rates);
console.log('Converted:', converted); // 85
</script>
```

---

## Flutter Examples

### Basic Widget Usage

```dart
import 'package:flutter/material.dart';
import 'package:bank_library/bank_library.dart';

class PaymentForm extends StatefulWidget {
  @override
  _PaymentFormState createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  String accountNumber = '';
  double amount = 0.0;
  bool isFormValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment Form')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            BankAccountInput(
              label: 'Bank Account Number',
              required: true,
              showValidation: true,
              errorMessage: 'Please enter a valid account number',
              onChanged: (value) {
                setState(() {
                  accountNumber = value;
                });
              },
              onValidate: (isValid) {
                setState(() {
                  isFormValid = isValid && amount > 0;
                });
              },
            ),
            SizedBox(height: 16),
            CurrencyInput(
              label: 'Amount',
              required: true,
              currency: 'USD',
              locale: 'en_US',
              showConverted: true,
              convertedCurrency: 'EUR',
              conversionRate: 0.85,
              onChanged: (value) {
                setState(() {
                  amount = value;
                  isFormValid = value > 0 && accountNumber.isNotEmpty;
                });
              },
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: isFormValid ? submitPayment : null,
              child: Text('Submit Payment'),
            ),
          ],
        ),
      ),
    );
  }

  void submitPayment() {
    print('Payment submitted:');
    print('Account: $accountNumber');
    print('Amount: $amount');
  }
}
```

### Using Functions Directly

```dart
import 'package:bank_library/functions/functions.dart';

void main() {
  // Account validation
  String accountNumber = '1234567890';
  bool isValid = validateAccountNumber(accountNumber);
  print('Is valid: $isValid');
  
  // IBAN validation
  String iban = 'GB82WEST12345698765432';
  bool isValidIBAN = validateIBAN(iban);
  print('IBAN is valid: $isValidIBAN');
  
  // Format account number
  String formatted = formatAccountNumber('1234567890');
  print('Formatted: $formatted'); // "1234 5678 90"
  
  // Currency operations
  String formattedAmount = formatCurrency(1234.56, 'USD', 'en_US');
  print('Formatted amount: $formattedAmount'); // "\$1,234.56"
  
  Map<String, double> rates = {
    'USD': 1.0,
    'EUR': 0.85,
    'IDR': 15000.0,
  };
  double converted = convertCurrency(100, 'USD', 'EUR', rates);
  print('Converted: $converted'); // 85.0
}
```

### Complete Payment App Example

```dart
import 'package:flutter/material.dart';
import 'package:bank_library/bank_library.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bank Library Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PaymentScreen(),
    );
  }
}

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String accountNumber = '';
  double amount = 0.0;
  bool isAccountValid = false;
  
  final Map<String, double> exchangeRates = {
    'USD': 1.0,
    'EUR': 0.85,
    'GBP': 0.73,
    'IDR': 15000.0,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('International Payment'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter Payment Details',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 24),
            BankAccountInput(
              label: 'Recipient Account Number',
              placeholder: 'Enter account number',
              required: true,
              showValidation: true,
              errorMessage: 'Invalid account number (8-16 digits)',
              onChanged: (value) {
                setState(() {
                  accountNumber = value;
                });
              },
              onValidate: (isValid) {
                setState(() {
                  isAccountValid = isValid;
                });
              },
            ),
            SizedBox(height: 20),
            CurrencyInput(
              label: 'Amount (USD)',
              placeholder: '0.00',
              required: true,
              currency: 'USD',
              locale: 'en_US',
              showConverted: true,
              convertedCurrency: 'EUR',
              conversionRate: exchangeRates['EUR']!,
              onChanged: (value) {
                setState(() {
                  amount = value;
                });
              },
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: (isAccountValid && amount > 0)
                  ? () => processPayment()
                  : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('Process Payment'),
            ),
          ],
        ),
      ),
    );
  }

  void processPayment() {
    final formattedAmount = formatCurrency(amount, 'USD', 'en_US');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Account: ${formatAccountNumber(accountNumber)}'),
            SizedBox(height: 8),
            Text('Amount: $formattedAmount'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Payment processed successfully!')),
              );
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
```

---

## Common Patterns

### Multi-Currency Support

All platforms support multiple currencies with proper formatting:

**Supported Currencies:**
- USD - US Dollar
- EUR - Euro
- GBP - British Pound
- JPY - Japanese Yen
- IDR - Indonesian Rupiah
- SGD - Singapore Dollar
- MYR - Malaysian Ringgit

### Error Handling

Always validate user input before processing:

```typescript
// Vue.js
if (!validateAccountNumber(accountNumber)) {
  showError('Invalid account number');
  return;
}
```

```dart
// Flutter
if (!validateAccountNumber(accountNumber)) {
  showError('Invalid account number');
  return;
}
```

### Real-time Exchange Rates

Fetch exchange rates from an API:

```typescript
// Vue.js
async function fetchRates() {
  const response = await fetch('https://api.exchangerate.com/rates');
  const data = await response.json();
  return data.rates;
}
```
