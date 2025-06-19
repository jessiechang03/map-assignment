class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final List<String>? availableSizes; // Only for clothing items

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.availableSizes,
  });

  bool get isClothing => category == 'Clothing';
}