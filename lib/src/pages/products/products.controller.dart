import 'package:get/get.dart';
import 'package:store_molino_diamante/src/models/product.dart';
import 'package:store_molino_diamante/src/models/supplier.dart';

class ProductsController extends GetxController {
  var products = <Product>[].obs;
  var suppliers = <Supplier>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    fetchSuppliers();
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
          updatedAt: DateTime.now()),
    );
    return supplier.name;
  }

  void addProduct(Product product) async {
    // Check if product already exists
    final existingProduct =
        products.firstWhereOrNull((p) => p.barcode == product.barcode);
    if (existingProduct != null) {
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
