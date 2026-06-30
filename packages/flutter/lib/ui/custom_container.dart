import 'dart:ui';
import 'package:flutter/material.dart';

class PremiumContainer extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  
  // Kustomisasi Bentuk & Warna
  final double borderRadius;
  final Color? backgroundColor;
  final BoxBorder? border;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;
  
  // Fitur Deteksi Klik (InkWell Otomatis)
  final VoidCallback? onTap;
  final Color? splashColor;

  // Fitur Instan Premium (Tinggal set true langsung auto-bagus)
  final bool showShadow;
  final bool isGlassmorphic;
  final double blurSigma;

  const PremiumContainer({
    Key? key,
    this.child,
    this.width,
    this.height,
    this.margin,
    this.padding = const EdgeInsets.all(16.0), // Default padding biar rapi
    this.alignment,
    this.borderRadius = 16.0, // Sudut melengkung premium modern
    this.backgroundColor,
    this.border,
    this.gradient,
    this.boxShadow,
    this.onTap,
    this.splashColor,
    this.showShadow = false,
    this.isGlassmorphic = false,
    this.blurSigma = 10.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // 1. Racik Default Shadow Premium (Subtle Soft Shadow khas SaaS Modern)
    List<BoxShadow>? activeShadow = boxShadow;
    if (showShadow && boxShadow == null) {
      activeShadow = [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 16,
          spreadRadius: 2,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.02),
          blurRadius: 4,
          spreadRadius: 0,
          offset: const Offset(0, 1),
        ),
      ];
    }

    // 2. Tentukan warna background default
    Color defaultBg = backgroundColor ?? Colors.white;
    if (isGlassmorphic) {
      defaultBg = backgroundColor ?? Colors.white.withOpacity(0.2);
    }

    // 3. Bangun Struktur Dasar Kontainer
    Widget containerCore = Container(
      width: width,
      height: height,
      alignment: alignment,
      padding: padding,
      decoration: BoxDecoration(
        color: isGlassmorphic ? Colors.transparent : defaultBg,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border ?? (isGlassmorphic 
            ? Border.all(color: Colors.white.withOpacity(0.3)) 
            : Border.all(color: Colors.grey.withOpacity(0.08))),
        gradient: gradient,
        boxShadow: activeShadow,
      ),
      child: child,
    );

    // 4. Injeksi Efek Glassmorphic jika diaktifkan
    if (isGlassmorphic) {
      containerCore = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            color: defaultBg,
            child: Container(
              padding: padding,
              alignment: alignment,
              child: child,
            ),
          ),
        ),
      );
    }

    // 5. Injeksi Deteksi Klik (InkWell) dengan Kliping Sempurna biar riak air gak bocor keluar sudut
    if (onTap != null) {
      return Container(
        margin: margin,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: splashColor ?? theme.primaryColor.withOpacity(0.1),
            highlightColor: Colors.transparent,
            borderRadius: BorderRadius.circular(borderRadius),
            child: containerCore,
          ),
        ),
      );
    }

    // Jika tidak bisa diklik, kembalikan widget polosan dengan margin
    return margin != null 
        ? Padding(padding: margin!, child: containerCore) 
        : containerCore;
  }
}