import 'package:flutter/material.dart';

class CustomSkeleton extends StatefulWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxShape shape;
  final EdgeInsetsGeometry? margin;

  const CustomSkeleton({
    Key? key,
    this.width,
    this.height,
    this.borderRadius = 12.0, // Sudut melengkung premium modern
    this.shape = BoxShape.rectangle,
    this.margin,
  }) : super(key: key);

  /// Preset instan untuk membuat skeleton berbentuk LINGKARAN (Misal: Foto Profil/Avatar)
  const CustomSkeleton.circle({
    Key? key,
    required double size,
    this.margin,
  })  : width = size,
        height = size,
        borderRadius = 0.0,
        shape = BoxShape.circle,
        super(key: key);

  /// Preset instan untuk membuat skeleton berbentuk GARIS TEKS (Misal: Judul, Subtitle)
  const CustomSkeleton.textLine({
    Key? key,
    required this.width,
    this.height = 16.0,
    this.borderRadius = 6.0,
    this.margin,
  })  : shape = BoxShape.rectangle,
        super(key: key);

  @override
  State<CustomSkeleton> createState() => _PremiumSkeletonState();
}

class _PremiumSkeletonState extends State<CustomSkeleton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _gradientPosition;

  @override
  void initState() {
    super.initState();
    // Durasi 1.2 detik biar transisi efek kilatan cahayanya mulus dan elegan
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(); // Otomatis loop terus-menerus

    // Menggerakkan posisi gradient dari kiri luar (-2.0) ke kanan luar (2.0)
    _gradientPosition = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Wajib di-dispose biar gak bocor memori HP (memory leak)
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _gradientPosition,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          margin: widget.margin,
          decoration: BoxDecoration(
            shape: widget.shape,
            borderRadius: widget.shape == BoxShape.circle 
                ? null 
                : BorderRadius.circular(widget.borderRadius),
            // Racikan Efek Kilatan Shimmer Cahaya Bergerak
            gradient: LinearGradient(
              begin: Alignment(_gradientPosition.value, -0.3),
              end: Alignment(_gradientPosition.value + 1.2, 0.3),
              colors: [
                Colors.grey[300]!, // Warna dasar abu-abu
                Colors.grey[100]!, // Kilatan cahaya putih di tengah
                Colors.grey[300]!, // Kembali ke abu-abu
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}