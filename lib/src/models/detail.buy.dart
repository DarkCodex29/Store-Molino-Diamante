import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer'; // Importar paquete de logging

class BuyDetail {
  String id;
  String buyId; // Mantener buyId para referenciar la compra
  String productId;
  int quantity;
  double totalCost;
  double unitCost;
  DateTime createdAt;
  DateTime updatedAt;

  BuyDetail({
    required this.id,
    required this.buyId,
    required this.productId,
    required this.quantity,
    required this.totalCost,
    required this.unitCost,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BuyDetail.fromJson(Map<String, dynamic> json) {
    return BuyDetail(
      id: json['id'] ?? '',
      buyId: json['buyId'] ?? '',
      productId: json['productId'] ?? '',
      quantity: json['quantity'] ?? 0,
      totalCost: json['totalCost'] != null
          ? (json['totalCost'] as num).toDouble()
          : 0.0,
      unitCost:
          json['unitCost'] != null ? (json['unitCost'] as num).toDouble() : 0.0,
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
      'totalCost': totalCost,
      'unitCost': unitCost,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Future<void> addBuyDetail() async {
    DocumentReference docRef =
        await FirebaseFirestore.instance.collection('buyDetails').add(toJson());
    String detailId = docRef.id;
    await docRef.update({'id': detailId});
    log('Buy detail added with id: $detailId and buyId: $buyId');
  }
}
