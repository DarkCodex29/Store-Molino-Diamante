import 'package:cloud_firestore/cloud_firestore.dart';

class BuyDetail {
  String id;
  String buyId;
  String productId;
  int quantity;
  double unitCost;
  double totalCost;
  DateTime createdAt;
  DateTime updatedAt;

  BuyDetail({
    required this.id,
    required this.buyId,
    required this.productId,
    required this.quantity,
    required this.unitCost,
    required this.totalCost,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory BuyDetail.fromJson(Map<String, dynamic> json) {
    return BuyDetail(
      id: json['id'] ?? '',
      buyId: json['buyId'] ?? '',
      productId: json['productId'] ?? 'Producto desconocido',
      quantity: json['quantity'] ?? 0,
      unitCost: json['unitCost'] != null ? (json['unitCost'] as num).toDouble() : 0.0,
      totalCost: json['totalCost'] != null ? (json['totalCost'] as num).toDouble() : 0.0,
      createdAt: (json['createdAt'] != null) ? (json['createdAt'] as Timestamp).toDate() : DateTime.now(),
      updatedAt: (json['updatedAt'] != null) ? (json['updatedAt'] as Timestamp).toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyId': buyId,
      'productId': productId,
      'quantity': quantity,
      'unitCost': unitCost,
      'totalCost': totalCost,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Future<void> addBuyDetail() async {
    DocumentReference docRef = await FirebaseFirestore.instance.collection('buyDetails').add(toJson());
    await docRef.update({'id': docRef.id});
  }
}
