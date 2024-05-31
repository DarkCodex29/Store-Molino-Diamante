import 'package:get/get.dart';
import 'package:store_molino_diamante/src/models/inventory.dart';

class InventoryController extends GetxController {
  var inventories = <Inventory>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInventories();
  }

  void fetchInventories() async {
    isLoading(true);
    inventories.bindStream(Inventory.getInventories());
    isLoading(false);
  }

  void addInventory(Inventory inventory) async {
    await Inventory.addInventory(inventory);
  }

  void updateInventory(String id, Inventory inventory) async {
    await Inventory.updateInventory(id, inventory);
  }

  void deleteInventory(String id) async {
    await Inventory.deleteInventory(id);
  }
}
