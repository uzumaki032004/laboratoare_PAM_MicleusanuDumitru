import 'package:flutter/material.dart';

import 'store.dart';
import 'widgets.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key, required this.store});
  final Store store;
  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  Category? _category;
  bool _favoritesOnly = false;
  String _query = '';

  void _selectCategory(Category? category) => setState(() {
    _category = category;
    _favoritesOnly = false;
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'GemStore',
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
      actions: [
        CartButton(store: widget.store),
        const SizedBox(width: 8),
      ],
    ),
    drawer: Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'GemStore',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Stilul tău, în fiecare zi.'),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.grid_view),
              title: const Text('Toate produsele'),
              onTap: () {
                _selectCategory(null);
                Navigator.pop(context);
              },
            ),
            for (final category in Category.values)
              ListTile(
                leading: Icon(category.icon),
                title: Text(category.label),
                onTap: () {
                  _selectCategory(category);
                  Navigator.pop(context);
                },
              ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.favorite_border),
              title: const Text('Favorite'),
              onTap: () {
                setState(() {
                  _favoritesOnly = true;
                  _category = null;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Despre aplicație'),
              onTap: () {
                Navigator.pop(context);
                showAboutDialog(
                  context: context,
                  applicationName: 'GemStore',
                  applicationVersion: 'Laboratorul 2 PAM',
                  children: [
                    const Text(
                      'Micleusanu Dumitru\nMagazin vestimentar demonstrativ.\nDate locale; nu se efectuează plăți reale.',
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
          constraints: const BoxConstraints(maxWidth: 1000),
          child: ListenableBuilder(
            listenable: widget.store,
            builder: (context, _) {
              final visible = products
                  .where(
                    (p) =>
                        (_category == null || p.category == _category) &&
                        (!_favoritesOnly || widget.store.isFavorite(p)) &&
                        p.name.toLowerCase().contains(
                          _query.toLowerCase().trim(),
                        ),
                  )
                  .toList();
              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            key: const Key('search'),
                            onChanged: (value) =>
                                setState(() => _query = value),
                            decoration: const InputDecoration(
                              hintText: 'Caută un produs',
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: ChoiceChip(
                                    label: const Text('Toate'),
                                    selected:
                                        _category == null && !_favoritesOnly,
                                    onSelected: (_) => _selectCategory(null),
                                  ),
                                ),
                                for (final category in Category.values)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: ChoiceChip(
                                      avatar: Icon(category.icon, size: 18),
                                      label: Text(category.label),
                                      selected:
                                          _category == category &&
                                          !_favoritesOnly,
                                      onSelected: (_) =>
                                          _selectCategory(category),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          if (_query.isEmpty && !_favoritesOnly) ...[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: SizedBox(
                                height: 190,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.asset(
                                      'assets/images/imagine1.png',
                                      fit: BoxFit.cover,
                                    ),
                                    const DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Color(0xAA000000),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Positioned(
                                      right: 18,
                                      top: 30,
                                      child: Text(
                                        'Autumn\nCollection\n2026',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 27,
                                          fontWeight: FontWeight.w800,
                                          height: 1.2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 26),
                          ],
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _favoritesOnly
                                      ? 'Favoritele tale'
                                      : 'Colecția noastră',
                                  style: const TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: _favoritesOnly
                                    ? 'Arată catalogul'
                                    : 'Arată favoritele',
                                onPressed: () => setState(() {
                                  _favoritesOnly = !_favoritesOnly;
                                  _category = null;
                                }),
                                icon: Icon(
                                  _favoritesOnly
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${visible.length} produse',
                            style: const TextStyle(color: Colors.black54),
                          ),
                          const SizedBox(height: 18),
                        ],
                      ),
                    ),
                  ),
                  if (visible.isEmpty)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Text(
                          'Nu am găsit produse. Încearcă altă căutare sau adaugă produse la favorite.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      sliver: SliverLayoutBuilder(
                        builder: (context, constraints) => SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    constraints.crossAxisExtent > 650 ? 4 : 2,
                                mainAxisExtent: 285,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 24,
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
                    ),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(28),
                      child: Text(
                        'GEMSTORE · Colecții pentru fiecare zi\nLaboratorul 2 · Micleusanu Dumitru',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54, height: 1.8),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    ),
  );
}
