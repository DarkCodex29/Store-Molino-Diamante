import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:store_molino_diamante/src/models/product.dart';
import 'package:store_molino_diamante/src/models/product.category.dart';
import 'package:store_molino_diamante/src/models/supplier.dart';

class ProductsController extends GetxController {
  var products = <Product>[].obs;
  var suppliers = <Supplier>[].obs;
  var categories = <ProductCategory>[].obs;
  var isLoading = false.obs;

  final nameController = TextEditingController();
  final barcodeController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  String selectedCategoryId = '';

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    fetchSuppliers();
    fetchCategories();
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

  void fetchProducts() async {
    isLoading(true);
    products.bindStream(Product.getProducts());
    isLoading(false);
  }

  void fetchSuppliers() async {
    isLoading(true);
    suppliers.bindStream(Supplier.getSuppliers());
    isLoading(false);
  }

  void fetchCategories() async {
    isLoading(true);
    categories.bindStream(ProductCategory.getProductCategories());
    isLoading(false);
  }

  String getSupplierName(String id) {
    final supplier = suppliers.firstWhere(
      (supplier) => supplier.id == id,
      orElse: () => Supplier(
        id: id,
        name: 'Proveedor desconocido',
        contact: '',
        email: '',
        address: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    return supplier.name;
  }

  String getCategoryName(String id) {
    final category = categories.firstWhere(
      (category) => category.id == id,
      orElse: () => ProductCategory(
        id: id,
        name: 'Categoría desconocida',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    return category.name;
  }

  void addProduct(Product product) async {
    // Check if product already exists
    final existingProduct =
        products.firstWhereOrNull((p) => p.barcode == product.barcode);
    if (existingProduct != null) {
      // Update stock
      existingProduct.stock += product.stock;
      await Product.updateProduct(existingProduct.id, existingProduct);
    } else {
      await Product.addProduct(product);
    }
  }

  void deleteProduct(String id) async {
    await Product.deleteProduct(id);
  }
}
