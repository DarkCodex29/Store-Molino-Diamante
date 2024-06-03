import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_molino_diamante/src/models/sale.dart';
import 'package:store_molino_diamante/src/models/product.dart';

class SalesController extends GetxController {
  var sales = <Sale>[].obs;
  var products = <Product>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSales();
    fetchProducts();
  }

  void fetchSales() async {
    isLoading(true);
    sales.bindStream(Sale.getSales().map((query) {
      var salesList = query.toList();
      salesList.sort((a, b) => a.date.compareTo(b.date));
      return salesList;
    }));
    isLoading(false);
  }

  void fetchProducts() async {
    isLoading(true);
    products.bindStream(Product.getProducts());
    isLoading(false);
  }

  void addSale(Sale sale) async {
    for (var detail in sale.details) {
      var product = products.firstWhereOrNull((p) => p.id == detail.productId);
      if (product != null) {
        if (product.stock < detail.quantity) {
          Get.snackbar(
            'Venta no procesada',
            'Tiene ${product.stock} en stock. Comuníquese con el administrador.',
            colorText: Colors.white,
            backgroundColor: Colors.red,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
          return;
        }
      }
    }

    await Sale.addSale(sale);
    for (var detail in sale.details) {
      var product = products.firstWhereOrNull((p) => p.id == detail.productId);
      if (product != null) {
        product.stock -= detail.quantity;
        await Product.updateProduct(product.id, product);
      }
    }

    fetchSales();
    fetchProducts();
  }

  void updateSale(String id, Sale sale) async {
    await Sale.updateSale(id, sale);
  }

  void deleteSale(String id) async {
    await Sale.deleteSale(id);
  }

  Product getProductById(String id) {
    return products.firstWhere(
      (product) => product.id == id,
      orElse: () => Product(
        id: '',
        name: 'Producto desconocido',
        barcode: '',
        price: 0.0,
        stock: 0,
        category: '',
        suppliersInfo: [],
      ),
    );
  }

  String getSaleNumber(String saleId) {
    int index = sales.indexWhere((sale) => sale.id == saleId);
    return (index + 1).toString();
  }
}
