import 'package:cloud_firestore/cloud_firestore.dart';

class ProductCategory {
  String id;
  String name;
  DateTime createdAt;
  DateTime updatedAt;

  ProductCategory({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Categoría desconocida',
      createdAt: (json['createdAt'] != null)
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: (json['updatedAt'] != null)
          ? (json['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Firestore interaction methods
  static Future<void> addProductCategory(ProductCategory category) async {
    DocumentReference docRef = await FirebaseFirestore.instance
        .collection('productCategories')
        .add(category.toJson());
    await docRef.update({'id': docRef.id});
  }

  static Future<void> updateProductCategory(
      String id, ProductCategory category) async {
    category.updatedAt = DateTime.now();
    await FirebaseFirestore.instance
        .collection('productCategories')
        .doc(id)
        .update(category.toJson());
  }

  static Future<void> deleteProductCategory(String id) async {
    await FirebaseFirestore.instance
        .collection('productCategories')
        .doc(id)
        .delete();
  }

  static Future<ProductCategory?> getProductCategoryById(String id) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('productCategories')
        .doc(id)
        .get();
    if (doc.exists) {
      return ProductCategory.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  static Stream<List<ProductCategory>> getProductCategories() {
    return FirebaseFirestore.instance
        .collection('productCategories')
        .snapshots()
        .map((query) {
      return query.docs
          .map((doc) => ProductCategory.fromJson(doc.data()))
          .toList();
    });
  }
}
