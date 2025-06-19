import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/cart_service.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  
  // Sample product data with categories and sizes
  final List<Product> _allProducts = [
    Product(
      id: 'p1',
      title: 'Red T-Shirt',
      description: 'A comfortable red t-shirt made of 100% cotton.',
      price: 39.99,
      imageUrl: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
      category: 'Clothing',
      availableSizes: ['S', 'M', 'L', 'XL'],
    ),
    Product(
      id: 'p2',
      title: 'Blue Jeans',
      description: 'Classic blue jeans that go with everything.',
      price: 89.99,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
      category: 'Clothing',
      availableSizes: ['S', 'M', 'L', 'XL'],
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 29.99,
      imageUrl: 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
      category: 'Accessories',
    ),
    Product(
      id: 'p4',
      title: 'Cooking Pan',
      description: 'Premium non-stick cooking pan for all your culinary needs.',
      price: 79.99,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
      category: 'Kitchen',
    ),
    Product(
      id: 'p5',
      title: 'Black Hoodie',
      description: 'Stylish black hoodie for casual wear.',
      price: 59.99,
      imageUrl: 'https://cdn.pixabay.com/photo/2017/08/17/08/20/online-shopping-2650383_1280.jpg',
      category: 'Clothing',
      availableSizes: ['S', 'M', 'L', 'XL'],
    ),
    Product(
      id: 'p6',
      title: 'Coffee Mug',
      description: 'Ceramic coffee mug with elegant design.',
      price: 19.99,
      imageUrl: 'https://cdn.pixabay.com/photo/2016/01/02/04/59/coffee-1117933_1280.jpg',
      category: 'Kitchen',
    ),
  ];
  
  // Get all available categories from products
  List<String> get _categories {
    final Set<String> categories = _allProducts.map((p) => p.category).toSet();
    return ['All', ...categories];
  }
  
  // Filtered products based on search query and selected category
  List<Product> get _filteredProducts {
    return _allProducts.where((product) {
      final matchesSearch = product.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                           product.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || product.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartService>(context);
    final authService = Provider.of<AuthService>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => CartScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              authService.logout();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Products',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 8),
              children: _categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: _filteredProducts.isEmpty
              ? Center(child: Text('No products found!'))
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: (_filteredProducts.length / 2).ceil(), // Number of rows
                  itemBuilder: (ctx, rowIndex) {
                    // Calculate the start index for this row
                    final startIndex = rowIndex * 2;
                    // Check if there's a second item in this row
                    final hasSecondItem = startIndex + 1 < _filteredProducts.length;
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // First item in row
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: 1.0, // Square aspect ratio
                              child: ProductCard(
                                product: _filteredProducts[startIndex],
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) => ProductDetailScreen(
                                        product: _filteredProducts[startIndex],
                                      ),
                                    ),
                                  );
                                },
                                onAddToCart: () {
                                  if (_filteredProducts[startIndex].isClothing) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (ctx) => ProductDetailScreen(
                                          product: _filteredProducts[startIndex],
                                        ),
                                      ),
                                    );
                                  } else {
                                    cart.addItem(_filteredProducts[startIndex]);
                                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Added item to cart!'),
                                        duration: Duration(seconds: 2),
                                        action: SnackBarAction(
                                          label: 'UNDO',
                                          onPressed: () {
                                            cart.removeSingleItem(_filteredProducts[startIndex].id);
                                          },
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 8), // Gap between items
                          // Second item in row (if exists)
                          hasSecondItem
                            ? Expanded(
                                child: AspectRatio(
                                  aspectRatio: 1.0, // Square aspect ratio
                                  child: ProductCard(
                                    product: _filteredProducts[startIndex + 1],
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) => ProductDetailScreen(
                                            product: _filteredProducts[startIndex + 1],
                                          ),
                                        ),
                                      );
                                    },
                                    onAddToCart: () {
                                      if (_filteredProducts[startIndex + 1].isClothing) {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (ctx) => ProductDetailScreen(
                                              product: _filteredProducts[startIndex + 1],
                                            ),
                                          ),
                                        );
                                      } else {
                                        cart.addItem(_filteredProducts[startIndex + 1]);
                                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Added item to cart!'),
                                            duration: Duration(seconds: 2),
                                            action: SnackBarAction(
                                              label: 'UNDO',
                                              onPressed: () {
                                                cart.removeSingleItem(_filteredProducts[startIndex + 1].id);
                                              },
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              )
                            : Expanded(child: Container()), // Empty container for alignment
                        ],
                      ),
                    );
                  },
                ),
          )
        ],
      ),
    );
  }
}