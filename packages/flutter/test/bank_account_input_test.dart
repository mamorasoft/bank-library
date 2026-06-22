import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bank_library/ui/bank_account_input.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('uses default decoration when none is provided', (tester) async {
    await tester.pumpWidget(wrap(const BankAccountInput(
      placeholder: 'Enter account number',
    )));

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.decoration?.hintText, 'Enter account number');
    expect(field.decoration?.border, isA<OutlineInputBorder>());
  });

  testWidgets('merges custom decoration without losing default hintText', (tester) async {
    final customBorder = OutlineInputBorder(borderRadius: BorderRadius.circular(20));

    await tester.pumpWidget(wrap(BankAccountInput(
      placeholder: 'Enter account number',
      decoration: InputDecoration(border: customBorder),
    )));

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.decoration?.border, customBorder);
    expect(field.decoration?.hintText, 'Enter account number');
  });

  testWidgets('applies custom text style without breaking input behavior', (tester) async {
    const customStyle = TextStyle(fontSize: 22);

    await tester.pumpWidget(wrap(const BankAccountInput(
      style: customStyle,
    )));

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.style, customStyle);

    await tester.enterText(find.byType(TextField), '1234567890');
    expect(find.text('1234567890'), findsOneWidget);
  });
}
