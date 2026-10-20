import 'package:flutter_test/flutter_test.dart';
import 'package:gemstore_lab2/store.dart';

void main() {
  test(
    'aceeași variantă mărește cantitatea; alte variante au rând separat',
    () {
      final store = Store();
      final product = products.first;
      store.add(product, 'S', 'Negru');
      store.add(product, 'S', 'Negru');
      store.add(product, 'L', 'Bej');
      expect(store.cart.length, 2);
      expect(store.cartCount, 3);
      expect(store.cart.first.quantity, 2);
      expect(store.totalCents, product.priceCents * 3);
      expect(store.cart.last.size, 'L');
      expect(store.cart.last.color, 'Bej');
    },
  );

  test('cantitatea zero elimină rândul; totalul rămâne exact în cenți', () {
    final store = Store();
    store.add(products.first, 'S', 'Negru');
    store.changeQuantity(store.cart.first, 1);
    expect(money(store.totalCents), r'$79.98');
    store.changeQuantity(store.cart.first, -1);
    store.changeQuantity(store.cart.first, -1);
    expect(store.cart, isEmpty);
    expect(store.totalCents, 0);
  });

  test('validarea variantelor și gestionarea favoritelor', () {
    final store = Store();
    expect(
      () => store.add(products.first, 'XXXL', 'Negru'),
      throwsArgumentError,
    );
    expect(store.cart, isEmpty);
    store.toggleFavorite(products.first);
    expect(store.isFavorite(products.first), isTrue);
    store.toggleFavorite(products.first);
    expect(store.isFavorite(products.first), isFalse);
  });

  test('ștergerea și confirmarea comenzii golesc corect coșul', () {
    final store = Store();
    store.add(products.first, 'M', 'Bej');
    store.remove(store.cart.first);
    expect(store.cartCount, 0);
    store.add(products.last, 'S', 'Negru');
    store.clearCart();
    expect(store.cartCount, 0);
    expect(store.totalCents, 0);
  });

  test('toate categoriile au produse și identificatorii sunt unici', () {
    expect(products.map((p) => p.id).toSet().length, products.length);
    for (final category in Category.values) {
      expect(products.where((p) => p.category == category), isNotEmpty);
    }
  });
}
