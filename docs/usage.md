# Panduan Penggunaan Singkat (Quick Start Guide)

Dokumen ini berisi panduan singkat cara instalasi dan penggunaan **Bank Library** di berbagai platform (Laravel, Vue.js, dan Flutter).

---

## 🐘 Laravel Package

### 1. Instalasi
```bash
composer require bank-library/laravel
```

### 2. Publish Konfigurasi (Opsional)
```bash
php artisan vendor:publish --tag=bank-config
```

### 3. Contoh Penggunaan Utama
```php
use BankLibrary\Laravel\Function\AccountValidator;
use BankLibrary\Laravel\Function\CurrencyConverter;

// Validasi Nomor Rekening
$isValid = AccountValidator::validateAccountNumber('1234567890'); // true/false
$isValidIban = AccountValidator::validateIBAN('GB82WEST12345698765432');

// Format & Konversi Mata Uang
$formatted = CurrencyConverter::formatCurrency(1234.56, 'USD', 'en_US'); // "$1,234.56"
$converted = CurrencyConverter::convert(100, 'USD', 'EUR', ['USD' => 1, 'EUR' => 0.85]); // 85.0
```

---

## 🟢 Vue.js Package (Vue 3)

### 1. Instalasi
```bash
npm install @bank-library/vuejs
```

### 2. Registrasi Global (di `main.js` / `main.ts`)
```javascript
import { createApp } from 'vue';
import BankLibrary from '@bank-library/vuejs';
import App from './App.vue';

const app = createApp(App);
app.use(BankLibrary); // Mendaftarkan komponen, directive v-rupiah, & global helper
app.mount('#app');
```

### 3. Penggunaan di Komponen
```vue
<script setup>
import { ref } from 'vue';
import { parseRupiah } from '@bank-library/vuejs';

const accountNumber = ref('');
const nominal = ref(''); // Di-bind dengan v-rupiah
const amount = ref(0);
</script>

<template>
  <!-- Input Nomor Rekening -->
  <BankAccountInput v-model="accountNumber" label="No. Rekening" :show-validation="true" />

  <!-- Input Rupiah Otomatis (Menggunakan Directive) -->
  <input v-model="nominal" v-rupiah placeholder="Rp. 0" />
  
  <!-- Input Mata Uang Asing -->
  <CurrencyInput v-model="amount" label="Amount" currency="USD" locale="en-US" />
</template>
```

### 4. API Request Wrapper (`callApi`)
Fungsi helper untuk melakukan HTTP requests menggunakan **Axios**. Fungsi ini otomatis:
1. Menyuntikkan token otentikasi Bearer jika ada `'token'` di `localStorage`.
2. Mendeteksi jika terdapat data ber-tipe `File` atau `Blob` dalam object payload, lalu mengonversinya ke `FormData` (untuk upload file).

```vue
<script setup>
import { callApi } from '@bank-library/vuejs';

async function simpanData(fileData) {
  // GET request dengan Query Params
  const responseGet = await callApi('GET', '/api/users', null, { page: 1, limit: 10 });

  // POST request dengan JSON body payload
  const responsePost = await callApi('POST', '/api/users', { name: 'Andi' });

  // POST request dengan file (otomatis dikonversi ke FormData/multipart)
  const responseUpload = await callApi('POST', '/api/upload', {
    name: 'dokumen.pdf',
    file: fileData // objek File / Blob
  });
}
</script>
```

---


## 💙 Flutter Package

### 1. Instalasi (`pubspec.yaml`)
```yaml
dependencies:
  bank_library: ^1.0.0
```
*Kemudian jalankan `flutter pub get`.*

### 2. Penggunaan Widget UI
```dart
import 'package:bank_library/bank_library.dart';

// Widget Input Rekening
BankAccountInput(
  label: 'No. Rekening',
  required: true,
  showValidation: true,
  onChanged: (val) => print(val),
  onValidate: (isValid) => print(isValid),
)

// Widget Input Currency
CurrencyInput(
  label: 'Nominal',
  currency: 'IDR',
  locale: 'id_ID',
  onChanged: (val) => print(val),
)
```

### 3. Fungsi Utilitas
```dart
import 'package:bank_library/functions/functions.dart';

// Validasi
bool isValid = validateAccountNumber('1234567890');

// Formatting
String formattedAmount = formatCurrency(50000, 'IDR', 'id_ID'); // "Rp50.000,00"
```
