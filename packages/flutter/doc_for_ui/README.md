# Bank Library — Flutter UI Components

Dokumentasi lengkap semua widget UI di `packages/flutter/lib/ui/`.

**Impor widget:**

```dart
import 'package:bank_library/ui.dart';
```

---

## Table of Contents

1. [Navigation](#navigation) — AppBar, Pagination, Vertical Menu
2. [Inputs](#inputs) — TextField, Dropdown Search, File Picker, Signature, Bank Account, Currency
3. [Buttons](#buttons) — Standard, Flat, Icon, Outline
4. [Layout](#layout) — Container, Calendar, Carousel, List Template
5. [Feedback](#feedback) — Dialog, Loading, Skeleton, Empty State, Image
6. [Popups](#popups) — Popup Menu, Radio Group
7. [Color Palette](#color-palette)

---

## Navigation

### PremiumAppBar

AppBar bergaya premium dengan stacked title/subtitle, auto back button, dan optional 3-dot menu.

**Konstruktor:**

| Parameter | Tipe | Wajib | Default | Deskripsi |
|-----------|------|-------|---------|-----------|
| `title` | `String` | ya | — | Judul utama di AppBar |
| `subtitle` | `String?` | tidak | null | Subjudul di bawah title |
| `centerTitle` | `bool` | tidak | `false` | Apakah title di-center |
| `showBackButton` | `bool` | tidak | `true` | Tampilkan tombol back |
| `leadingWidget` | `Widget?` | tidak | null | Ganti leading default (misal: foto profil) |
| `actions` | `List<Widget>?` | tidak | null | Widget tambahan di kanan AppBar |
| `showThreeDotMenu` | `bool` | tidak | `false` | Aktifkan menu 3 titik |
| `threeDotItems` | `List<String>?` | tidak | null | List item menu (muncul saat `showThreeDotMenu=true`) |
| `onThreeDotSelected` | `Function(String)?` | tidak | null | Callback saat item dipilih |
| `backgroundColor` | `Color?` | tidak | `Colors.white` | Warna background AppBar |
| `elevation` | `double` | tidak | `0` | Shadow elevation |
| `showBottomBorder` | `bool` | tidak | `true` | Tampilkan garis bawah tipis |

**Contoh:**

```dart
// Basic usage
Scaffold(
  appBar: PremiumAppBar(title: "Dashboard"),
  body: Center(child: Text("Hello")),
)

// Dengan subtitle
PremiumAppBar(
  title: "Profile",
  subtitle: "John Doe",
)

// Custom leading + actions
PremiumAppBar(
  title: "Settings",
  showBackButton: false,
  leadingWidget: PremiumImage.avatar(profileUrl, size: 32),
  actions: [
    IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
  ],
)

// Dengan 3-dot menu
PremiumAppBar(
  title: "Reports",
  showThreeDotMenu: true,
  threeDotItems: ["Export PDF", "Share", "Delete"],
  onThreeDotSelected: (value) {
    print("Selected: $value");
  },
)
```

---

### CustomPagination

Navigasi halaman sederhana dengan tombol prev/next.

| Parameter | Tipe | Wajib | Default | Deskripsi |
|-----------|------|-------|---------|-----------|
| `callBackNext` | `Function` | ya | — | Callback saat next ditekan |
| `callBackPrev` | `Function` | ya | — | Callback saat prev ditekan |
| `page` | `int` | ya | — | Halaman saat ini |
| `lastPage` | `int` | ya | — | Halaman terakhir |

**Contoh:**

```dart
CustomPagination(
  page: currentPage,
  lastPage: totalPages,
  callBackNext: () => setCurrentPage(currentPage + 1),
  callBackPrev: () => setCurrentPage(currentPage - 1),
)
```

---

### PremiumPopupMenu

Menu 3 titik dengan item bertipe, ikon opsional, dan styling destruktif (merah).

| Parameter | Tipe | Wajib | Default | Deskripsi |
|-----------|------|-------|---------|-----------|
| `items` | `List<PremiumPopupItem<T>>` | ya | — | Daftar item menu |
| `onSelected` | `Function(T)` | ya | — | Callback saat item dipilih |
| `icon` | `IconData` | tidak | `Icons.more_vert_rounded` | Ikon popup |
| `iconColor` | `Color?` | tidak | null | Warna ikon |
| `iconSize` | `double` | tidak | `2` | Ukuran ikon |

**PremiumPopupItem<T>:**

| Parameter | Tipe | Wajib | Default | Deskripsi |
|-----------|------|-------|---------|-----------|
| `title` | `String` | ya | — | Label item |
| `value` | `T` | ya | — | Value yang dikembalikan |
| `icon` | `IconData?` | tidak | null | Ikon di samping label |
| `isDestructive` | `bool` | tidak | `false` | Style merah (misal: Delete) |

**Contoh:**

```dart
PremiumPopupMenu(
  items: [
    PremiumPopupItem(title: "Edit", value: "edit", icon: Icons.edit),
    PremiumPopupItem(title: "Delete", value: "delete", isDestructive: true),
    PremiumPopupItem(title: "Export", value: "export", icon: Icons.download),
  ],
  onSelected: (value) {
    if (value == "edit") print("Edit clicked");
    if (value == "delete") print("Delete clicked");
  },
)
```

---

## Inputs

### PremiumTextField

Field input dengan validasi, password toggle, dan ikon kustom.

| Parameter | Tipe | Wajib | Default | Deskripsi |
|-----------|------|-------|---------|-----------|
| `label` | `String` | ya | — | Label di atas field |
| `hint` | `String` | ya | — | Placeholder text |
| `controller` | `TextEditingController` | ya | — | Controller untuk read/write value |
| `isRequired` | `bool` | tidak | `false` | Tampilkan bintang merah (*) |
| `isPassword` | `bool` | tidak | `false` | Sembunyikan input + tampilkan eye toggle |
| `keyboardType` | `TextInputType` | tidak | `TextInputType.text` | Tipe keyboard |
| `validator` | `String? Function(String?)?` | tidak | null | Custom validator function |
| `inputFormatters` | `List<TextInputFormatter>?` | tidak | null | Formatter input (misal: hanya angka) |
| `prefixIcon` | `IconData?` | tidak | null | Ikon di kiri dalam field |
| `suffixIcon` | `Widget?` | tidak | null | Ikon di kanan (override auto eye toggle) |
| `maxLines` | `int` | tidak | `1` | Jumlah baris |
| `maxLength` | `int?` | tidak | null | Batas panjang karakter |
| `enabled` | `bool` | tidak | `true` | Disabled state |
| `textInputAction` | `TextInputAction?` | tidak | null | Action button keyboard (next, done, search, dll) |
| `onChanged` | `Function(String)?` | tidak | null | Callback saat teks berubah |
| `onFieldSubmitted` | `Function(String)?` | tidak | null | Callback saat enter ditekan |

**Contoh:**

```dart
final nameCtrl = TextEditingController();

PremiumTextField(
  label: "Nama Lengkap",
  hint: "Masukkan nama lengkap",
  controller: nameCtrl,
  isRequired: true,
  prefixIcon: Icons.person_outline,
)

// Password field
PremiumTextField(
  label: "Password",
  hint: "Masukkan password",
  controller: passwordCtrl,
  isPassword: true,
  isRequired: true,
  validator: (val) => val != null && val.length < 8 ? "Minimal 8 karakter" : null,
)

// Number only input
PremiumTextField(
  label: "Nominal",
  hint: "Masukkan jumlah",
  controller: amountCtrl,
  keyboardType: TextInputType.number,
  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
)
```

---

### BankAccountInput

Input nomor rekening dengan validasi real-time dan feedback visual (checkmark/error icon).

| Parameter | Tipe | Wajib | Default | Deskripsi |
|-----------|------|-------|---------|-----------|
| `label` | `String?` | tidak | null | Label input |
| `placeholder` | `String` | tidak | `"Enter account number"` | Placeholder text |
| `initialValue` | `String?` | tidak | null | Nilai awal |
| `required` | `bool` | tidak | `false` | Tandai required |
| `showValidation` | `bool` | tidak | `true` | Tampilkan checkmark/error icon |
| `errorMessage` | `String` | tidak | `"Invalid account number"` | Pesan error |
| `bankCode` | `String` | tidak | `""` | Kode bank untuk validasi spesifik |
| `onChanged` | `Function(String)?` | tidak | null | Callback saat value berubah |
| `onValidate` | `Function(bool)?` | tidak | null | Callback dengan state validasi |
| `decoration` | `InputDecoration?` | tidak | null | Merge ke default decoration |
| `style` | `TextStyle?` | tidak | null | Style text input |
| `labelStyle` | `TextStyle?` | tidak | null | Style label |
| `errorStyle` | `TextStyle?` | tidak | null | Style pesan error |

**Contoh:**

```dart
BankAccountInput(
  label: "Nomor Rekening",
  initialValue: "1234567890",
  showValidation: true,
  onChanged: (value) => print("Account: $value"),
)
```

---

### CurrencyInput

Input mata uang dengan formatter Rupiah/USD dan opsi konversi mata uang.

| Parameter | Tipe | Wajib | Default | Deskripsi |
|-----------|------|-------|---------|-----------|
| `label` | `String?` | tidak | null | Label input |
| `placeholder` | `String` | tidak | `"0.0"` | Placeholder text |
| `initialValue` | `String?` | tidak | null | Nilai awal |
| `required` | `bool` | tidak | `false` | Tandai required |
| `currency` | `String` | tidak | `"USD"` | Kode mata uang (IDR, SGD, MYR, dll) |
| `locale` | `String` | tidak | `"en_US"` | Locale formatting |
| `showConverted` | `bool` | tidak | `false` | Tampilkan nilai konversi di bawah input |
| `convertedCurrency` | `String` | tidak | `"EUR"` | Mata uang tujuan |
| `conversionRate` | `double` | tidak | `1.0` | Rate konversi |
| `onChanged` | `Function(String)?` | tidak | null | Callback saat value berubah |
| `decoration` | `InputDecoration?` | tidak | null | Merge ke default decoration |
| `style` | `TextStyle?` | tidak | null | Style text input |
| `labelStyle` | `TextStyle?` | tidak | null | Style label |
| `convertedAmountStyle` | `TextStyle?` | tidak | null | Style text konversi |

**Contoh:**

```dart
// Basic currency input
CurrencyInput(label: "Jumlah Transfer", currency: "IDR")

// With conversion display
CurrencyInput(
  label: "Jumlah Transfer",
  currency: "IDR",
  locale: "id_ID",
  showConverted: true,
  convertedCurrency: "SGD",
  conversionRate: 0.091,
)
```

---

### PremiumDropdownSearch

Dropdown pencarian dengan modal bottom sheet dan filter real-time.

| Parameter | Tipe | Wajib | Default | Deskripsi |
|-----------|------|-------|---------|-----------|
| `label` | `String` | ya | — | Label dropdown |
| `hint` | `String` | ya | — | Placeholder (item terpilih belum dipilih) |
| `items` | `List<PremiumDropdownItem<T>>` | ya | — | Daftar item |
| `onChanged` | `Function(T)` | ya | — | Callback saat dipilih |
| `selectedItem` | `PremiumDropdownItem<T>?` | tidak | null | Item yang sedang terpilih |
| `prefixIcon` | `IconData?` | tidak | null | Ikon di kiri |
| `isRequired` | `bool` | tidak | `false` | Tandai required |

**PremiumDropdownItem<T>:**

| Parameter | Tipe | Wajib | Default | Deskripsi |
|-----------|------|-------|---------|-----------|
| `label` | `String` | ya | — | Tampilan label |
| `value` | `T` | ya | — | Value backing |

**Contoh:**

```dart
PremiumDropdownSearch<String>(
  label: "Provinsi",
  hint: "Pilih provinsi",
  prefixIcon: Icons.location_on_outlined,
  items: [
    PremiumDropdownItem(label: "DKI Jakarta", value: "JK"),
    PremiumDropdownItem(label: "Jawa Barat", value: "JB"),
    PremiumDropdownItem(label: "Jawa Tengah", value: "JT"),
  ],
  selectedItem: PremiumDropdownItem(label: "DKI Jakarta", value: "JK"),
  onChanged: (value) => print("Selected: $value"),
)
```

---

### PremiumFilePicker

File picker dengan area upload dan preview file (icon berdasarkan ekstensi, formatter ukuran).

| Parameter | Tipe | Wajib | Default | Deskripsi |
|-----------|------|-------|---------|-----------|
| `label` | `String` | ya | — | Label |
| `hint` | `String` | ya | — | Teks placeholder area drop |
| `onFilesPicked` | `Function` | ya | — | Callback saat file dipilih |
| `allowMultiple` | `bool` | tidak | `false` | Izinkan pilih banyak file |
| `fileType` | `FileType` | tidak | `FileType.any` | Tipe file yang diperbolehkan |
| `allowedExtensions` | `List<String>?` | tidak | null | Filter ekstensi khusus (["pdf", "doc"]) |
| `initialFiles` | `List<String>?` | tidak | null | File awal yang sudah terpilih |
| `isRequired` | `bool` | tidak | `false` | Tandai required |

**Contoh:**

```dart
PremiumFilePicker(
  label: "Upload Dokumen",
  hint: "Tap atau drop file di sini",
  fileType: FileType.custom,
  allowedExtensions: ["pdf", "doc", "docx", "png"],
  allowMultiple: true,
  onFilesPicked: (files) {
    for (var file in files) {
      print(file.files.first.name);
    }
  },
)
```

---

### PremiumSignaturePad

Canvas tanda tangan digital yang membungkus package `signature`.

| Parameter | Tipe | Wajib | Default | Deskripsi |
|-----------|------|-------|---------|-----------|
| `controller` | `SignatureController` | ya | — | Controller dari package `signature` |
| `height` | `double` | tidak | `20` | Tinggi area tanda tangan |
| `backgroundColor` | `Color` | tidak | `Colors.slate[50]` | Warna background |
| `borderRadius` | `double` | tidak | `16` | Sudut melengkung |
| `showControls` | `bool` | tidak | `true` | Tampilkan tombol Clear/Undo |
| `clearText` | `String` | tidak | `"Bersihkan"` | Label tombol clear |
| `undoText` | `String` | tidak | `"Urungkan (Undo)"` | Label tombol undo |
| `activeColor` | `Color?` | tidak | null | Warna stroke tanda tangan |

**Contoh:**

```dart
final signatureCtrl = SignatureController(
  penStrokeWidth: 2,
  penColor: Colors.black,
);

PremiumSignaturePad(
  controller: signatureCtrl,
  clearText: "Hapus",
  undoText: "Urungkan",
)
```

---

### PremiumRadioGroup

Grup radio pilihan dengan dua gaya tampilan: card (rounded box) dan compact (inline row).

| Parameter | Tipe | Wajib | Default | Deskripsi |
|-----------|------|-------|---------|-----------|
| `label` | `String` | ya | — | Label grup |
| `options` | `List<PremiumRadioOption<T>>` | ya | — | Daftar pilihan |
| `selectedValue` | `T` | ya | — | Value yang terpilih |
| `onChanged` | `Function(T)` | ya | — | Callback saat berubah |
| `isRequired` | `bool` | tidak | `false` | Tandai required |
| `useCardStyle` | `bool` | tidak | `true` | Gaya card vs compact (inline row) |
| `isHorizontal` | `bool` | tidak | `true` | Layout horizontal (Wrap) vs vertikal |
| `spacing` | `double` | tidak | `12` | Jarak antar pilihan |
| `activeColor` | `Color?` | tidak | null | Warna state aktif |

**PremiumRadioOption<T>:**

| Parameter | Tipe | Wajib | Default | Deskripsi |
|-----------|------|-------|---------|-----------|
| `label` | `String` | ya | — | Label pilihan |
| `subtitle` | `String?` | tidak | null | Sub-label opsional |
| `value` | `T` | ya | — | Value backing |

**Contoh:**

```dart
PremiumRadioGroup<String>(
  label: "Jenis Kelamin",
  isRequired: true,
  useCardStyle: true,
  options: [
    PremiumRadioOption(label: "Laki-laki", value: "male"),
    PremiumRadioOption(label: "Perempuan", value: "female"),
  ],
  selectedValue: selectedGender,
  onChanged: (val) => setSelectedGender(val),
)

// Compact style, vertikal
PremiumRadioGroup<String>(
  label: "Status Perkawinan",
  useCardStyle: false,
  isHorizontal: false,
  options: [
    PremiumRadioOption(label: "Belum Menikah", value: "single"),
    PremiumRadioOption(label: "Menikah", value: "married"),
  ],
  selectedValue: maritalStatus,
  onChanged: (val) => setMaritalStatus(val),
)
```

---

## Buttons

### CustomButon

Tombol filled/elevated standar. Default lebar penuh.

| Parameter | Tipe | Wajib | Default | Deskripsi |
|-----------|------|-------|---------|-----------|
| `text` | `String` | ya | — | Label tombol |
| `onPressed` | `VoidCallback` | ya | — | Aksi saat ditekan |
| `width` | `double?` | tidak | `double.infinity` | Lebar tombol |
| `height` | `double` | tidak | `48` | Tinggi tombol |
| `backgroundColor` | `Color?` | tidak | `theme.primaryColor` | Warna latar |
| `textStyle` | `TextStyle?` | tidak | null | Override style teks |
| `borderRadius` | `double` | tidak | `12` | Sudut melengkung |
| `margin` | `EdgeInsetsGeometry?` | tidak | null | Margin luar |

**Contoh:**

```dart
CustomButon(
  text: "Simpan Data",
  onPressed: () => print("Saved"),
)
```

---

### PremiumFlatButton

Tombol teks-only untuk aksi sekunder.

| Parameter | Tipe | Wajib | Default | Deskripsi |
|-----------|------|-------|---------|-----------|
| `text` | `String` | ya | — | Label |
| `onPressed` | `VoidCallback` | ya | — | Aksi |
| `width` | `double?` | tidak | null | Lebar |
| `height` | `double?` | tidak | null | Tinggi |
| `textColor` | `Color?` | tidak | `theme.primaryColor` | Warna teks |
| `fontSize` | `double` | tidak | `14` | Ukuran font |
| `textAlign` | `TextAlign` | tidak | `TextAlign.center` | Perataan teks |
| `margin` | `EdgeInsetsGeometry?` | tidak | null | Margin |

**Contoh:**

```dart
Row(
  children: [
    Expanded(child: CustomButon(text: "Batal", onPressed: cancel)),
    const SizedBox(width: 12),
    Expanded(
      child: PremiumFlatButton(
        text: "Lihat Detail",
        textColor: theme.primaryColor,
        onPressed: viewDetail,
      ),
    ),
  ],
)
```

---

### PremiumIconButton

Ikon-only atau ikon+text dalam InkWell.

| Parameter | Tipe | Wajib | Default | Deskripsi |
|-----------|------|-------|---------|-----------|
| `icon` | `IconData` | ya | — | Ikon |
| `onPressed` | `VoidCallback` | ya | — | Aksi |
| `text` | `String?` | tidak | null | Jika diisi, muncul ikon+text berdampingan |
| `iconColor` | `Color?` | tidak | `theme.primaryColor` | Warna ikon |
| `textColor` | `Color?` | tidak | null | Warna teks (saat ada `text`) |
| `width` | `double?` | tidak | null | Lebar |
| `height` | `double?` | tidak | null | Tinggi |
| `margin` | `EdgeInsetsGeometry?` | tidak | null | Margin |

**Contoh:**

```dart
// Icon only
PremiumIconButton(
  icon: Icons.share,
  onPressed: share,
)

// Icon + Text
PremiumIconButton(
  icon: Icons.download,
  text: "Unduh Laporan",
  onPressed: download,
)
```

---

### PremiumOutlineButton

Tombol border-only untuk aksi tersier/ghost.

| Parameter | Tipe | Wajib | Default | Deskripsi |
|-----------|------|-------|---------|-----------|
| `text` | `String` | ya | — | Label |
| `onPressed` | `VoidCallback` | ya | — | Aksi |
| `borderColor` | `Color?` | tidak | `theme.primaryColor` | Warna border |
| `textColor` | `Color?` | tidak | null | Warna teks |
| `width` | `double?` | tidak | `double.infinity` | Lebar |
| `height` | `double` | tidak | `48` | Tinggi |
| `borderRadius` | `double` | tidak | `12` | Sudut melengkung |

**Contoh:**

```dart
PremiumOutlineButton(
  text: "Batalkan",
  borderColor: Colors.grey,
  textColor: Colors.grey[700],
  onPressed: cancel,
)
```

---

## Layout

### PremiumContainer

Container serbaguna dengan shadow otomatis, glassmorphism, dan tap detection (auto InkWell).

| Parameter | Tipe | Wajib | Default | Deskripsi |
|-----------|------|-------|---------|-----------|
| `child` | `Widget?` | tidak | null | Konten di dalam |
| `width` | `double?` | tidak | null | Lebar |
| `height` | `double?` | tidak | null | Tinggi |
| `margin` | `EdgeInsetsGeometry?` | tidak | null | Margin luar |
| `padding` | `EdgeInsetsGeometry` | tidak | `EdgeInsets.all(16)` | Padding dalam |
| `alignment` | `AlignmentGeometry?` | tidak | null | Perataan child |
| `borderRadius` | `double` | tidak | `16` | Sudut melengkung |
| `backgroundColor` | `Color?` | tidak | `Colors.white` | Warna latar |
| `border` | `BoxBorder?` | tidak | null | Border custom |
| `gradient` | `Gradient?` | tidak | null | Gradient menggantikan backgroundColor |
| `boxShadow` | `List<BoxShadow>?` | tidak | null | Shadow custom |
| `onTap` | `VoidCallback?` | tidak | null | Aksi tap (auto InkWell) |
| `splashColor` | `Color?` | tidak | `theme.primaryColor.withOpacity(0.1)` | Warna riak tap |
| `showShadow` | `bool` | tidak | `false` | Aktifkan shadow premium otomatis |
| `isGlassmorphic` | `bool` | tidak | `false` | Mode glassmorphism (BackdropFilter blur) |
| `blurSigma` | `double` | tidak | `10` | Intensitas blur glassmorphism |

**Contoh:**

```dart
// Basic container dengan shadow
PremiumContainer(
  showShadow: true,
  child: Text("Card Content"),
)

// Glassmorphic container
PremiumContainer(
  isGlassmorphic: true,
  backgroundColor: Colors.white.withOpacity(0.2),
  child: Text("Glass Card"),
)

// Tap-enabled container
PremiumContainer(
  showShadow: true,
  onTap: () => Navigator.pushNamed(context, "/detail"),
  child: ListTile(title: Text("Tap me")),
)

// Dengan gradient
PremiumContainer(
  gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
  child: Text("Gradient Card"),
)
```

---

### PremiumCalendar

Carousel kalender membungkus `flutter_calendar_carousel`.

| Parameter | Tipe | Wajib | Default | Deskripsi |
|-----------|------|-------|---------|-----------|
| `selectedDateTime` | `DateTime` | ya | — | Tanggal terpilih |
| `targetDateTime` | `DateTime` | ya | — | Tanggal saat ini |
| `onDayPressed` | `Function(DateTime, DateTime)` | ya | — | Callback saat hari ditekan |
| `markedDatesMap` | `Map<DateTime, List>?` | tidak | null | Map hari dengan events |
| `onCalendarChanged` | `Function(DateTime)?` | tidak | null | Callback saat bulan berganti |
| `height` | `double?` | tidak | null | Tinggi kalender |
| `isScrollable` | `bool` | tidak | `false` | Mode scroll vs fixed month grid |

**Contoh:**

```dart
final now = DateTime.now();
final selected = now.subtract(const Duration(days: 5));

PremiumCalendar(
  selectedDateTime: selected,
  targetDateTime: now,
  onDayPressed: (day, pressedDays) {
    setSelectedDate(day);
  },
  markedDatesMap: {
    now: ["Meeting"],
    now.subtract(Duration(days: 1)): ["Deadline"],
  },
)
```

---

### PremiumCarousel

Carousel gambar/konten autoplay dengan dot indicators dan efek scale pada card.

| Parameter | Tipe | Wajib | Default | Deskripsi |
|-----------|------|-------|---------|-----------|
| `items` | `List<Widget>` | ya | — | Daftar konten carousel |
| `height` | `double` | tidak | `20` | Tinggi carousel |
| `autoPlay` | `bool` | tidak | `true` | Autoplay aktif |
| `autoPlayDuration` | `Duration` | tidak | `4s` | Interval autoplay |
| `viewportFraction` | `double` | tidak | `0.9` | Fraksi viewport (card di samping terlihat samar) |
| `showIndicators` | `bool` | tidak | `true` | Tampilkan dot indicators |
| `activeIndicatorColor` | `Color?` | tidak | null | Warna dot aktif |
| `inactiveIndicatorColor` | `Color?` | tidak | null | Warna dot tidak aktif |

**Contoh:**

```dart
PremiumCarousel(
  height: 200,
  items: [
    PremiumContainer(child: Image.asset("assets/banner1.png")),
    PremiumContainer(child: Image.asset("assets/banner2.png")),
    PremiumContainer(child: Image.asset("assets/banner3.png")),
  ],
  autoPlay: true,
  autoPlayDuration: Duration(seconds: 5),
)
```

---

### CustomList

Template scaffold dengan gradient header dan area body expandable.

| Parameter | Tipe | Wajib | Default | Deskripsi |
|-----------|------|-------|---------|-----------|
| `child` | `Widget` | ya | — | Body content |
| `labelText` | `String?` | tidak | null | Label header |
| `buttonStyle` | `ButtonStyle?` | tidak | null | Custom button style |
| `callBack` | `Function?` | tidak | null | Callback tombol |
| `buttonShape` | `OutlinedBorder?` | tidak | null | Bentuk tombol |
| `buttonColor` | `Color?` | tidak | null | Warna tombol |
| `buttonPadding` | `EdgeInsets?` | tidak | null | Padding tombol |
| `iconButton` | `Widget?` | tidak | null | Ikon tombol |
| `titlePage` | `String` | tidak | `"Ini Judul"` | Judul halaman |
| `headerRightMenu` | `Widget?` | tidak | null | Menu di kanan header |
| `headerChildren` | `List<Widget>?` | tidak | null | Konten tambahan di header |
| `navigationBackCall` | `Function?` | tidak | null | Custom back action |
| `menuItem` | `List<PopupMenuEntry>?` | tidak | null | Item menu popup di header |

**Contoh:**

```dart
CustomList(
  titlePage: "Data Nasabah",
  child: ListView.builder(
    itemCount: 20,
    itemBuilder: (context, index) => ListTile(title: Text("Item $index")),
  ),
)
```

---

## Feedback

### CustomDialog

Modal dialog dengan icon, title, message, dan 1-2 tombol otomatis.

**Penggunaan:** Static method — panggil langsung `CustomDialog.show()`.

| Parameter | Tipe | Wajib | Default | Deskripsi |
|-----------|------|-------|---------|-----------|
| `context` | `BuildContext` | ya | — | Build context |
| `type` | `CustomDialogType` | ya | — | Tipe dialog |
| `title` | `String` | ya | — | Judul dialog |
| `message` | `String` | ya | — | Isi pesan |
| `confirmText` | `String` | tidak | `"OK"` | Label tombol konfirmasi |
| `cancelText` | `String?` | tidak | null | Label tombol batal (set null = 1 tombol) |
| `onConfirm` | `VoidCallback?` | tidak | null | Callback tombol konfirmasi |
| `onCancel` | `VoidCallback?` | tidak | null | Callback tombol batal |
| `barrierDismissible` | `bool` | tidak | `true` | Bisa dismiss dengan tap luar |

**CustomDialogType enum:**

| Value | Warna | Icon |
|-------|-------|------|
| `success` | Hijau Emerald (#10B981) | `Icons.check_circle_rounded` |
| `warning` | Amber (#F59E0B) | `Icons.warning_amber_rounded` |
| `error` | Merah Rose (#EF4444) | `Icons.error_outline_rounded` |
| `info` | Biru (#3B82F6) | `Icons.info_outline_rounded` |

**Contoh:**

```dart
// Success dialog (1 tombol)
CustomDialog.show(
  context,
  type: CustomDialogType.success,
  title: "Berhasil!",
  message: "Data berhasil disimpan.",
  confirmText: "Tutup",
  onConfirm: () => Navigator.pop(context),
)

// Confirmation dialog (2 tombol)
CustomDialog.show(
  context,
  type: CustomDialogType.warning,
  title: "Hapus Data?",
  message: "Data yang dihapus tidak dapat dikembalikan.",
  cancelText: "Batal",
  confirmText: "Ya, Hapus",
  onCancel: () => Navigator.pop(context),
  onConfirm: () => deleteData(id),
)

// Error dialog
CustomDialog.show(
  context,
  type: CustomDialogType.error,
  title: "Gagal!",
  message: "Terjadi kesalahan pada server.",
)
```

---

### PremiumLoading

Loading overlay fullscreen dengan efek glassmorphism blur.

**Penggunaan:** Static method — panggil `PremiumLoading.show()` dan `PremiumLoading.hide()`.

| Parameter | Tipe | Wajib | Default | Deskripsi |
|-----------|------|-------|---------|-----------|
| `context` | `BuildContext` | ya | — | Build context |
| `message` | `String` | tidak | `"Mohon tunggu..."` | Pesan status loading |

**Contoh:**

```dart
void submitForm() async {
  PremiumLoading.show(context, message: "Mengirim data...");
  
  try {
    await apiService.submit(data);
  } catch (e) {
    PremiumLoading.hide(context);
    return;
  }
  
  PremiumLoading.hide(context);
}
```

---

### CustomSkeleton

Shimmer loading skeleton dengan animasi gradien bergerak (1.2s loop).

| Parameter | Tipe | Wajib | Default | Deskripsi |
|-----------|------|-------|---------|-----------|
| `width` | `double?` | tidak | null | Lebar |
| `height` | `double?` | tidak | null | Tinggi |
| `borderRadius` | `double` | tidak | `12` | Sudut melengkung |
| `shape` | `BoxShape` | tidak | `BoxShape.rectangle` | Bentuk (rectangle atau circle) |
| `margin` | `EdgeInsetsGeometry?` | tidak | null | Margin |

**Factory Constructors:**

```dart
// Circle skeleton (avatar placeholder)
CustomSkeleton.circle(size: 50)

// Text line skeleton
CustomSkeleton.textLine(width: 200, height: 16, borderRadius: 6)
```

**Contoh:**

```dart
ListView.builder(
  itemCount: 10,
  itemBuilder: (context, index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CustomSkeleton.circle(size: 50),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSkeleton.textLine(width: double.infinity),
                const SizedBox(height: 8),
                CustomSkeleton.textLine(width: 150),
              ],
            ),
          ),
        ],
      ),
    );
  },
)
```

---

### CustomEmptyResponse

Placeholder state untuk list/data kosong. Prioritas: customImage > icon > default folder.

| Parameter | Tipe | Wajib | Default | Deskripsi |
|-----------|------|-------|---------|-----------|
| `title` | `String` | tidak | `"Tidak Ada Data"` | Judul state kosong |
| `subtitle` | `String?` | tidak | null | Subjudul opsional |
| `icon` | `IconData?` | tidak | `Icons.folder_open_outlined` | Ikon default |
| `customImage` | `Widget?` | tidak | null | Ganti icon dengan gambar custom (SVG/Image) |
| `actionButtonText` | `String?` | tidak | null | Tampilkan tombol aksi |
| `onActionPressed` | `VoidCallback?` | tidak | null | Aksi tombol |
| `iconColor` | `Color?` | tidak | null | Warna ikon |
| `iconSize` | `double` | tidak | `70` | Ukuran ikon |
| `padding` | `EdgeInsetsGeometry` | tidak | `EdgeInsets.all(32)` | Padding |

**Contoh:**

```dart
if (items.isEmpty) {
  return CustomEmptyResponse(
    title: "Belum Ada Transaksi",
    subtitle: "Mulai dengan menambahkan transaksi baru",
    actionButtonText: "Tambah Transaksi",
    onActionPressed: () => Navigator.pushNamed(context, "/transaksi-baru"),
  );
}

// Dengan custom image
CustomEmptyResponse(
  title: "Oops!",
  customImage: Image.asset("assets/empty.svg"),
)
```

---

### PremiumImage

Image dengan built-in loading progress indicator dan error placeholder (person_rounded untuk avatar, image_not_supported untuk lainnya).

**Factory Constructors:**

```dart
// Avatar (lingkaran sempurna, default network)
PremiumImage.avatar(url, size: 50)

// Network image
PremiumImage.network(url, width: 200, height: 150)

// Asset image
PremiumImage.asset("assets/logo.png", width: 100, height: 100)
```

| Parameter | Tipe | Wajib | Default | Deskripsi |
|-----------|------|-------|---------|-----------|
| `source` | `String` | ya | — | URL (network) atau path (asset) |
| `type` | `PremiumImageType` | tidak | `network` | Tipe gambar |
| `width` | `double?` | tidak | null | Lebar |
| `height` | `double?` | tidak | null | Tinggi |
| `borderRadius` | `double` | tidak | `12` | Sudut melengkung |
| `fit` | `BoxFit` | tidak | `BoxFit.cover` | Cara gambar di-fill |
| `errorPlaceholder` | `Widget?` | tidak | null | Ganti fallback error |

**Contoh:**

```dart
// Card dengan avatar
PremiumContainer(
  showShadow: true,
  padding: EdgeInsets.all(16),
  child: Row(
    children: [
      PremiumImage.avatar(user.avatarUrl, size: 48),
      SizedBox(width: 12),
      Expanded(child: Text(user.name)),
    ],
  ),
)

// Banner image
PremiumImage.network(
  "https://example.com/banner.jpg",
  width: double.infinity,
  height: 200,
  borderRadius: 16,
)
```

---

## Color Palette

Semua widget menggunakan palet warna konsisten:

| Warna | Hex | Usage |
|-------|-----|-------|
| **Slate 800** | `#1E293B` | Title, heading text |
| **Slate 700** | `#334155` | Label text |
| **Slate 500** | `#64748B` | Subtitle, disabled icon |
| **Slate 200** | `#E2E8F0` | Error placeholder bg |
| **Slate 100** | `#F1F5F9` | Loading skeleton bg |
| **Gray 300** | `#D1D5DB` | Skeleton outer |
| **Gray 100** | `#F3F4F6` | Skeleton center |
| **White** | `#FFFFFF` | Background default |
| **Primary** | `theme.primaryColor` | Accent, focus, active states |

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 0.1.0 | 2026-06-30 | Initial UI documentation for all 21 widget families |
