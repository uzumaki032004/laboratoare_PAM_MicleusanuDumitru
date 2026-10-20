import 'package:flutter/material.dart';

import 'store.dart';
import 'widgets.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key, required this.store});
  final Store store;

  Future<void> _checkout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmare comandă demo'),
        content: Text(
          '${store.cartCount} articole · Total ${money(store.totalCents)}\n\n'
          'Aceasta este o simulare pentru laborator. Nu se efectuează nicio plată.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Înapoi'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirmă demo'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      store.clearCart();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Comanda demonstrativă a fost confirmată.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Coșul tău')),
    body: SafeArea(
      child: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          if (store.cart.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.shopping_bag_outlined,
                      size: 70,
                      color: Colors.black38,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Coșul este gol',
                      style: TextStyle(fontSize: 23),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Continuă cumpărăturile'),
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 750),
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  for (final item in store.cart)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: SizedBox(
                              width: 72,
                              height: 105,
                              child: ProductImage(item.product),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${item.size} · ${item.color}',
                                  style: const TextStyle(color: Colors.black54),
                                ),
                                const SizedBox(height: 5),
                                Text(money(item.totalCents)),
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    IconButton(
                                      tooltip: 'Micșorează cantitatea',
                                      onPressed: () =>
                                          store.changeQuantity(item, -1),
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                      ),
                                    ),
                                    Text(
                                      '${item.quantity}',
                                      key: Key(
                                        'quantity-${item.product.id}-${item.size}-${item.color}',
                                      ),
                                    ),
                                    IconButton(
                                      tooltip: 'Mărește cantitatea',
                                      onPressed: () =>
                                          store.changeQuantity(item, 1),
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                      ),
                                    ),
                                    IconButton(
                                      tooltip: 'Șterge produsul',
                                      onPressed: () => store.remove(item),
                                      icon: const Icon(Icons.delete_outline),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [const Text('Livrare'), const Text('Gratuită')],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        money(store.totalCents),
                        key: const Key('cart-total'),
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    key: const Key('checkout'),
                    onPressed: () => _checkout(context),
                    child: const Text('Finalizează comanda demo'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}
