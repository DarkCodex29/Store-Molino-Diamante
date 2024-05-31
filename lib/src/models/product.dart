import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id;
  String name;
  String sku;
  String barcode;
  double price;
  int stock;
  String description;
  String category;
  String supplier;
  String imageURL;
  double discount;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    this.sku = '',
    required this.barcode,
    required this.price,
    required this.stock,
    this.description = '',
    this.category = '',
    this.supplier = '',
    this.imageURL = '',
    this.discount = 0.0,
    this.status = 'active',
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Producto desconocido',
      sku: json['sku'] ?? '',
      barcode: json['barcode'] ?? '',
      price: json['price'] != null ? (json['price'] as num).toDouble() : 0.0,
      stock: json['stock'] ?? 0,
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      supplier: json['supplier'] ?? '',
      imageURL: json['imageURL'] ?? '',
      discount:
          json['discount'] != null ? (json['discount'] as num).toDouble() : 0.0,
      status: json['status'] ?? 'active',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
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
      'description': description,
      'category': category,
      'supplier': supplier,
      'imageURL': imageURL,
      'discount': discount,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Firestore interaction methods
  static Future<void> addProduct(Product product) async {
    DocumentReference docRef = await FirebaseFirestore.instance
        .collection('products')
        .add(product.toJson());
    await docRef.update({'id': docRef.id});
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
