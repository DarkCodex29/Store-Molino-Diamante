import 'package:cloud_firestore/cloud_firestore.dart';

class SaleDetail {
  String id;
  String saleId;
  String productId;
  int quantity;
  double price;
  DateTime createdAt;
  DateTime updatedAt;

  SaleDetail({
    required this.id,
    required this.saleId,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SaleDetail.fromJson(Map<String, dynamic> json) {
    return SaleDetail(
      id: json['id'] ?? '',
      saleId: json['saleId'] ?? '',
      productId: json['productId'] ?? 'Producto desconocido',
      quantity: json['quantity'] ?? 0,
      price: json['price'] != null ? (json['price'] as num).toDouble() : 0.0,
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
      'saleId': saleId,
      'productId': productId,
      'quantity': quantity,
      'price': price,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Firestore interaction methods
  static Future<void> addSaleDetail(SaleDetail saleDetail) async {
    DocumentReference docRef = await FirebaseFirestore.instance
        .collection('saleDetails')
        .add(saleDetail.toJson());
    await docRef.update({'id': docRef.id});
  }

  static Future<void> updateSaleDetail(String id, SaleDetail saleDetail) async {
    saleDetail.updatedAt = DateTime.now();
    await FirebaseFirestore.instance
        .collection('saleDetails')
        .doc(id)
        .update(saleDetail.toJson());
  }

  static Future<void> deleteSaleDetail(String id) async {
    await FirebaseFirestore.instance.collection('saleDetails').doc(id).delete();
  }

  static Future<SaleDetail?> getSaleDetailById(String id) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('saleDetails')
        .doc(id)
        .get();
    if (doc.exists) {
      return SaleDetail.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  static Stream<List<SaleDetail>> getSaleDetails() {
    return FirebaseFirestore.instance
        .collection('saleDetails')
        .snapshots()
        .map((query) {
      return query.docs.map((doc) => SaleDetail.fromJson(doc.data())).toList();
    });
  }
}
