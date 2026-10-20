import 'package:flutter/material.dart';
import 'catalog_page.dart';
import 'cart_page.dart';
import 'store.dart';
import 'widgets.dart';

const _green = Color(0xFF508A7B);

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.product, required this.store});
  final Product product;
  final Store store;
  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late String _size = widget.product.id == 'sportswear'
      ? 'L'
      : widget.product.sizes.first;
  late String _color = widget.product.colors.contains('Bej')
      ? 'Bej'
      : widget.product.colors.first;
  int _photo = 0;
  bool _readMore = false;
  bool _newest = true;

  Color _swatch(String color) => switch (color) {
    'Bej' => const Color(0xFFE7BEA6),
    'Negru' => const Color(0xFF222222),
    'Roșu' => const Color(0xFFF5656E),
    _ => const Color(0xFF667FA3),
  };

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final gallery = [
      product.detailImage ?? product.image,
      product.image,
      product.detailImage ?? product.image,
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCFA),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          decoration: const BoxDecoration(
            color: Color(0xFF333333),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: FilledButton.icon(
            key: const Key('add-to-cart'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF333333),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              widget.store.add(product, _size, _color);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Added to your bag'),
                  action: SnackBarAction(
                    label: 'View bag',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => CartPage(store: widget.store),
                      ),
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.shopping_bag, size: 19),
            label: const Text(
              'Add To Cart',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: SingleChildScrollView(
              key: const Key('details-scroll'),
              child: Column(
                children: [
                  SizedBox(
                    height: 390,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 60,
                          right: 15,
                          top: 140,
                          child: Container(
                            height: 235,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFFAF1E9),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: PageView.builder(
                            itemCount: gallery.length,
                            onPageChanged: (index) =>
                                setState(() => _photo = index),
                            itemBuilder: (context, index) => ClipRect(
                              child: OverflowBox(
                                maxHeight: 532,
                                alignment: Alignment.topCenter,
                                child: Image.asset(
                                  'assets/images/${gallery[index]}',
                                  height: 532,
                                  fit: BoxFit.contain,
                                  alignment: Alignment.topCenter,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 20,
                          top: 16,
                          child: IconButton.filledTonal(
                            tooltip: 'Back',
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF466F9B),
                            ),
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.chevron_left),
                          ),
                        ),
                        Positioned(
                          right: 20,
                          top: 16,
                          child: ListenableBuilder(
                            listenable: widget.store,
                            builder: (context, _) => IconButton.filledTonal(
                              tooltip: 'Favorite',
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFFF66576),
                              ),
                              onPressed: () =>
                                  widget.store.toggleFavorite(product),
                              icon: Icon(
                                widget.store.isFavorite(product)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 70,
                          top: 16,
                          child: ListenableBuilder(
                            listenable: widget.store,
                            builder: (context, _) => widget.store.cartCount == 0
                                ? const SizedBox.shrink()
                                : DecoratedBox(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: CartButton(store: widget.store),
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 14,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              3,
                              (index) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 3,
                                ),
                                child: Container(
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _photo == index
                                        ? const Color(0xFF333333)
                                        : const Color(0xFFCECECE),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      border: Border.all(color: const Color(0xFFF2F2F2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(32, 46, 32, 0),
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
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    money(
                                      product.priceCents,
                                    ).replaceFirst(r'$', r'$ '),
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Row(
                                children: [
                                  StarRating(),
                                  SizedBox(width: 5),
                                  Text(
                                    '(83)',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFFAAAAAA),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 28),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Color',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF929292),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Wrap(
                                          spacing: 5,
                                          runSpacing: 5,
                                          children: [
                                            for (final color in product.colors)
                                              Semantics(
                                                label: 'Color $color',
                                                selected: color == _color,
                                                button: true,
                                                child: InkWell(
                                                  key: Key('color-$color'),
                                                  onTap: () => setState(
                                                    () => _color = color,
                                                  ),
                                                  child: Tooltip(
                                                    message: color,
                                                    child: Container(
                                                      width: 30,
                                                      height: 30,
                                                      padding:
                                                          const EdgeInsets.all(
                                                            3,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: color == _color
                                                              ? _swatch(color)
                                                              : Colors
                                                                    .transparent,
                                                        ),
                                                      ),
                                                      child: DecoratedBox(
                                                        decoration:
                                                            BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: _swatch(
                                                                color,
                                                              ),
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Size',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF929292),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Wrap(
                                          spacing: 5,
                                          runSpacing: 5,
                                          children: [
                                            for (final size in product.sizes)
                                              Semantics(
                                                label: 'Size $size',
                                                selected: size == _size,
                                                button: true,
                                                child: InkWell(
                                                  key: Key('size-$size'),
                                                  onTap: () => setState(
                                                    () => _size = size,
                                                  ),
                                                  child: Container(
                                                    width: 31,
                                                    height: 31,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: size == _size
                                                          ? const Color(
                                                              0xFF515151,
                                                            )
                                                          : const Color(
                                                              0xFFF8F8F8,
                                                            ),
                                                    ),
                                                    child: Text(
                                                      size,
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color: size == _size
                                                            ? Colors.white
                                                            : const Color(
                                                                0xFFBABABA,
                                                              ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 22),
                              ExpansionTile(
                                title: const Text(
                                  'Description',
                                  style: TextStyle(fontSize: 14),
                                ),
                                initiallyExpanded: true,
                                tilePadding: EdgeInsets.zero,
                                childrenPadding: const EdgeInsets.only(
                                  bottom: 16,
                                ),
                                children: [
                                  Text(
                                    product.id == 'sportswear'
                                        ? 'Sportswear is no longer under culture, it is no longer indie or cobbled together as it once was. '
                                              'Sport is fashion today. The top is oversized in fit and style, may need to size down.'
                                        : product.description,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      height: 1.8,
                                      color: Color(0xFF929292),
                                    ),
                                  ),
                                  if (_readMore)
                                    const Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        'Designed for everyday comfort. Choose your preferred size and color before adding to your bag. '
                                        'Product information is provided for this academic demo.',
                                        style: TextStyle(
                                          fontSize: 12,
                                          height: 1.8,
                                          color: Color(0xFF929292),
                                        ),
                                      ),
                                    ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextButton(
                                      onPressed: () => setState(
                                        () => _readMore = !_readMore,
                                      ),
                                      child: Text(
                                        _readMore ? 'Read less' : 'Read more',
                                        style: const TextStyle(
                                          color: _green,
                                          fontSize: 12,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ExpansionTile(
                                title: const Text(
                                  'Reviews',
                                  style: TextStyle(fontSize: 14),
                                ),
                                initiallyExpanded: true,
                                tilePadding: EdgeInsets.zero,
                                children: [
                                  const _RatingSummary(),
                                  const SizedBox(height: 18),
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: Text(
                                          '47 REVIEWS',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Color(0xFFAAAAAA),
                                          ),
                                        ),
                                      ),
                                      PopupMenuButton<bool>(
                                        tooltip: 'Sort reviews',
                                        initialValue: _newest,
                                        onSelected: (value) =>
                                            setState(() => _newest = value),
                                        itemBuilder: (_) => [
                                          const PopupMenuItem(
                                            value: true,
                                            child: Text('Newest first'),
                                          ),
                                          const PopupMenuItem(
                                            value: false,
                                            child: Text('Oldest first'),
                                          ),
                                        ],
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          child: Text(
                                            _newest
                                                ? 'WRITE A REVIEW  ⌄  NEWEST'
                                                : 'WRITE A REVIEW  ⌄  OLDEST',
                                            style: const TextStyle(
                                              fontSize: 9,
                                              color: Color(0xFFAAAAAA),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  for (final review
                                      in (_newest
                                          ? const [0, 1]
                                          : const [1, 0]))
                                    _Review(index: review),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ExpansionTile(
                          title: const Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(
                              'Similar Product',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          initiallyExpanded: true,
                          childrenPadding: const EdgeInsets.only(bottom: 30),
                          children: [
                            const SizedBox(height: 18),
                            ProductRail(
                              items: products
                                  .where(
                                    (p) => [
                                      'rise-hoodie',
                                      'gym-top',
                                      'sport-sweatshirt',
                                    ].contains(p.id),
                                  )
                                  .toList(),
                              store: widget.store,
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

class StarRating extends StatelessWidget {
  const StarRating({super.key, this.size = 16});
  final double size;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(
      5,
      (index) => Icon(Icons.star, color: _green, size: size),
    ),
  );
}

class _RatingSummary extends StatelessWidget {
  const _RatingSummary();
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          const Text(
            '4.9',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'OUT OF 5',
              style: TextStyle(fontSize: 10, color: Color(0xFFAAAAAA)),
            ),
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              StarRating(),
              SizedBox(height: 4),
              Text(
                '83 ratings',
                style: TextStyle(fontSize: 10, color: Color(0xFFAAAAAA)),
              ),
            ],
          ),
        ],
      ),
      const SizedBox(height: 20),
      for (final entry in const [(5, 80), (4, 12), (3, 5), (2, 2), (1, 1)])
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Text(
                '${entry.$1}',
                style: const TextStyle(fontSize: 10, color: _green),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.star, size: 10, color: _green),
              const SizedBox(width: 10),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: entry.$2 / 100,
                    minHeight: 3,
                    color: _green,
                    backgroundColor: const Color(0xFFF3F3F5),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 28,
                child: Text(
                  '${entry.$2}%',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF929292),
                  ),
                ),
              ),
            ],
          ),
        ),
    ],
  );
}

class _Review extends StatelessWidget {
  const _Review({required this.index});
  final int index;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 17,
              backgroundImage: AssetImage(
                'assets/images/imagine${index == 0 ? 15 : 16}.png',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    index == 0 ? 'Jennifer Rona' : 'Kelly Rihana',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const StarRating(size: 11),
                ],
              ),
            ),
            Text(
              index == 0 ? '2m ago' : '9m ago',
              style: const TextStyle(fontSize: 10, color: Color(0xFFBBBBBB)),
            ),
          ],
        ),
        const SizedBox(height: 14),
        const Text(
          "I'm very happy with order, It was delivered on and good quality. Recommended!",
          style: TextStyle(fontSize: 11, height: 1.7, color: Color(0xFF929292)),
        ),
      ],
    ),
  );
}
