import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartService with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(Product product, {String? size}) {
    // For clothing items with size, create a unique key with product ID and size
    final String itemKey = product.isClothing && size != null 
        ? "\${product.id}_\${size}" 
        : product.id;
    
    if (_items.containsKey(itemKey)) {
      // Change quantity
      _items.update(
        itemKey,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          productId: existingCartItem.productId,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity + 1,
          price: existingCartItem.price,
          imageUrl: existingCartItem.imageUrl,
          size: existingCartItem.size,
        ),
      );
    } else {
      _items.putIfAbsent(
        itemKey,
        () => CartItem(
          id: DateTime.now().toString(),
          productId: product.id,
          title: product.title,
          quantity: 1,
          price: product.price,
          imageUrl: product.imageUrl,
          size: size,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String itemKey) {
    _items.remove(itemKey);
    notifyListeners();
  }

  void removeSingleItem(String itemKey) {
    if (!_items.containsKey(itemKey)) {
      return;
    }
    if (_items[itemKey]!.quantity > 1) {
      _items.update(
        itemKey,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          productId: existingCartItem.productId,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity - 1,
          price: existingCartItem.price,
          imageUrl: existingCartItem.imageUrl,
          size: existingCartItem.size,
        ),
      );
    } else {
      _items.remove(itemKey);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}