# Bank Library - Laravel Package

A comprehensive banking utilities package for Laravel applications.

## Installation

```bash
composer require bank-library/laravel
```

## Configuration

Publish the configuration file:

```bash
php artisan vendor:publish --tag=bank-config
```

## Features

### Account Validation

Validate bank account numbers and IBAN:

```php
use BankLibrary\Laravel\Function\AccountValidator;

// Validate account number
$isValid = AccountValidator::validateAccountNumber('1234567890');

// Validate IBAN
$isValid = AccountValidator::validateIBAN('GB82WEST12345698765432');
```

### Currency Conversion

Format and convert currencies:

```php
use BankLibrary\Laravel\Function\CurrencyConverter;

// Format currency
$formatted = CurrencyConverter::formatCurrency(1234.56, 'USD', 'en_US');
// Output: $1,234.56

// Convert between currencies
$rates = ['USD' => 1, 'EUR' => 0.85, 'IDR' => 15000];
$converted = CurrencyConverter::convert(100, 'USD', 'EUR', $rates);
```

## Requirements

- PHP ^8.1
- Laravel ^10.0 or ^11.0

## License

MIT
