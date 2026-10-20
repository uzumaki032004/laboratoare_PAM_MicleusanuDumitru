import 'package:flutter/material.dart';

enum Category {
  knitwear('Pulovere', Icons.checkroom),
  dresses('Rochii', Icons.woman_2_outlined),
  sets('Seturi', Icons.sports_gymnastics),
  basics('Tricouri', Icons.dry_cleaning_outlined);

  const Category(this.label, this.icon);
  final String label;
  final IconData icon;
}

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.priceCents,
    required this.image,
    required this.category,
    required this.description,
    this.detailImage,
    this.sizes = const ['S', 'M', 'L', 'XL'],
    this.colors = const ['Bej', 'Negru', 'Roșu'],
  });
  final String id;
  final String name;
  final int priceCents;
  final String image;
  final String? detailImage;
  final Category category;
  final String description;
  final List<String> sizes;
  final List<String> colors;
}

const products = [
  Product(
    id: 'sweater',
    name: 'Turtleneck Sweater',
    priceCents: 3999,
    image: 'imagine2.png',
    category: Category.knitwear,
    description:
        'Pulover cu guler înalt și croială confortabilă. Ideal pentru ținutele de toamnă. Material moale, plăcut la atingere.',
  ),
  Product(
    id: 'dress',
    name: 'Long Sleeve Dress',
    priceCents: 4500,
    image: 'imagine3.png',
    category: Category.dresses,
    description:
        'Rochie cu mânecă lungă, potrivită pentru birou și plimbări. Croială lejeră și detalii simple.',
  ),
  Product(
    id: 'sportswear',
    name: 'Sportwear Set',
    priceCents: 8000,
    image: 'imagine5.png',
    detailImage: 'imagine14.png',
    sizes: ['S', 'M', 'L'],
    category: Category.sets,
    description:
        'Set sport cu libertate de mișcare, potrivit pentru antrenament și relaxare. Două piese ușor de combinat.',
  ),
  Product(
    id: 'shirt-dress',
    name: 'Satin Shirt Dress',
    priceCents: 5500,
    image: 'imagine9.png',
    category: Category.dresses,
    description:
        'Rochie tip cămașă, cu cordon în talie și croială confortabilă.',
  ),
  Product(
    id: 'wrap-dress',
    name: 'Golden Wrap Dress',
    priceCents: 6900,
    image: 'imagine10.png',
    category: Category.dresses,
    description: 'Rochie cu mâneci lungi, decolteu în V și cordon reglabil.',
  ),
  Product(
    id: 'office',
    name: 'Office Two-Piece',
    priceCents: 9900,
    image: 'imagine11.png',
    category: Category.sets,
    description:
        'Set pentru birou cu sacou și pantaloni. O ținută elegantă pentru fiecare zi.',
  ),
  Product(
    id: 'tshirt',
    name: 'Essential Cotton Tee',
    priceCents: 2499,
    image: 'imagine12.png',
    category: Category.basics,
    description:
        'Tricou alb cu croială simplă, ușor de asortat cu blugi sau pantaloni.',
  ),
  Product(
    id: 'evening',
    name: 'White Evening Dress',
    priceCents: 7999,
    image: 'imagine13.png',
    category: Category.dresses,
    description: 'Rochie albă cu design asimetric pentru ocazii speciale.',
  ),
  Product(
    id: 'white-hoodie',
    name: 'White fashion hoodie',
    priceCents: 2900,
    image: 'imaginea7.png',
    category: Category.knitwear,
    description: 'A soft white hoodie for relaxed, everyday outfits.',
  ),
  Product(
    id: 'cotton-tee',
    name: 'Cotton T-shirt',
    priceCents: 3000,
    image: 'imaginea8.png',
    category: Category.basics,
    description: 'An everyday cotton T-shirt with a comfortable fit.',
  ),
  Product(
    id: 'rise-hoodie',
    name: 'Rise Crop Hoodie',
    priceCents: 4300,
    image: 'imagine17.png',
    category: Category.sets,
    description: 'A cropped training hoodie for effortless movement.',
  ),
  Product(
    id: 'gym-top',
    name: 'Gym Crop Top',
    priceCents: 3999,
    image: 'imagine18.png',
    category: Category.basics,
    description: 'A lightweight cropped top for your daily workout.',
  ),
  Product(
    id: 'sport-sweatshirt',
    name: 'Sport Sweatshirt',
    priceCents: 4799,
    image: 'imagine19.png',
    category: Category.knitwear,
    description: 'A comfortable sweatshirt for warming up and cooling down.',
  ),
];

String money(int cents) => '\$${(cents / 100).toStringAsFixed(2)}';

class CartItem {
  CartItem(this.product, this.size, this.color);
  final Product product;
  final String size;
  final String color;
  int quantity = 1;
  int get totalCents => product.priceCents * quantity;
}

/// Starea comună a celor trei ecrane. Nu necesită internet sau backend.
class Store extends ChangeNotifier {
  final Set<String> _favorites = {};
  final List<CartItem> _cart = [];
  List<CartItem> get cart => List.unmodifiable(_cart);
  int get cartCount => _cart.fold(0, (total, item) => total + item.quantity);
  int get totalCents => _cart.fold(0, (total, item) => total + item.totalCents);
  bool isFavorite(Product product) => _favorites.contains(product.id);

  void toggleFavorite(Product product) {
    if (!_favorites.add(product.id)) _favorites.remove(product.id);
    notifyListeners();
  }

  void add(Product product, String size, String color) {
    if (!product.sizes.contains(size) || !product.colors.contains(color)) {
      throw ArgumentError('Alege o variantă disponibilă.');
    }
    final matches = _cart.where(
      (item) =>
          item.product.id == product.id &&
          item.size == size &&
          item.color == color,
    );
    if (matches.isEmpty) {
      _cart.add(CartItem(product, size, color));
    } else {
      matches.first.quantity++;
    }
    notifyListeners();
  }

  void changeQuantity(CartItem item, int delta) {
    if (!_cart.contains(item)) return;
    item.quantity += delta;
    if (item.quantity <= 0) _cart.remove(item);
    notifyListeners();
  }

  void remove(CartItem item) {
    _cart.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}
