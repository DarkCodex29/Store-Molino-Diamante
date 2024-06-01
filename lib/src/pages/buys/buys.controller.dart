import 'package:get/get.dart';
import 'package:store_molino_diamante/src/models/buy.dart';
import 'package:store_molino_diamante/src/models/product.dart';
import 'package:store_molino_diamante/src/models/supplier.dart';

class BuysController extends GetxController {
  var buys = <Buy>[].obs;
  var products = <Product>[].obs;
  var suppliers = <Supplier>[].obs;
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
        updatedAt: DateTime.now(),
      ),
    );
    return supplier.name;
  }

  void addBuy(Buy buy) async {
    // Add each product in the buy details
    for (var detail in buy.details) {
      // Find the product in the list of products
      var product = products.firstWhereOrNull((p) => p.id == detail.productId);
      if (product != null) {
        // Update stock and supplier info
        await Product.updateStockAndSupplierInfo(
          product.id,
          detail.quantity,
          SupplierInfo(
            supplierId: buy.supplierId,
            quantity: detail.quantity,
            purchasePrice: detail.unitCost,
          ),
        );
      } else {
        // Handle case where the product is not found, if necessary
      }
    }
    await Buy.addBuy(buy);
  }

  void deleteBuy(String id) async {
    await Buy.deleteBuy(id);
  }
}
