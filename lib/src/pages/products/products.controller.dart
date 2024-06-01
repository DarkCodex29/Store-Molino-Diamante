import 'package:get/get.dart';
import 'package:store_molino_diamante/src/models/product.dart';
import 'package:store_molino_diamante/src/models/product.category.dart';
import 'package:store_molino_diamante/src/models/supplier.dart';

class ProductsController extends GetxController {
  var products = <Product>[].obs;
  var suppliers = <Supplier>[].obs;
  var categories = <ProductCategory>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    fetchSuppliers();
    fetchCategories();
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
