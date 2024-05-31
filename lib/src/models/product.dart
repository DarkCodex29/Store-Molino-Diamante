import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id;
  String name;
  String sku;
  String barcode;
  double price;
  int stock;

  Product({
    required this.id,
    required this.name,
    required this.sku,
    required this.barcode,
    required this.price,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Producto desconocido',
      sku: json['sku'] ?? '',
      barcode: json['barcode'] ?? '',
      price: json['price'] ?? 0.0,
      stock: json['stock'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sku': sku,
      'barcode': barcode,
      'price': price,
      'stock': stock,
    };
  }

  // Firestore interaction methods
  static Future<void> addProduct(Product product) async {
    await FirebaseFirestore.instance
        .collection('products')
        .add(product.toJson());
  }

  static Future<void> updateProduct(String id, Product product) async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(id)
        .update(product.toJson());
  }

  static Future<void> deleteProduct(String id) async {
    await FirebaseFirestore.instance.collection('products').doc(id).delete();
  }

  static Future<Product?> getProductById(String id) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('products').doc(id).get();
    if (doc.exists) {
      return Product.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  static Stream<List<Product>> getProducts() {
    return FirebaseFirestore.instance
        .collection('products')
        .snapshots()
        .map((query) {
      return query.docs.map((doc) => Product.fromJson(doc.data())).toList();
    });
  }
}
