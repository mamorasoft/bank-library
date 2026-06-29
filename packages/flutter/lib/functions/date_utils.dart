import 'package:intl/intl.dart';

class DateUtil {
  static String formatToIndoDate(String? isoString,
      {String format = 'dd MMM yyyy'}) {
    if (isoString == null || isoString.isEmpty) {
      return '-';
    } //  

    try {
      DateTime parsedDate = DateTime.parse(isoString);

      return DateFormat(format).format(parsedDate);
    } catch (e) {
      return '-';
    } 
  }

  static int calculateDaysFromNow(String? targetDateIso) {
    if (targetDateIso == null || targetDateIso.isEmpty) return 0;

    try {
      DateTime targetDate = DateTime.parse(targetDateIso);
      DateTime now = DateTime.now();

      return targetDate.difference(now).inDays;
    } catch (e) {
      return 0;
    }
  }

  /// Mengambil nama bulan dari string tanggal ISO (contoh: "2026-02-15" -> "Februari")
  static String getMonthName(String? isoString, {bool isShort = false}) {
    if (isoString == null || isoString.isEmpty) return '-';

    try {
      DateTime parsedDate = DateTime.parse(isoString);

      // Kita pakai manual mapping biar 100% aman bahasa Indonesia
      // tanpa pusing setting locale intl di aplikasi utama
      return getMonthNameFromNumber(parsedDate.month, isShort: isShort);
    } catch (e) {
      return '-';
    }
  }

  /// Mengambil nama bulan HANYA dari angkanya saja (1 = Januari, 2 = Februari, dst)
  static String getMonthNameFromNumber(int monthNumber,
      {bool isShort = false}) {
    if (monthNumber < 1 || monthNumber > 12) return '-';

    List<String> months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];

    List<String> shortMonths = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Ags',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];

    return isShort ? shortMonths[monthNumber - 1] : months[monthNumber - 1];
  }

  /// Mengambil nama hari dari string tanggal ISO (contoh: "2026-06-26" -> "Jumat")
  static String getDayName(String? isoString, {bool isShort = false}) {
    if (isoString == null || isoString.isEmpty) return '-';

    try {
      DateTime parsedDate = DateTime.parse(isoString);

      // Di Dart: 1 = Senin, 7 = Minggu
      return getDayNameFromNumber(parsedDate.weekday, isShort: isShort);
    } catch (e) {
      return '-';
    }
  }

  /// Mengambil nama hari HANYA dari angkanya saja (1 = Senin, 7 = Minggu)
  static String getDayNameFromNumber(int dayNumber, {bool isShort = false}) {
    if (dayNumber < 1 || dayNumber > 7) return '-';

    // Array hari, index 0 adalah Senin (karena nanti dipanggil dengan dayNumber - 1)
    List<String> days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu'
    ];

    List<String> shortDays = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

    return isShort ? shortDays[dayNumber - 1] : days[dayNumber - 1];
  }

  /// Mengambil format jam dari string tanggal (contoh: "14:30")
  static String formatToTime(String? isoString, {String format = 'HH:mm'}) {
    if (isoString == null || isoString.isEmpty) return '-';

    try {
      DateTime parsedDate = DateTime.parse(isoString);
      return DateFormat(format).format(parsedDate);
    } catch (e) {
      return '-';
    }
  }

  /// Mengambil format Tanggal & Jam sekaligus (contoh: "17 Jun 2026, 14:30")
  static String formatToFullDateTime(String? isoString) {
    return formatToIndoDate(isoString, format: 'dd MMM yyyy, HH:mm');
  }
}
