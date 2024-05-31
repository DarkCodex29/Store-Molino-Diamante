import 'package:get/get.dart';
import 'package:store_molino_diamante/src/models/sale.dart';

class SalesController extends GetxController {
  var sales = <Sale>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSales();
  }

  void fetchSales() async {
    isLoading(true);
    sales.bindStream(Sale.getSales());
    isLoading(false);
  }

  void addSale(Sale sale) async {
    await Sale.addSale(sale);
  }

  void updateSale(String id, Sale sale) async {
    await Sale.updateSale(id, sale);
  }

  void deleteSale(String id) async {
    await Sale.deleteSale(id);
  }
}
