import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_model.dart';

class ProductService {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('products');

  /// Real-time stream of all products
  Stream<List<Product>> getProductsStream() {
    return _collection
        .orderBy('name')
        .snapshots()
        .map((snap) => snap.docs.map((d) => Product.fromFirestore(d)).toList());
  }

  /// Add a new product
  Future<void> addProduct(Product product) async {
    await _collection.add(product.toMap());
  }

  /// Update an existing product
  Future<void> updateProduct(Product product) async {
    await _collection.doc(product.id).update(product.toMap());
  }

  /// Delete a product by ID
  Future<void> deleteProduct(String productId) async {
    await _collection.doc(productId).delete();
  }
}
