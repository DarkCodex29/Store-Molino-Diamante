import 'package:cloud_firestore/cloud_firestore.dart';

class Supplier {
  String id;
  String name;
  String contact;
  String email;
  String address;
  DateTime createdAt;
  DateTime updatedAt;

  Supplier({
    required this.id,
    required this.name,
    required this.contact,
    required this.email,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Nombre desconocido',
      contact: json['contact'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
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
      'name': name,
      'contact': contact,
      'email': email,
      'address': address,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Firestore interaction methods
  static Future<void> addSupplier(Supplier supplier) async {
    DocumentReference docRef = await FirebaseFirestore.instance
        .collection('suppliers')
        .add(supplier.toJson());
    await docRef.update({'id': docRef.id});
  }

  static Future<void> updateSupplier(String id, Supplier supplier) async {
    supplier.updatedAt = DateTime.now();
    await FirebaseFirestore.instance
        .collection('suppliers')
        .doc(id)
        .update(supplier.toJson());
  }

  static Future<void> deleteSupplier(String id) async {
    await FirebaseFirestore.instance.collection('suppliers').doc(id).delete();
  }

  static Future<Supplier?> getSupplierById(String id) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('suppliers').doc(id).get();
    if (doc.exists) {
      return Supplier.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  static Stream<List<Supplier>> getSuppliers() {
    return FirebaseFirestore.instance
        .collection('suppliers')
        .snapshots()
        .map((query) {
      return query.docs.map((doc) => Supplier.fromJson(doc.data())).toList();
    });
  }
}
