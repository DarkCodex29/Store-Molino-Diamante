class BuyDetail {
  String productId;
  int quantity;
  double unitCost;
  double totalCost;

  BuyDetail({
    required this.productId,
    required this.quantity,
    required this.unitCost,
    required this.totalCost,
  });

  factory BuyDetail.fromJson(Map<String, dynamic> json) {
    return BuyDetail(
      productId: json['productId'] ?? 'Producto desconocido',
      quantity: json['quantity'] ?? 0,
      unitCost:
          json['unitCost'] != null ? (json['unitCost'] as num).toDouble() : 0.0,
      totalCost: json['totalCost'] != null
          ? (json['totalCost'] as num).toDouble()
          : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'unitCost': unitCost,
      'totalCost': totalCost,
    };
  }
}
