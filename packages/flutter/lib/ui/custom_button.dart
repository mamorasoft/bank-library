import 'package:flutter/material.dart';

// ===========================================================================
// 1. PREMIUM STANDARD BUTTON (Filled/Elevated)
// ===========================================================================
class CustomButon extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  const CustomButon({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height = 48.0, // Standar tinggi tombol modern & nyaman di-klik
    this.backgroundColor,
    this.textStyle,
    this.borderRadius = 12.0, // Lebih melengkung biar kekinian
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: margin ?? EdgeInsets.zero,
      width: width ?? double.infinity, // Default penuhi lebar layar jika null
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? theme.primaryColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textStyle ??
              const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}

// ===========================================================================
// 2. PREMIUM FLAT BUTTON (Text Only)
// ===========================================================================
class PremiumFlatButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final Color? textColor;
  final double fontSize;
  final TextAlign textAlign;
  final EdgeInsetsGeometry? margin;

  const PremiumFlatButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.textColor,
    this.fontSize = 14.0,
    this.textAlign = TextAlign.center,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: margin,
      width: width,
      height: height,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          textAlign: textAlign,
          style: TextStyle(
            color: textColor ?? theme.primaryColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// 3. PREMIUM ICON BUTTON (Icon Only or Icon + Text)
// ===========================================================================
class PremiumIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String? text; // Jika diisi, otomatis jadi Icon + Text berdampingan
  final Color? iconColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;

  const PremiumIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.text,
    this.iconColor,
    this.textColor,
    this.width,
    this.height,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeIconColor = iconColor ?? theme.primaryColor;

    return Container(
      margin: margin,
      width: width,
      height: height,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: text != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: activeIconColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      text!,
                      style: TextStyle(
                        color: textColor ?? activeIconColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              : Icon(icon, color: activeIconColor, size: 24),
        ),
      ),
    );
  }
}

// ===========================================================================
// 4. PREMIUM OUTLINE BUTTON (Border Only)
// ===========================================================================
class PremiumOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? borderColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double borderRadius;

  const PremiumOutlineButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.borderColor,
    this.textColor,
    this.width,
    this.height = 48.0,
    this.borderRadius = 12.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeBorderColor = borderColor ?? theme.primaryColor;

    return Container(
      width: width ?? double.infinity,
      height: height,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: activeBorderColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: textColor ?? activeBorderColor,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}