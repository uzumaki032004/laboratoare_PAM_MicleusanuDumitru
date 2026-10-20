import 'package:flutter/material.dart';

import 'cart_page.dart';
import 'details_page.dart';
import 'store.dart';

class ProductImage extends StatelessWidget {
  const ProductImage(this.product, {super.key, this.fit = BoxFit.cover});
  final Product product;
  final BoxFit fit;
  @override
  Widget build(BuildContext context) => ColoredBox(
    color: const Color(0xFFF1EFED),
    child: Image.asset(
      'assets/images/${product.image}',
      fit: fit,
      errorBuilder: (_, error, stack) =>
          const Center(child: Icon(Icons.checkroom, size: 60)),
    ),
  );
}

class CartButton extends StatelessWidget {
  const CartButton({super.key, required this.store});
  final Store store;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: store,
    builder: (context, _) => IconButton(
      key: const Key('open-cart'),
      tooltip: 'Coș de cumpărături',
      onPressed: () => Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => CartPage(store: store))),
      icon: Badge(
        label: Text('${store.cartCount}'),
        isLabelVisible: store.cartCount > 0,
        child: const Icon(Icons.shopping_bag_outlined),
      ),
    ),
  );
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.store,
    this.showFavorite = true,
  });
  final Product product;
  final Store store;
  final bool showFavorite;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                key: Key('product-${product.id}'),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => DetailsPage(product: product, store: store),
                  ),
                ),
                child: Semantics(
                  label: 'Detalii ${product.name}',
                  button: true,
                  child: ProductImage(product),
                ),
              ),
            ),
            if (showFavorite)
              Positioned(
                top: 6,
                right: 6,
                child: ListenableBuilder(
                  listenable: store,
                  builder: (context, _) => IconButton.filledTonal(
                    tooltip: store.isFavorite(product)
                        ? 'Elimină din favorite'
                        : 'Adaugă la favorite',
                    onPressed: () => store.toggleFavorite(product),
                    iconSize: 19,
                    style: IconButton.styleFrom(backgroundColor: Colors.white),
                    icon: Icon(
                      store.isFavorite(product)
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      Text(
        product.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 12),
      ),
      const SizedBox(height: 4),
      Text(
        money(product.priceCents),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      ),
    ],
  );
}
