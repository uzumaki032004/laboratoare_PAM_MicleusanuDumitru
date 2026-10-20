import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gemstore_lab2/main.dart';
import 'package:gemstore_lab2/store.dart';

void main() {
  testWidgets('catalog → detalii → variante → coș → cantitate → comandă demo', (
    tester,
  ) async {
    final store = Store();
    await tester.pumpWidget(GemStoreApp(store: store));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('product-sweater')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('product-sweater')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('size-L')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('size-L')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('color-Bej')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('color-Bej')));
    await tester.tap(find.byKey(const Key('add-to-cart')));
    await tester.pumpAndSettle();
    expect(store.cart.single.size, 'L');
    expect(store.cart.single.color, 'Bej');
    await tester.tap(find.byKey(const Key('open-cart')).last);
    await tester.pumpAndSettle();
    expect(find.text('L · Bej'), findsOneWidget);
    await tester.tap(find.byTooltip('Mărește cantitatea'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('cart-total')), findsOneWidget);
    expect(store.totalCents, 7998);
    await tester.ensureVisible(find.byKey(const Key('checkout')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('checkout')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirmă demo'));
    await tester.pumpAndSettle();
    expect(find.text('Coșul este gol'), findsOneWidget);
    expect(store.cartCount, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('căutarea și filtrarea favoritelor funcționează', (tester) async {
    final store = Store()..toggleFavorite(products.first);
    await tester.pumpWidget(GemStoreApp(store: store));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('menu')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Search / All products'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('search')), 'nu-exista');
    await tester.pumpAndSettle();
    expect(find.textContaining('No products found'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('search')), '');
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('menu')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();
    expect(find.text('1 product'), findsOneWidget);
    expect(find.byKey(const Key('product-sweater')), findsOneWidget);
    await tester.tap(find.byTooltip('Elimină din favorite'));
    await tester.pumpAndSettle();
    expect(find.textContaining('No products found'), findsOneWidget);
  });

  testWidgets(
    'catalogul, detaliile și coșul nu au overflow pe ecran de 320px',
    (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final store = Store();
      await tester.pumpWidget(GemStoreApp(store: store));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'Catalog pe ecran mic');
      await tester.ensureVisible(find.byKey(const Key('product-sweater')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('product-sweater')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'Detalii pe ecran mic');
      await tester.tap(find.byKey(const Key('add-to-cart')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('open-cart')).last);
      await tester.pumpAndSettle();
      expect(find.text('Coșul tău'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('secțiunile Figma și produsul Sportwear Set sunt accesibile', (
    tester,
  ) async {
    final store = Store();
    await tester.pumpWidget(GemStoreApp(store: store));
    await tester.pumpAndSettle();
    expect(find.text('Feature Products'), findsOneWidget);
    expect(find.text('Recommended'), findsOneWidget);
    expect(find.text('Top Collection'), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('product-sportswear')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('product-sportswear')));
    await tester.pumpAndSettle();
    expect(find.text('Sportwear Set'), findsOneWidget);
    expect(find.text(r'$ 80.00'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.text('Reviews'), findsOneWidget);
    expect(find.text('Similar Product'), findsOneWidget);
    await tester.tap(find.byKey(const Key('add-to-cart')));
    await tester.pumpAndSettle();
    expect(store.cart.single.size, 'L');
    expect(store.cart.single.color, 'Bej');
    await tester.ensureVisible(find.byKey(const Key('write-review')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('write-review')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('review-input')),
      'Looks great for the demo',
    );
    await tester.tap(find.byKey(const Key('submit-review')));
    await tester.pumpAndSettle();
    expect(find.text('Looks great for the demo'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
