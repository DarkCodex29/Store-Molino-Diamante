import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:store_molino_diamante/src/models/buy.dart';
import 'package:store_molino_diamante/src/models/product.category.dart';
import 'package:store_molino_diamante/src/models/product.dart';
import 'package:store_molino_diamante/src/models/supplier.dart';
import 'dart:developer'; // Importar paquete de logging

class BuysController extends GetxController {
  var buys = <Buy>[].obs;
  var products = <Product>[].obs;
  var suppliers = <Supplier>[].obs;
  var categories = <ProductCategory>[].obs;

  final nameController = TextEditingController();
  final barcodeController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  String selectedCategoryId = '';
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBuys();
    fetchProducts();
    fetchSuppliers();
  }

  Future scanMobile(BuildContext context) async {
    final scanResult = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SimpleBarcodeScannerPage(
          lineColor: "#ff6666",
          cancelButtonText: "Cancelar",
          isShowFlashIcon: true,
        ),
      ),
    );

    if (scanResult == null || scanResult == '-1') {
      Get.snackbar(
        'Advertencia',
        'El escaneo fue cancelado.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(milliseconds: 1500),
      );
      return;
    }

    Product? existingProduct = await getProductByBarcode(scanResult);
    if (existingProduct != null) {
      Get.snackbar(
        'Advertencia',
        'El código de barras $scanResult ya está asignado al producto ${existingProduct.name}.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(milliseconds: 1500),
      );
      return;
    }
    barcodeController.text = scanResult;
  }

  Future<Product?> getProductByBarcode(String barcode) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('barcode', isEqualTo: barcode)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return Product.fromJson(querySnapshot.docs.first.data());
    }
    return null;
  }

  void clearFields() {
    nameController.clear();
    barcodeController.clear();
    priceController.clear();
    stockController.clear();
    selectedCategoryId = '';
  }

  void fetchBuys() async {
    isLoading(true);
    buys.bindStream(Buy.getBuys().map((query) {
      var buysList = query.toList();
      buysList.sort((a, b) => a.date.compareTo(b.date));
      return buysList;
    }));
    isLoading(false);
  }

  void fetchProducts() async {
    isLoading(true);
    products.bindStream(Product.getProducts());
    isLoading(false);
  }

  void fetchCategories() async {
    isLoading(true);
    categories.bindStream(ProductCategory.getProductCategories());
    isLoading(false);
  }

  void fetchSuppliers() async {
    isLoading(true);
    suppliers.bindStream(Supplier.getSuppliers());
    isLoading(false);
  }

  Supplier getSupplierById(String id) {
    return suppliers.firstWhere(
      (supplier) => supplier.id == id,
      orElse: () => Supplier(
        id: '',
        name: 'Proveedor desconocido',
        contact: '',
        email: '',
        address: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
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
        suppliersInfo: [],
      ),
    );
  }

  void addBuy(Buy buy) async {
    log('Adding buy: ${buy.id}');
    await Buy.addBuy(buy); // Aquí agregamos la compra primero

    // Actualizamos el stock y la información del proveedor para cada detalle de compra una sola vez
    for (var detail in buy.details) {
      log('Updating product ${detail.productId} with quantity ${detail.quantity}');
      await Product.updateStockAndSupplierInfo(
        detail.productId,
        detail.quantity,
        SupplierInfo(
          supplierId: buy.supplierId,
          quantity: detail.quantity,
          purchasePrice: detail.unitCost,
        ),
      );
    }

    fetchBuys();
  }

  void addProduct(Product product) async {
    final existingProduct =
        products.firstWhereOrNull((p) => p.barcode == product.barcode);
    if (existingProduct != null) {
      existingProduct.stock += product.stock;
      await Product.updateProduct(existingProduct.id, existingProduct);
    } else {
      await Product.addProduct(product);
    }
    fetchProducts();
  }

  void deleteBuy(String id) async {
    var buy = await Buy.getBuyById(id);
    if (buy != null) {
      for (var detail in buy.details) {
        var product =
            products.firstWhereOrNull((p) => p.id == detail.productId);
        if (product != null) {
          log('Reversing stock for product ${product.id} with quantity ${-detail.quantity}');
          await Product.updateStockAndSupplierInfo(
            product.id,
            -detail.quantity,
            SupplierInfo(
              supplierId: buy.supplierId,
              quantity: -detail.quantity,
              purchasePrice: detail.unitCost,
            ),
          );
        }
      }
    }
    await Buy.deleteBuy(id);
    fetchBuys();
  }
}
