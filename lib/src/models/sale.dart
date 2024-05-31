import 'package:cloud_firestore/cloud_firestore.dart';

class Sale {
  String id;
  String productId;
  int quantity;
  double price;
  DateTime date;

  Sale({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.date,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'] ?? '',
      productId: json['productId'] ?? 'Producto desconocido',
      quantity: json['quantity'] ?? 0,
      price: json['price'] ?? 0.0,
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'quantity': quantity,
      'price': price,
      'date': date.toIso8601String(),
    };
  }

  // Firestore interaction methods
  static Future<void> addSale(Sale sale) async {
    await FirebaseFirestore.instance.collection('sales').add(sale.toJson());
  }

  static Future<void> updateSale(String id, Sale sale) async {
    await FirebaseFirestore.instance
        .collection('sales')
        .doc(id)
        .update(sale.toJson());
  }

  static Future<void> deleteSale(String id) async {
    await FirebaseFirestore.instance.collection('sales').doc(id).delete();
  }

  static Future<Sale?> getSaleById(String id) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('sales').doc(id).get();
    if (doc.exists) {
      return Sale.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  static Stream<List<Sale>> getSales() {
    return FirebaseFirestore.instance
        .collection('sales')
        .snapshots()
        .map((query) {
      return query.docs.map((doc) => Sale.fromJson(doc.data())).toList();
    });
  }
}
