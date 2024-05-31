import 'package:cloud_firestore/cloud_firestore.dart';

class Buy {
  String id;
  String productId;
  int quantity;
  double cost;
  DateTime date;

  Buy({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.cost,
    required this.date,
  });

  factory Buy.fromJson(Map<String, dynamic> json) {
    return Buy(
      id: json['id'] ?? '',
      productId: json['productId'] ?? 'Producto desconocido',
      quantity: json['quantity'] ?? 0,
      cost: json['cost'] != null ? (json['cost'] as num).toDouble() : 0.0,
      date: (json['date'] != null)
          ? (json['date'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'quantity': quantity,
      'cost': cost,
      'date': Timestamp.fromDate(date),
    };
  }

  // Firestore interaction methods
  static Future<void> addBuy(Buy buy) async {
    DocumentReference docRef =
        await FirebaseFirestore.instance.collection('buys').add(buy.toJson());
    await docRef.update({'id': docRef.id});
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
