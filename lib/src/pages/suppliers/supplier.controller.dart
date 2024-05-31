import 'package:get/get.dart';
import 'package:store_molino_diamante/src/models/supplier.dart';

class SuppliersController extends GetxController {
  var suppliers = <Supplier>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSuppliers();
  }

  void fetchSuppliers() async {
    isLoading(true);
    suppliers.bindStream(Supplier.getSuppliers());
    isLoading(false);
  }

  void addSupplier(Supplier supplier) async {
    await Supplier.addSupplier(supplier);
  }

  void updateSupplier(String id, Supplier supplier) async {
    await Supplier.updateSupplier(id, supplier);
  }

  void deleteSupplier(String id) async {
    await Supplier.deleteSupplier(id);
  }
}
