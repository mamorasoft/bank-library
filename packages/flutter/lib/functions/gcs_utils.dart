
import 'api_utils.dart';

class GcsUtil {
  /// Mendapatkan Signed URL untuk file yang tersimpan di Google Cloud Storage.
  /// Ini memastikan file rahasia hanya bisa diakses oleh orang yang berhak.
  static Future<String> getSignedUrl({
    required String path,
    required String fileName,
    required String token,
    required String signedApiUrl,
  }) async {
    try {
      // 1. Panggil API Signed URL melalui ApiUtil yang sudah kita buat sebelumnya
      final response = await ApiUtil.postCall(
        path: signedApiUrl,
        token: token,
        params: {
          "file_name": fileName,
          "file_path": path,
        },
        isDebug: false,
      );

      // 2. Validasi response
      if (response != null && response['status']?.toString() == "200") {
        return response['url'].toString();
      }
      
      // Jika gagal, kembalikan URL default (link mentah)
      return _buildDefaultUrl(path, fileName);
    } catch (e) {
      return _buildDefaultUrl(path, fileName);
    }
  }

  // Helper untuk membuat link default jika signed url gagal
  static String _buildDefaultUrl(String path, String fileName) {
    return "https://storage.googleapis.com/bucket-name/$path/$fileName";
  }
}