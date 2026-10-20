import 'package:flutter/material.dart';

import 'store.dart';
import 'widgets.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.product, required this.store});
  final Product product;
  final Store store;
  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late String _size = widget.product.sizes.first;
  late String _color = widget.product.colors.first;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalii produs'),
        actions: [CartButton(store: widget.store)],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            key: const Key('add-to-cart'),
            onPressed: () {
              widget.store.add(product, _size, _color);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.name} a fost adăugat în coș.'),
                ),
              );
            },
            icon: const Icon(Icons.shopping_bag_outlined),
            label: Text('Adaugă în coș · ${money(product.priceCents)}'),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 370,
                    child: ProductImage(product, fit: BoxFit.contain),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ListenableBuilder(
                              listenable: widget.store,
                              builder: (context, _) => IconButton(
                                tooltip: 'Favorite',
                                onPressed: () =>
                                    widget.store.toggleFavorite(product),
                                icon: Icon(
                                  widget.store.isFavorite(product)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          money(product.priceCents),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 18,
                              color: Color(0xFFB58B43),
                            ),
                            SizedBox(width: 6),
                            Text('4.8 · Recenzie demonstrativă'),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Mărime',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 10,
                          runSpacing: 8,
                          children: [
                            for (final size in product.sizes)
                              ChoiceChip(
                                key: Key('size-$size'),
                                label: Text(size),
                                selected: size == _size,
                                onSelected: (_) => setState(() => _size = size),
                              ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Culoare: $_color',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 10,
                          runSpacing: 8,
                          children: [
                            for (final color in product.colors)
                              ChoiceChip(
                                key: Key('color-$color'),
                                label: Text(color),
                                selected: color == _color,
                                onSelected: (_) =>
                                    setState(() => _color = color),
                              ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ExpansionTile(
                          title: const Text('Descriere'),
                          initiallyExpanded: true,
                          tilePadding: EdgeInsets.zero,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Text(
                                product.description,
                                style: const TextStyle(height: 1.7),
                              ),
                            ),
                          ],
                        ),
                        const ExpansionTile(
                          title: Text('Livrare și retur'),
                          tilePadding: EdgeInsets.zero,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 16),
                              child: Text(
                                'Livrarea este gratuită în această demonstrație. '
                                'Comenzile sunt simulate și nu sunt trimise unui magazin real.',
                              ),
                            ),
                          ],
                        ),
                        const ExpansionTile(
                          title: Text('Recenzii'),
                          tilePadding: EdgeInsets.zero,
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                child: Icon(Icons.person_outline),
                              ),
                              title: Text('Ana · ★★★★★'),
                              subtitle: Text(
                                'Foarte confortabil și ușor de asortat.\nRecenzie de exemplu pentru laborator.',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
