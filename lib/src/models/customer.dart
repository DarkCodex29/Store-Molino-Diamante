import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  String id;
  String name;
  String email;
  String phone;
  String address;
  DateTime createdAt;
  DateTime updatedAt;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Nombre desconocido',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
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
      'email': email,
      'phone': phone,
      'address': address,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Firestore interaction methods
  static Future<void> addCustomer(Customer customer) async {
    DocumentReference docRef = await FirebaseFirestore.instance
        .collection('customers')
        .add(customer.toJson());
    await docRef.update({'id': docRef.id});
  }

  static Future<void> updateCustomer(String id, Customer customer) async {
    customer.updatedAt = DateTime.now();
    await FirebaseFirestore.instance
        .collection('customers')
        .doc(id)
        .update(customer.toJson());
  }

  static Future<void> deleteCustomer(String id) async {
    await FirebaseFirestore.instance.collection('customers').doc(id).delete();
  }

  static Future<Customer?> getCustomerById(String id) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('customers').doc(id).get();
    if (doc.exists) {
      return Customer.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  static Stream<List<Customer>> getCustomers() {
    return FirebaseFirestore.instance
        .collection('customers')
        .snapshots()
        .map((query) {
      return query.docs.map((doc) => Customer.fromJson(doc.data())).toList();
    });
  }
}
