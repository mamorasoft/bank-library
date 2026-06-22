import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bank_library/ui/currency_input.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('uses default decoration when none is provided', (tester) async {
    await tester.pumpWidget(wrap(const CurrencyInput(
      currency: 'USD',
    )));

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.decoration?.prefixText, '\$ ');
  });

  testWidgets('merges custom decoration without losing default prefixText', (tester) async {
    final customBorder = OutlineInputBorder(borderRadius: BorderRadius.circular(20));

    await tester.pumpWidget(wrap(CurrencyInput(
      currency: 'USD',
      decoration: InputDecoration(border: customBorder),
    )));

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.decoration?.border, customBorder);
    expect(field.decoration?.prefixText, '\$ ');
  });

  testWidgets('applies custom converted amount style', (tester) async {
    const customStyle = TextStyle(fontSize: 18, color: Colors.blue);

    await tester.pumpWidget(wrap(const CurrencyInput(
      initialValue: 100,
      showConverted: true,
      conversionRate: 2,
      convertedAmountStyle: customStyle,
    )));

    final convertedText = tester.widget<Text>(find.textContaining('≈'));
    expect(convertedText.style?.fontSize, 18);
    expect(convertedText.style?.color, Colors.blue);
  });
}
