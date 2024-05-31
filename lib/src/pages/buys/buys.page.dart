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
              subtitle: Text(
                  'Cantidad: ${buy.quantity}, Costo: ${buy.cost}, Fecha: ${buy.date}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  controller.deleteBuy(buy.id);
                },
              ),
              onTap: () {
                // Implementar lógica para actualizar la compra
                _showBuyDialog(context, controller, buy: buy);
              },
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showBuyDialog(context, controller);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showBuyDialog(BuildContext context, BuysController controller,
      {Buy? buy}) {
    final TextEditingController productIdController =
        TextEditingController(text: buy?.productId ?? '');
    final TextEditingController quantityController =
        TextEditingController(text: buy?.quantity.toString() ?? '');
    final TextEditingController costController =
        TextEditingController(text: buy?.cost.toString() ?? '');
    final TextEditingController dateController =
        TextEditingController(text: buy?.date.toIso8601String() ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(buy == null ? 'Agregar Compra' : 'Actualizar Compra'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: productIdController,
                  decoration:
                      const InputDecoration(labelText: 'ID del Producto'),
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final String productId = productIdController.text;
                final int quantity = int.tryParse(quantityController.text) ?? 0;
                final double cost = double.tryParse(costController.text) ?? 0.0;
                final DateTime date =
                    DateTime.tryParse(dateController.text) ?? DateTime.now();

                if (buy == null) {
                  final newBuy = Buy(
                    id: '',
                    productId: productId,
                    quantity: quantity,
                    cost: cost,
                    date: date,
                  );
                  controller.addBuy(newBuy);
                } else {
                  final updatedBuy = Buy(
                    id: buy.id,
                    productId: productId,
                    quantity: quantity,
                    cost: cost,
                    date: date,
                  );
                  controller.updateBuy(buy.id, updatedBuy);
                }

                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}
