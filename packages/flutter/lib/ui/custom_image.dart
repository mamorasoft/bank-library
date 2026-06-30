import 'package:flutter/material.dart';

enum PremiumImageType { network, asset }

class PremiumImage extends StatelessWidget {
  final String source;
  final PremiumImageType type;
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxFit fit;
  final Widget? errorPlaceholder;

  const PremiumImage({
    Key? key,
    required this.source,
    this.type = PremiumImageType.network,
    this.width,
    this.height,
    this.borderRadius = 12.0,
    this.fit = BoxFit.cover,
    this.errorPlaceholder,
  }) : super(key: key);

  /// 1. PRESET AVATAR / PHOTO PROFILE
  const PremiumImage.avatar(
    String url, {
    Key? key,
    double size = 50.0,
    this.errorPlaceholder,
  })  : source = url,
        type = PremiumImageType.network,
        width = size,
        height = size,
        borderRadius = 999.0, // Lingkaran sempurna
        fit = BoxFit.cover,
        super(key: key);

  /// Preset gambar network umum
  const PremiumImage.network(
    String url, {
    Key? key,
    this.width,
    this.height,
    this.borderRadius = 12.0,
    this.fit = BoxFit.cover,
    this.errorPlaceholder,
  })  : source = url,
        type = PremiumImageType.network,
        super(key: key);

  /// Preset gambar asset lokal
  const PremiumImage.asset(
    String path, {
    Key? key,
    this.width,
    this.height,
    this.borderRadius = 12.0,
    this.fit = BoxFit.cover,
    this.errorPlaceholder,
  })  : source = path,
        type = PremiumImageType.asset,
        super(key: key);

  /// Widget fallback kalau foto profil kosong atau gagal di-load
  Widget _buildErrorWidget() {
    return errorPlaceholder ??
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFFE2E8F0), // Slate 200
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Center(
            child: Icon(
              borderRadius >= 900 ? Icons.person_rounded : Icons.image_not_supported_outlined,
              color: const Color(0xFF64748B), // Slate 500
              size: width != null ? (width! * 0.5).clamp(16.0, 40.0) : 24,
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    if (source.isEmpty || source == "null") {
      return _buildErrorWidget();
    }

    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: width,
        height: height,
        child: type == PremiumImageType.network
            ? Image.network(
                source,
                width: width,
                height: height,
                fit: fit,
                // SEKARANG MENGGUNAKAN NATIVE LOADING BOX (TANPA SKELETON) 🔥
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  
                  return Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9), // Slate 100 clean
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    child: Center(
                      child: SizedBox(
                        // Ukuran spinner otomatis menyesuaikan ukuran box avatar (biar proporsional)
                        width: width != null ? (width! * 0.4).clamp(14.0, 28.0) : 24.0,
                        height: height != null ? (height! * 0.4).clamp(14.0, 28.0) : 24.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor.withOpacity(0.4)),
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null, // Otomatis presisi ngitung persen download jika didukung server
                        ),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
              )
            : Image.asset(
                source,
                width: width,
                height: height,
                fit: fit,
                errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
              ),
      ),
    );
  }
}