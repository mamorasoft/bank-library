import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../functions/currency_converter.dart';

class CurrencyInput extends StatefulWidget {
  final String? label;
  final String? placeholder;
  final double? initialValue;
  final bool required;
  final String currency;
  final String locale;
  final bool showConverted;
  final String convertedCurrency;
  final double conversionRate;
  final ValueChanged<double>? onChanged;

  const CurrencyInput({
    Key? key,
    this.label,
    this.placeholder = '0.00',
    this.initialValue,
    this.required = false,
    this.currency = 'USD',
    this.locale = 'en_US',
    this.showConverted = false,
    this.convertedCurrency = 'EUR',
    this.conversionRate = 1.0,
    this.onChanged,
  }) : super(key: key);

  @override
  State<CurrencyInput> createState() => _CurrencyInputState();
}

class _CurrencyInputState extends State<CurrencyInput> {
  late TextEditingController _controller;
  double _currentValue = 0.0;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue ?? 0.0;
    _controller = TextEditingController(
      text: _currentValue > 0 ? _currentValue.toStringAsFixed(2) : '',
    );
    _controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTextChange() {
    final value = double.tryParse(_controller.text) ?? 0.0;
    setState(() {
      _currentValue = value;
    });
    widget.onChanged?.call(value);
  }

  String get _currencySymbol {
    return _getCurrencySymbol(widget.currency);
  }

  String _getCurrencySymbol(String currency) {
    const symbols = {
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'JPY': '¥',
      'IDR': 'Rp',
      'SGD': 'S\$',
      'MYR': 'RM',
    };
    return symbols[currency] ?? currency;
  }

  @override
  Widget build(BuildContext context) {
    final convertedAmount = _currentValue * widget.conversionRate;
    final formattedConverted = formatCurrency(
      convertedAmount,
      widget.convertedCurrency,
      widget.locale,
    );

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
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
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
          decoration: InputDecoration(
            hintText: widget.placeholder,
            prefixText: '$_currencySymbol ',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
        ),
        if (widget.showConverted && _currentValue > 0)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              '≈ $formattedConverted',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
      ],
    );
  }
}
