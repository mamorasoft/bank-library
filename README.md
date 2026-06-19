# Bank Library Monorepo

A comprehensive banking utilities library for multiple platforms including Laravel, Vue.js, and Flutter.

## Dokumentasi Penggunaan

Untuk panduan instalasi dan penggunaan cepat, silakan merujuk ke:
📖 **[Panduan Penggunaan Singkat (Quick Start Guide)](./docs/usage.md)**

## Structure

```
bank-library/
├── packages/
│   ├── laravel/          # Laravel/PHP package
│   ├── vuejs/            # Vue.js package
│   └── flutter/          # Flutter/Dart package
└── docs/                 # Shared documentation
```

## Packages

### Laravel Package

Banking utilities for Laravel applications including account validation, currency conversion, and more.

📦 [View Laravel Package Documentation](./packages/laravel/README.md)

**Installation:**
```bash
composer require bank-library/laravel
```

**Features:**
- Account number validation
- IBAN validation
- Currency formatting and conversion
- Laravel service provider integration

---

### Vue.js Package

Banking components and utilities for Vue.js 3 applications.

📦 [View Vue.js Package Documentation](./packages/vuejs/README.md)

**Installation:**
```bash
npm install @bank-library/vuejs
```

Jika belum di-publish ke registry, install langsung dari repo git ini — gunakan selector `#path:` agar npm hanya resolve `package.json` di `packages/vuejs`, bukan root monorepo (butuh npm ≥ 9):
```bash
npm install git+https://github.com/mamorasoft/bank-library.git#path:packages/vuejs
```

**Features:**
- BankAccountInput component
- CurrencyInput component
- Account validation functions
- Currency formatting and conversion
- TypeScript support

---

### Flutter Package

Banking widgets and utilities for Flutter applications.

📦 [View Flutter Package Documentation](./packages/flutter/README.md)

**Installation:**
```yaml
dependencies:
  bank_library: ^1.0.0
```

**Features:**
- BankAccountInput widget
- CurrencyInput widget
- Account validation functions
- Currency formatting and conversion

## Common Features

All packages provide:

1. **Account Validation**
   - Bank account number validation
   - IBAN validation
   - Account number formatting

2. **Currency Operations**
   - Currency formatting with locale support
   - Currency conversion
   - Amount parsing

3. **UI Components** (Vue.js & Flutter)
   - Validated bank account input
   - Formatted currency input
   - Real-time validation feedback
   - Currency conversion display

## Development

Each package can be developed independently. Navigate to the respective package directory for development instructions.

## License

MIT License - See individual packages for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
