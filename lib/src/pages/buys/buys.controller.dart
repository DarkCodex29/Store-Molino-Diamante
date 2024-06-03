import 'package:get/get.dart';
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

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBuys();
    fetchProducts();
    fetchSuppliers();
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
