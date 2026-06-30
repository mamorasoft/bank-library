import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PremiumTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  
  // Konfigurasi Validasi & Tipe Input
  final bool isRequired;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  
  // Utalitas Layout
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final int? maxLength;
  final bool enabled;
  final TextInputAction? textInputAction;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;

  const PremiumTextField({
    Key? key,
    required this.label,
    required this.hint,
    required this.controller,
    this.isRequired = false,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.textInputAction,
    this.onChanged,
    this.onFieldSubmitted,
  }) : super(key: key);

  @override
  State<PremiumTextField> createState() => _PremiumTextFieldState();
}

class _PremiumTextFieldState extends State<PremiumTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    // Jika inputan adalah password, default-nya teks disembunyikan
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. BAGIAN LABEL + BINTANG MERAH (REQUIRED)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.label,
              style: const TextStyle(
                color: Color(0xFF334155), // Slate 700 mewah
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (widget.isRequired)
              const Text(
                " *",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
          ],
        ),
        const SizedBox(height: 8),

        // 2. TEXT FORM FIELD UTAMA
        TextFormField(
          controller: widget.controller,
          enabled: widget.enabled,
          // Catatan: Jika input password, maxLines wajib 1 agar tidak crash di internal Flutter
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          maxLength: widget.maxLength,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          inputFormatters: widget.inputFormatters,
          textInputAction: widget.textInputAction,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
          
          // Style teks inputan user
          style: const TextStyle(
            color: Color(0xFF1E293B), // Slate 800
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14, fontWeight: FontWeight.w400),
            filled: true,
            fillColor: widget.enabled ? const Color(0xFFF8FAFC) : Colors.grey[100],
            counterText: "", // Menyembunyikan counter text bawaan maxLength jika tidak dibutuhkan
            
            // Ikon bagian kiri
            prefixIcon: widget.prefixIcon != null 
                ? Icon(widget.prefixIcon, color: const Color(0xFF64748B), size: 20) 
                : null,
            
            // Ikon bagian kanan (Otomatis handle toggle mata jika isPassword = true)
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                      color: const Color(0xFF64748B),
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : widget.suffixIcon,
            
            // Padding di dalam textfield
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            
            // STATE BORDER 1: NORMAL
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1.2),
            ),
            
            // STATE BORDER 2: FOKUS (PAS DI-KLIK USER)
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.primaryColor, width: 1.6),
            ),
            
            // STATE BORDER 3: ERROR VALIDASI
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.2),
            ),
            
            // STATE BORDER 4: FOKUS SAAT LAGI ERROR
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.6),
            ),
            
            // Style Pesan Error di bawah textfield
            errorStyle: const TextStyle(
              color: Color(0xFFEF4444),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}