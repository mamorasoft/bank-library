import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class PremiumFilePicker extends StatefulWidget {
  final String label;
  final String hint;
  final bool allowMultiple;
  final FileType fileType;
  final List<String>? allowedExtensions;
  final Function(List<PlatformFile>) onFilesPicked;
  final List<PlatformFile>? initialFiles;
  final bool isRequired;

  const PremiumFilePicker({
    Key? key,
    required this.label,
    required this.hint,
    required this.onFilesPicked,
    this.allowMultiple = false,
    this.fileType = FileType.any,
    this.allowedExtensions,
    this.initialFiles,
    this.isRequired = false,
  }) : super(key: key);

  @override
  State<PremiumFilePicker> createState() => _PremiumFilePickerState();
}

class _PremiumFilePickerState extends State<PremiumFilePicker> {
  List<PlatformFile> _pickedFiles = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialFiles != null) {
      _pickedFiles = List.from(widget.initialFiles!);
    }
  }

  /// Fungsi internal untuk memicu native File Picker HP/Web
  final _picker = FilePicker.platform;
  void _pickFiles() async {
    try {
      FilePickerResult? result = await _picker.pickFiles(
        allowMultiple: widget.allowMultiple,
        type: widget.fileType,
        allowedExtensions: widget.allowedExtensions,
      );

      if (result != null) {
        setState(() {
          if (widget.allowMultiple) {
            // Jika boleh banyak, gabungkan file baru dengan yang sudah ada (hindari duplikat nama)
            for (var file in result.files) {
              if (!_pickedFiles.any((element) => element.name == file.name)) {
                _pickedFiles.add(file);
              }
            }
          } else {
            // Jika single file, langsung timpa data lama
            _pickedFiles = result.files;
          }
        });
        // Lempar data ke widget induk
        widget.onFilesPicked(_pickedFiles);
      }
    } catch (e) {
      debugPrint("Error pas pick file bosku: $e");
    }
  }

  /// Menghapus file dari daftar list preview
  void _removeFile(int index) {
    setState(() {
      _pickedFiles.removeAt(index);
    });
    widget.onFilesPicked(_pickedFiles);
  }

  /// Helper untuk konversi ukuran file bytes ke KB/MB biar informatif
  String _getFileSize(int bytes) {
    if (bytes <= 0) return "0 B";
    final kb = bytes / 1024;
    final mb = kb / 1024;
    if (mb >= 1) return "${mb.toStringAsFixed(1)} MB";
    return "${kb.toStringAsFixed(0)} KB";
  }

  /// Helper untuk menentukan icon berdasarkan ekstensi file
  IconData _getFileIcon(String? extension) {
    switch (extension?.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'doc':
      case 'docx':
        return Icons.description_rounded;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart_rounded;
      case 'png':
      case 'jpg':
      case 'jpeg':
        return Icons.image_rounded;
      case 'zip':
      case 'rar':
        return Icons.folder_zip_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. LABEL ATAS
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.label,
              style: const TextStyle(
                color: Color(0xFF334155), // Slate 700
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (widget.isRequired)
              const Text(" *", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),

        // 2. BOX AREA TOMBOL UPLOAD (GEOMETRIS PREMIUM STYLE)
        InkWell(
          onTap: _pickFiles,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC), // Slate 50
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: theme.primaryColor.withOpacity(0.25),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 32,
                    color: theme.primaryColor,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.hint,
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.allowMultiple ? "Bisa pilih lebih dari 1 file" : "Maksimal 1 file saja",
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 3. PREVIEW LIST FILE YANG TERPILIH (Otomatis muncul di bawahnya jika ada file)
        if (_pickedFiles.isNotEmpty) ...[
          const SizedBox(height: 14),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _pickedFiles.length,
            itemBuilder: (context, index) {
              final file = _pickedFiles[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.withOpacity(0.15)),
                ),
                child: Row(
                  children: [
                    // Icon File Dinamis
                    Icon(
                      _getFileIcon(file.extension),
                      color: const Color(0xFF64748B),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    
                    // Nama & Ukuran File
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            file.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF1E293B),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _getFileSize(file.size),
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Tombol Hapus File (X)
                    IconButton(
                      icon: const Icon(Icons.cancel_rounded, color: Color(0xFFEF4444), size: 20),
                      onPressed: () => _removeFile(index),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}