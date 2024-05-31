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

  void addBuy(Buy buy) async {
    await Buy.addBuy(buy);
  }

  void updateBuy(String id, Buy buy) async {
    await Buy.updateBuy(id, buy);
  }

  void deleteBuy(String id) async {
    await Buy.deleteBuy(id);
  }
}
