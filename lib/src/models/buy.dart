import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_molino_diamante/src/models/product.dart';
import 'detail.buy.dart';

class Buy {
  String id;
  String supplierId;
  double totalCost;
  DateTime date;
  List<BuyDetail> details;

  Buy({
    required this.id,
    required this.supplierId,
    required this.totalCost,
    required this.date,
    required this.details,
  });

  factory Buy.fromJson(Map<String, dynamic> json) {
    return Buy(
      id: json['id'] ?? '',
      supplierId: json['supplierId'] ?? '',
      totalCost: json['totalCost'] != null
          ? (json['totalCost'] as num).toDouble()
          : 0.0,
      date: (json['date'] != null)
          ? (json['date'] as Timestamp).toDate()
          : DateTime.now(),
      details: (json['details'] as List<dynamic>)
          .map((detail) => BuyDetail.fromJson(detail as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'supplierId': supplierId,
      'totalCost': totalCost,
      'date': Timestamp.fromDate(date),
      'details': details.map((detail) => detail.toJson()).toList(),
    };
  }

  // Firestore interaction methods
  static Future<void> addBuy(Buy buy) async {
    DocumentReference docRef =
        await FirebaseFirestore.instance.collection('buys').add(buy.toJson());
    await docRef.update({'id': docRef.id});
    for (var detail in buy.details) {
      await detail.addBuyDetail();
    }
    for (var detail in buy.details) {
      Product.updateStock(detail.productId, detail.quantity);
    }
  }

  static Future<void> updateBuy(String id, Buy buy) async {
    await FirebaseFirestore.instance
        .collection('buys')
        .doc(id)
        .update(buy.toJson());
  }

  static Future<void> deleteBuy(String id) async {
    await FirebaseFirestore.instance.collection('buys').doc(id).delete();
  }

  static Future<Buy?> getBuyById(String id) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('buys').doc(id).get();
    if (doc.exists) {
      return Buy.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  static Stream<List<Buy>> getBuys() {
    return FirebaseFirestore.instance
        .collection('buys')
        .snapshots()
        .map((query) {
      return query.docs.map((doc) => Buy.fromJson(doc.data())).toList();
    });
  }
}
