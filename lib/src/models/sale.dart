import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_molino_diamante/src/models/detail.sale.dart';

class Sale {
  String id;
  DateTime date;
  DateTime createdAt;
  DateTime updatedAt;

  Sale({
    required this.id,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'] ?? '',
      date: (json['date'] != null)
          ? (json['date'] as Timestamp).toDate()
          : DateTime.now(),
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
      'date': Timestamp.fromDate(date),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Firestore interaction methods
  static Future<void> addSale(Sale sale) async {
    DocumentReference docRef =
        await FirebaseFirestore.instance.collection('sales').add(sale.toJson());
    await docRef.update({'id': docRef.id});
  }

  static Future<void> updateSale(String id, Sale sale) async {
    sale.updatedAt = DateTime.now();
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

  static Stream<List<SaleDetail>> getSaleDetailsBySaleId(String saleId) {
    return FirebaseFirestore.instance
        .collection('saleDetails')
        .where('saleId', isEqualTo: saleId)
        .snapshots()
        .map((query) {
      return query.docs.map((doc) => SaleDetail.fromJson(doc.data())).toList();
    });
  }
}
