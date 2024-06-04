import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:store_molino_diamante/src/models/inventory.dart';
import 'package:store_molino_diamante/src/models/product.category.dart';
import 'package:store_molino_diamante/src/models/product.dart';
import 'package:store_molino_diamante/src/models/supplier.dart';

class InventoryController extends GetxController {
  var inventories = <Inventory>[].obs;
  var products = <Product>[].obs;
  var categories = <ProductCategory>[].obs;
  var suppliers = <Supplier>[].obs;
  var isLoading = false.obs;

  final nameController = TextEditingController();
  final barcodeController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  String selectedCategoryId = '';

  @override
  void onInit() {
    super.onInit();
    fetchInventories();
    fetchProducts();
    fetchCategories();
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

  void fetchInventories() async {
    isLoading(true);
    inventories.bindStream(Inventory.getInventories());
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

  void addInventory(Inventory inventory) async {
    await Inventory.addInventory(inventory);
  }

  void addProduct(Product product) async {
    final existingProduct =
        products.firstWhereOrNull((p) => p.barcode == product.barcode);
    if (existingProduct != null) {
      Get.snackbar('Producto existente', 'Se ha actualizado el stock.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(milliseconds: 1500));
      existingProduct.stock += product.stock;
      await Product.updateProduct(existingProduct.id, existingProduct);
    } else {
      await Product.addProduct(product);
    }
    fetchProducts();
  }

  void updateInventory(String id, Inventory inventory) async {
    await Inventory.updateInventory(id, inventory);
  }

  void deleteInventory(String id) async {
    await Inventory.deleteInventory(id);
  }

  void deleteProduct(String id) async {
    await Product.deleteProduct(id);
  }

  String getSupplierName(String supplierId) {
    final supplier = suppliers.firstWhere(
      (supplier) => supplier.id == supplierId,
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
    return supplier.name;
  }
}
