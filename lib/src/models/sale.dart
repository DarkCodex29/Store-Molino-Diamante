import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_molino_diamante/src/models/detail.sale.dart';

class Sale {
  String id;
  DateTime date;
  DateTime createdAt;
  DateTime updatedAt;
  List<SaleDetail> details;

  Sale({
    required this.id,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    required this.details,
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
      details: (json['details'] as List<dynamic>?)
              ?.map((detail) =>
                  SaleDetail.fromJson(detail as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': Timestamp.fromDate(date),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'details': details.map((detail) => detail.toJson()).toList(),
    };
  }

  // Firestore interaction methods
  static Future<void> addSale(Sale sale) async {
    DocumentReference docRef =
        await FirebaseFirestore.instance.collection('sales').add(sale.toJson());
    await docRef.update({'id': docRef.id});
    for (var detail in sale.details) {
      await SaleDetail.addSaleDetail(detail..saleId = docRef.id);
    }
  }

  static Future<void> updateSale(String id, Sale sale) async {
    sale.updatedAt = DateTime.now();
    await FirebaseFirestore.instance
        .collection('sales')
        .doc(id)
        .update(sale.toJson());
    for (var detail in sale.details) {
      await SaleDetail.updateSaleDetail(detail.id, detail);
    }
  }

  static Future<void> deleteSale(String id) async {
    // First delete all sale details
    var saleDetails = await getSaleDetailsBySaleId(id).first;
    for (var detail in saleDetails) {
      await SaleDetail.deleteSaleDetail(detail.id);
    }
    // Then delete the sale
    await FirebaseFirestore.instance.collection('sales').doc(id).delete();
  }

  static Future<Sale?> getSaleById(String id) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('sales').doc(id).get();
    if (doc.exists) {
      var sale = Sale.fromJson(doc.data() as Map<String, dynamic>);
      sale.details = await getSaleDetailsBySaleId(id).first;
      return sale;
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
