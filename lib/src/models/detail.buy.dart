import 'package:cloud_firestore/cloud_firestore.dart';

class BuyDetail {
  String id;
  String buyId;
  String productId;
  int quantity;
  double cost;
  DateTime createdAt;
  DateTime updatedAt;

  BuyDetail({
    required this.id,
    required this.buyId,
    required this.productId,
    required this.quantity,
    required this.cost,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BuyDetail.fromJson(Map<String, dynamic> json) {
    return BuyDetail(
      id: json['id'] ?? '',
      buyId: json['buyId'] ?? '',
      productId: json['productId'] ?? 'Producto desconocido',
      quantity: json['quantity'] ?? 0,
      cost: json['cost'] != null ? (json['cost'] as num).toDouble() : 0.0,
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
      'buyId': buyId,
      'productId': productId,
      'quantity': quantity,
      'cost': cost,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Firestore interaction methods
  static Future<void> addBuyDetail(BuyDetail buyDetail) async {
    DocumentReference docRef = await FirebaseFirestore.instance
        .collection('buyDetails')
        .add(buyDetail.toJson());
    await docRef.update({'id': docRef.id});
  }

  static Future<void> updateBuyDetail(String id, BuyDetail buyDetail) async {
    buyDetail.updatedAt = DateTime.now();
    await FirebaseFirestore.instance
        .collection('buyDetails')
        .doc(id)
        .update(buyDetail.toJson());
  }

  static Future<void> deleteBuyDetail(String id) async {
    await FirebaseFirestore.instance.collection('buyDetails').doc(id).delete();
  }

  static Future<BuyDetail?> getBuyDetailById(String id) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('buyDetails').doc(id).get();
    if (doc.exists) {
      return BuyDetail.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  static Stream<List<BuyDetail>> getBuyDetails() {
    return FirebaseFirestore.instance
        .collection('buyDetails')
        .snapshots()
        .map((query) {
      return query.docs.map((doc) => BuyDetail.fromJson(doc.data())).toList();
    });
  }
}
