import 'package:get/get.dart';
import 'package:store_molino_diamante/src/models/buy.dart';

class BuysController extends GetxController {
  var buys = <Buy>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBuys();
  }

  void fetchBuys() async {
    isLoading(true);
    buys.bindStream(Buy.getBuys());
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
