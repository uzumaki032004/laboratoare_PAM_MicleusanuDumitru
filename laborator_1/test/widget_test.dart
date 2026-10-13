import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_imc/main.dart';

void main() {
  testWidgets(
    'calculează, afișează categoria și elimină rezultatul vechi la editare',
    (tester) async {
      await tester.pumpWidget(const ImcApp());
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);
      await tester.enterText(find.byKey(const Key('weight')), '70,0');
      await tester.enterText(find.byKey(const Key('height')), '175');
      await tester.tap(find.text('Calculează IMC'));
      await tester.pumpAndSettle();
      expect(find.text('IMC: 22.86'), findsOneWidget);
      expect(find.text('Normal'), findsOneWidget);
      await tester.enterText(find.byKey(const Key('weight')), '80');
      await tester.pump();
      expect(find.byKey(const Key('result')), findsNothing);
    },
  );

  testWidgets('câmpurile goale și înălțimea zero afișează erori', (
    tester,
  ) async {
    await tester.pumpWidget(const ImcApp());
    await tester.tap(find.text('Calculează IMC'));
    await tester.pumpAndSettle();
    expect(find.text('Introdu o greutate pozitivă în kg.'), findsOneWidget);
    expect(find.text('Introdu o înălțime pozitivă în cm.'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('weight')), '70');
    await tester.enterText(find.byKey(const Key('height')), '0');
    await tester.tap(find.text('Calculează IMC'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('result')), findsNothing);
    expect(find.text('Introdu o înălțime pozitivă în cm.'), findsOneWidget);
  });

  testWidgets(
    'ecran mic și tastatură: fără overflow și calcul accesibil prin scroll',
    (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;
      tester.view.viewInsets = const FakeViewPadding(bottom: 260);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const ImcApp());
      await tester.enterText(find.byKey(const Key('weight')), '95');
      await tester.enterText(find.byKey(const Key('height')), '175');
      await tester.ensureVisible(find.text('Calculează IMC'));
      await tester.tap(find.text('Calculează IMC'));
      await tester.pumpAndSettle();
      expect(find.text('Obezitate grad I'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
