import 'package:get/get.dart';

import 'package:store_molino_diamante/src/models/product.dart';

class ProductsController extends GetxController {
  var products = <Product>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void fetchProducts() async {
    isLoading(true);
    products.bindStream(Product.getProducts());
    isLoading(false);
  }

  void addProduct(Product product) async {
    await Product.addProduct(product);
  }

  void updateProduct(String id, Product product) async {
    await Product.updateProduct(id, product);
  }

  void deleteProduct(String id) async {
    await Product.deleteProduct(id);
  }
}
