import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class FileCompressUtil {
  /// Mengompresi file gambar untuk menghemat ukuran sebelum upload API.
  /// Standar quality 70 sudah sangat bagus dan ringan.
  static Future<File> compressImage(
    File file, {
    int quality = 70, 
    int minWidth = 1024,
    int minHeight = 1024,
  }) async {
    try {
      // 1. Cek ekstensi file (hanya gambar yang bisa dikompres)
      String extension = file.path.split('.').last.toLowerCase();
      if (extension != 'jpg' && extension != 'jpeg' && extension != 'png') {
        return file; // Kalau isinya PDF / Excel, langsung balikan aslinya
      }

      // 2. Siapkan folder sementara (temp) di HP
      final dir = await getTemporaryDirectory();
      
      // 3. Buat nama file baru agar tidak menimpa file asli
      final targetPath = '${dir.absolute.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // 4. Eksekusi mesin kompresi
      var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
        minWidth: minWidth,
        minHeight: minHeight,
      );

      // 5. Kembalikan file hasil kompresi (Jika gagal, kembalikan file asli)
      return result != null ? File(result.path) : file;
    } catch (e) {
      return file; 
    }
  }

  /// Fungsi SAKTI: Mengecek isi Map/JSON. Jika di dalamnya ada File,
  /// otomatis akan dikompres semuanya sebelum dilempar ke Dio.
  static Future<Map<String, dynamic>> scanAndCompressMap(Map<String, dynamic> params) async {
    Map<String, dynamic> newParams = {};
    
    for (var key in params.keys) {
      var value = params[key];
      
      if (value is File) {
        // Jika value-nya adalah 1 file tunggal
        newParams[key] = await compressImage(value);
      } 
      else if (value is List<File>) {
        // Jika value-nya berupa list foto (misal upload banyak bukti sekaligus)
        List<File> compressedList = [];
        for (var file in value) {
          compressedList.add(await compressImage(file));
        }
        newParams[key] = compressedList;
      } 
      else {
        // Jika berupa teks biasa (nama, alamat, dll), biarkan saja
        newParams[key] = value;
      }
    }
    
    return newParams;
  }
}