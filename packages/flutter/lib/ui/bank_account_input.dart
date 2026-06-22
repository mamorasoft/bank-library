import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../functions/account_validator.dart';

class BankAccountInput extends StatefulWidget {
  final String? label;
  final String? placeholder;
  final String? initialValue;
  final bool required;
  final bool showValidation;
  final String errorMessage;
  final String bankCode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<bool>? onValidate;
  final InputDecoration? decoration;
  final TextStyle? style;
  final TextStyle? labelStyle;
  final TextStyle? errorStyle;

  const BankAccountInput({
    Key? key,
    this.label,
    this.placeholder = 'Enter account number',
    this.initialValue,
    this.required = false,
    this.showValidation = true,
    this.errorMessage = 'Invalid account number',
    this.bankCode = '',
    this.onChanged,
    this.onValidate,
    this.decoration,
    this.style,
    this.labelStyle,
    this.errorStyle,
  }) : super(key: key);

  @override
  State<BankAccountInput> createState() => _BankAccountInputState();
}

class _BankAccountInputState extends State<BankAccountInput> {
  late TextEditingController _controller;
  bool _isValid = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTextChange() {
    final value = _controller.text;
    final isValid = value.isEmpty || validateAccountNumber(value, widget.bankCode);
    
    setState(() {
      _isValid = isValid;
    });

    widget.onChanged?.call(value);
    if (value.isNotEmpty) {
      widget.onValidate?.call(isValid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultLabelStyle = const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14,
    ).merge(widget.labelStyle);

    final defaultDecoration = InputDecoration(
      hintText: widget.placeholder,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      errorText: !_isValid && _controller.text.isNotEmpty
          ? widget.errorMessage
          : null,
      errorStyle: widget.errorStyle,
      suffixIcon: widget.showValidation && _controller.text.isNotEmpty
          ? Icon(
              _isValid ? Icons.check_circle : Icons.error,
              color: _isValid ? Colors.green : Colors.red,
            )
          : null,
    );
    final effectiveDecoration = widget.decoration != null
        ? defaultDecoration.copyWith(
            icon: widget.decoration!.icon,
            labelText: widget.decoration!.labelText,
            labelStyle: widget.decoration!.labelStyle,
            helperText: widget.decoration!.helperText,
            helperStyle: widget.decoration!.helperStyle,
            hintText: widget.decoration!.hintText ?? defaultDecoration.hintText,
            hintStyle: widget.decoration!.hintStyle,
            errorText: widget.decoration!.errorText ?? defaultDecoration.errorText,
            errorStyle: widget.decoration!.errorStyle ?? defaultDecoration.errorStyle,
            prefixIcon: widget.decoration!.prefixIcon,
            prefix: widget.decoration!.prefix,
            prefixText: widget.decoration!.prefixText,
            suffixIcon: widget.decoration!.suffixIcon ?? defaultDecoration.suffixIcon,
            suffix: widget.decoration!.suffix,
            suffixText: widget.decoration!.suffixText,
            border: widget.decoration!.border ?? defaultDecoration.border,
            fillColor: widget.decoration!.fillColor,
            filled: widget.decoration!.filled,
            contentPadding: widget.decoration!.contentPadding,
          )
        : defaultDecoration;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Text(
                  widget.label!,
                  style: defaultLabelStyle,
                ),
                if (widget.required)
                  const Text(
                    ' *',
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
        TextField(
          controller: _controller,
          style: widget.style,
          decoration: effectiveDecoration,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
      ],
    );
  }
}
