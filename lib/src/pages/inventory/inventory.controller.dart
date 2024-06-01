import 'package:get/get.dart';
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

  @override
  void onInit() {
    super.onInit();
    fetchInventories();
    fetchProducts();
    fetchCategories();
    fetchSuppliers();
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
