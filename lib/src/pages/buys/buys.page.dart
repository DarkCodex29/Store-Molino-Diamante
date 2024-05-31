import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            return ListTile(
              title: Text(buy.productId),
              subtitle:
                  Text('Cantidad: ${buy.quantity}, Proveedor: ${buy.provider}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  controller.deleteBuy(buy.id);
                },
              ),
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
    final productIdController = TextEditingController();
    final providerController = TextEditingController();
    final quantityController = TextEditingController();
    final costController = TextEditingController();
    final dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Añadir Compra'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: productIdController,
                  decoration:
                      const InputDecoration(labelText: 'ID del Producto'),
                ),
                TextField(
                  controller: providerController,
                  decoration: const InputDecoration(labelText: 'Proveedor'),
                ),
                TextField(
                  controller: quantityController,
                  decoration: const InputDecoration(labelText: 'Cantidad'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: costController,
                  decoration: const InputDecoration(labelText: 'Costo'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(labelText: 'Fecha'),
                  keyboardType: TextInputType.datetime,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final buy = Buy(
                  id: '', // ID generado automáticamente
                  productId: productIdController.text,
                  provider: providerController.text,
                  quantity: int.tryParse(quantityController.text) ?? 0,
                  cost: double.tryParse(costController.text) ?? 0.0,
                  date: DateTime.parse(dateController.text),
                );
                controller.addBuy(buy);
                Navigator.of(context).pop();
              },
              child: const Text('Añadir'),
            ),
          ],
        );
      },
    );
  }
}
