import 'package:get/get.dart';
import 'package:store_molino_diamante/src/models/buy.dart';
import 'package:store_molino_diamante/src/models/product.category.dart';
import 'package:store_molino_diamante/src/models/product.dart';
import 'package:store_molino_diamante/src/models/supplier.dart';

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
    buys.bindStream(Buy.getBuys());
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
    for (var detail in buy.details) {
      var product = products.firstWhereOrNull((p) => p.id == detail.productId);
      if (product != null) {
        await Product.updateStockAndSupplierInfo(
          product.id,
          detail.quantity,
          SupplierInfo(
            supplierId: buy.supplierId,
            quantity: detail.quantity,
            purchasePrice: detail.unitCost,
          ),
        );
      }
    }
    await Buy.addBuy(buy);
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
    fetchProducts(); // Refresh the product list
  }

  void deleteBuy(String id) async {
    await Buy.deleteBuy(id);
  }
}
