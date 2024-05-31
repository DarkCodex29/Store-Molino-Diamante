import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_molino_diamante/src/models/detail.buy.dart';
import 'package:store_molino_diamante/src/models/product.dart';
import 'package:store_molino_diamante/src/models/supplier.dart';
import 'buys.controller.dart';
import 'package:store_molino_diamante/src/models/buy.dart';

class BuysPage extends StatelessWidget {
  const BuysPage({super.key});

  @override
  Widget build(BuildContext context) {
    final BuysController controller = Get.put(BuysController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.buys.isEmpty) {
          return const Center(child: Text('No hay compras disponibles'));
        }
        return ListView.builder(
          itemCount: controller.buys.length,
          itemBuilder: (context, index) {
            final buy = controller.buys[index];
            final supplier = controller.suppliers.firstWhere(
              (supplier) => supplier.id == buy.supplierId,
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
            return ExpansionTile(
              title: Text('Proveedor: ${supplier.name}'),
              subtitle: Text('Costo Total: S/. ${buy.totalCost}'),
              children: buy.details.map((detail) {
                final product = controller.products.firstWhere(
                  (product) => product.id == detail.productId,
                  orElse: () => Product(
                    id: '',
                    name: 'Producto desconocido',
                    barcode: '',
                    price: 0.0,
                    stock: 0,
                  ),
                );
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text(
                      'Cantidad: ${detail.quantity}, Costo: S/. ${detail.totalCost}'),
                );
              }).toList(),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddBuyDialog(context, controller);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddBuyDialog(BuildContext context, BuysController controller) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    String selectedSupplierId =
        controller.suppliers.isNotEmpty ? controller.suppliers.first.id : '';
    List<BuyDetail> details = [];
    double totalCost = 0.0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            void addDetail() {
              details.add(BuyDetail(
                productId: controller.products.first.id,
                quantity: 1,
                unitCost: controller.products.first.price,
                totalCost: controller.products.first.price,
              ));
              setState(() {});
            }

            void removeDetail(int index) {
              details.removeAt(index);
              setState(() {});
            }

            void updateDetail(int index, BuyDetail detail) {
              details[index] = detail;
              setState(() {});
            }

            return AlertDialog(
              title: const Text('Agregar Compra'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Proveedor'),
                      value: selectedSupplierId,
                      onChanged: (value) {
                        selectedSupplierId = value!;
                      },
                      items: controller.suppliers.map((Supplier supplier) {
                        return DropdownMenuItem<String>(
                          value: supplier.id,
                          child: Text(supplier.name),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: addDetail,
                      child: const Text('Agregar Producto'),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: details.asMap().entries.map((entry) {
                        int index = entry.key;
                        BuyDetail detail = entry.value;
                        final product = controller.products.firstWhere(
                          (product) => product.id == detail.productId,
                          orElse: () => Product(
                            id: '',
                            name: 'Producto desconocido',
                            barcode: '',
                            price: 0.0,
                            stock: 0,
                          ),
                        );
                        return Card(
                          child: ListTile(
                            title: Text(product.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Cantidad: ${detail.quantity}'),
                                Text('Costo unitario: S/. ${detail.unitCost}'),
                                Text('Costo total: S/. ${detail.totalCost}'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                removeDetail(index);
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Guardar'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      totalCost = details.fold(
                          0.0, (sum, detail) => sum + detail.totalCost);
                      Buy newBuy = Buy(
                        id: '',
                        supplierId: selectedSupplierId,
                        totalCost: totalCost,
                        date: DateTime.now(),
                        details: details,
                      );
                      controller.addBuy(newBuy);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
