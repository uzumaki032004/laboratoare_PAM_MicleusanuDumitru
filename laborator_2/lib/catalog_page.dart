import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'details_page.dart';
import 'store.dart';
import 'widgets.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key, required this.store});
  final Store store;

  void _listing(
    BuildContext context, {
    String title = 'All products',
    List<Product>? items,
    bool favorites = false,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProductListingPage(
          store: store,
          title: title,
          items: items ?? products,
          favorites: favorites,
        ),
      ),
    );
  }

  void _openProduct(BuildContext context, String id) => Navigator.push(
    context,
    MaterialPageRoute<void>(
      builder: (_) => DetailsPage(
        product: products.firstWhere((p) => p.id == id),
        store: store,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      toolbarHeight: 76,
      leading: Builder(
        builder: (context) => IconButton(
          key: const Key('menu'),
          tooltip: 'Open menu',
          onPressed: () => Scaffold.of(context).openDrawer(),
          icon: SvgPicture.asset(
            'assets/icons/meniu.svg',
            width: 20,
            height: 20,
          ),
        ),
      ),
      title: const Text(
        'GemStore',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      ),
      actions: [
        IconButton(
          key: const Key('notifications'),
          tooltip: 'Notifications',
          onPressed: () => showModalBottomSheet<void>(
            context: context,
            builder: (context) => const SafeArea(
              child: Padding(
                padding: EdgeInsets.all(28),
                child: Text(
                  'Your new autumn collection is here.\nExplore Feature Products and Top Collection.',
                  style: TextStyle(height: 1.8),
                ),
              ),
            ),
          ),
          icon: SvgPicture.asset(
            'assets/icons/notification.svg',
            width: 25,
            height: 26,
          ),
        ),
        const SizedBox(width: 20),
      ],
    ),
    drawer: Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text(
                'GemStore',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search / All products'),
              onTap: () {
                Navigator.pop(context);
                _listing(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite_border),
              title: const Text('Favorites'),
              onTap: () {
                Navigator.pop(context);
                _listing(context, title: 'Favorites', favorites: true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag_outlined),
              title: const Text('Shopping bag'),
              trailing: CartButton(store: store),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                showAboutDialog(
                  context: context,
                  applicationName: 'GemStore',
                  applicationVersion: 'PAM · Laboratorul 2',
                  children: [
                    const Text(
                      'Micleusanu Dumitru\nFigma: homepage full + product full.\nAcademic shopping demo; no real payments.',
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    ),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: SingleChildScrollView(
            key: const Key('homepage-scroll'),
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (final entry in const [
                        ('Women', '1.svg'),
                        ('Men', '2.svg'),
                        ('Accessories', '3.svg'),
                        ('Beauty', '4.svg'),
                      ])
                        Expanded(
                          child: InkWell(
                            onTap: () => _listing(
                              context,
                              title: entry.$1,
                              items: entry.$1 == 'Women' ? products : const [],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: entry.$1 == 'Women'
                                        ? const Color(0xFF3A2C27)
                                        : const Color(0xFFF7F7F7),
                                    border: Border.all(
                                      color: entry.$1 == 'Women'
                                          ? const Color(0xFF3A2C27)
                                          : const Color(0xFFF2F2F2),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: SvgPicture.asset(
                                    'assets/icons/${entry.$2}',
                                    colorFilter: ColorFilter.mode(
                                      entry.$1 == 'Women'
                                          ? Colors.white
                                          : const Color(0xFFCDCDCD),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  entry.$1,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: entry.$1 == 'Women'
                                        ? const Color(0xFF3A2C27)
                                        : const Color(0xFFB8B8B8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: InkWell(
                    onTap: () => _listing(context, title: 'Autumn Collection'),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        height: 168,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              'assets/images/imagine1.png',
                              fit: BoxFit.cover,
                            ),
                            const Positioned(
                              right: 14,
                              top: 18,
                              child: Text(
                                'Autumn\nCollection\n2021',
                                style: TextStyle(
                                  fontSize: 23,
                                  height: 1.3,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Positioned(
                              bottom: 14,
                              left: 0,
                              right: 0,
                              child: Text(
                                '◉  ●  ●',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                SectionHeading(
                  'Feature Products',
                  onShowAll: () => _listing(context),
                ),
                const SizedBox(height: 16),
                ProductRail(items: products.take(3).toList(), store: store),
                const SizedBox(height: 30),
                _CollectionBanner(
                  image: 'imagine6.png',
                  eyebrow: 'NEW COLLECTION',
                  title: 'HANG OUT\n& PARTY',
                  height: 170,
                  fullWidth: true,
                  onTap: () => _listing(
                    context,
                    title: 'Hang out & party',
                    items: products
                        .where((p) => p.category == Category.dresses)
                        .toList(),
                  ),
                ),
                const SizedBox(height: 26),
                SectionHeading(
                  'Recommended',
                  onShowAll: () => _listing(
                    context,
                    title: 'Recommended',
                    items: products
                        .where(
                          (p) => ['white-hoodie', 'cotton-tee'].contains(p.id),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 76,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    itemCount: 2,
                    separatorBuilder: (_, index) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final p = products.firstWhere(
                        (p) => p.id == ['white-hoodie', 'cotton-tee'][index],
                      );
                      return InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                DetailsPage(product: p, store: store),
                          ),
                        ),
                        child: Container(
                          width: 215,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFF1F1F1)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 58, child: ProductImage(p)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      p.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      money(p.priceCents),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                SectionHeading(
                  'Top Collection',
                  onShowAll: () => _listing(context, title: 'Top Collection'),
                ),
                const SizedBox(height: 20),
                _CollectionBanner(
                  image: 'imagine10.png',
                  eyebrow: 'Sale up to 40%',
                  title: 'FOR SLIM\n& BEAUTY',
                  height: 130,
                  onTap: () => _openProduct(context, 'wrap-dress'),
                ),
                const SizedBox(height: 16),
                _CollectionBanner(
                  image: 'imagine11.png',
                  eyebrow: 'Summer Collection 2021',
                  title: 'Most sexy\n& fabulous\ndesign',
                  height: 210,
                  onTap: () => _openProduct(context, 'office'),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    children: [
                      for (final item in [
                        ('banner5.png', 'tshirt'),
                        ('banner4.png', 'evening'),
                      ])
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: InkWell(
                              onTap: () => _openProduct(context, item.$2),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  'assets/images/${item.$1}',
                                  height: 225,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
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

class SectionHeading extends StatelessWidget {
  const SectionHeading(this.title, {super.key, required this.onShowAll});
  final String title;
  final VoidCallback onShowAll;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 32),
    child: Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
        TextButton(
          onPressed: onShowAll,
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF9B9B9B),
            padding: EdgeInsets.zero,
            minimumSize: const Size(54, 32),
          ),
          child: const Text('Show all', style: TextStyle(fontSize: 12)),
        ),
      ],
    ),
  );
}

class ProductRail extends StatelessWidget {
  const ProductRail({super.key, required this.items, required this.store});
  final List<Product> items;
  final Store store;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 238,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      itemCount: items.length,
      separatorBuilder: (_, index) => const SizedBox(width: 20),
      itemBuilder: (_, index) => SizedBox(
        width: 126,
        child: ProductCard(
          product: items[index],
          store: store,
          showFavorite: false,
        ),
      ),
    ),
  );
}

class _CollectionBanner extends StatelessWidget {
  const _CollectionBanner({
    required this.image,
    required this.eyebrow,
    required this.title,
    required this.height,
    required this.onTap,
    this.fullWidth = false,
  });
  final String image, eyebrow, title;
  final double height;
  final bool fullWidth;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: fullWidth ? 0 : 32),
    child: InkWell(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(fullWidth ? 0 : 12),
        child: Container(
          height: height,
          color: const Color(0xFFF7F7F9),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: fullWidth ? 170 : 150,
                child: Image.asset(
                  'assets/images/$image',
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomRight,
                ),
              ),
              Positioned(
                left: fullWidth ? 64 : 16,
                top: 22,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '│ $eyebrow',
                      style: const TextStyle(
                        color: Color(0xFF9195A2),
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 19,
                        height: 1.3,
                        color: Color(0xFF353945),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class ProductListingPage extends StatefulWidget {
  const ProductListingPage({
    super.key,
    required this.store,
    required this.title,
    required this.items,
    this.favorites = false,
  });
  final Store store;
  final String title;
  final List<Product> items;
  final bool favorites;
  @override
  State<ProductListingPage> createState() => _ProductListingPageState();
}

class _ProductListingPageState extends State<ProductListingPage> {
  String _query = '';
  Category? _category;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.title),
      actions: [CartButton(store: widget.store)],
    ),
    body: SafeArea(
      child: ListenableBuilder(
        listenable: widget.store,
        builder: (context, _) {
          final visible = widget.items
              .where(
                (p) =>
                    (!widget.favorites || widget.store.isFavorite(p)) &&
                    (_category == null || p.category == _category) &&
                    p.name.toLowerCase().contains(_query.toLowerCase().trim()),
              )
              .toList();
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        key: const Key('search'),
                        onChanged: (value) => setState(() => _query = value),
                        decoration: const InputDecoration(
                          hintText: 'Search products',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 6,
                        children: [
                          ChoiceChip(
                            label: const Text('All'),
                            selected: _category == null,
                            onSelected: (_) => setState(() => _category = null),
                          ),
                          for (final category in Category.values)
                            ChoiceChip(
                              label: Text(category.label),
                              selected: _category == category,
                              onSelected: (_) =>
                                  setState(() => _category = category),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${visible.length} ${visible.length == 1 ? 'product' : 'products'}',
                      ),
                    ],
                  ),
                ),
              ),
              if (visible.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text(
                      'No products found. Try another search or explore the Women collection.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 250,
                          mainAxisExtent: 280,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 16,
                        ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ProductCard(
                        product: visible[index],
                        store: widget.store,
                      ),
                      childCount: visible.length,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    ),
  );
}
