import 'package:cloud_firestore/cloud_firestore.dart';

class Inventory {
  String id;
  String productId;
  int quantity;
  DateTime createdAt;
  DateTime updatedAt;

  Inventory({
    required this.id,
    required this.productId,
    required this.quantity,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
      id: json['id'] ?? '',
      productId: json['productId'] ?? '',
      quantity: json['quantity'] ?? 0,
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
      'productId': productId,
      'quantity': quantity,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  static Future<void> addInventory(Inventory inventory) async {
    DocumentReference docRef = await FirebaseFirestore.instance
        .collection('inventories')
        .add(inventory.toJson());
    await docRef.update({'id': docRef.id});
  }

  static Future<void> updateInventory(String id, Inventory inventory) async {
    inventory.updatedAt = DateTime.now();
    await FirebaseFirestore.instance
        .collection('inventories')
        .doc(id)
        .update(inventory.toJson());
  }

  static Future<void> deleteInventory(String id) async {
    await FirebaseFirestore.instance.collection('inventories').doc(id).delete();
  }

  static Future<Inventory?> getInventoryById(String id) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('inventories')
        .doc(id)
        .get();
    if (doc.exists) {
      return Inventory.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  static Stream<List<Inventory>> getInventories() {
    return FirebaseFirestore.instance
        .collection('inventories')
        .snapshots()
        .map((query) {
      return query.docs.map((doc) => Inventory.fromJson(doc.data())).toList();
    });
  }
}
