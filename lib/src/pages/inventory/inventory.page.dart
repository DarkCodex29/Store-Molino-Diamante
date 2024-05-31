import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'inventory.controller.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final InventoryController controller = Get.put(InventoryController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.inventories.isEmpty) {
          return const Center(child: Text('El inventario está vacío'));
        }
        return ListView.builder(
          itemCount: controller.inventories.length,
          itemBuilder: (context, index) {
            final inventory = controller.inventories[index];
            return ListTile(
              title: Text(inventory.productId),
              subtitle: Text('Quantity: ${inventory.quantity}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  controller.deleteInventory(inventory.id);
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Open a dialog or new page to add a new inventory item
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
