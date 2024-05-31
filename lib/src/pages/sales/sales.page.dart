import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sales.controller.dart';

class SalesPage extends StatelessWidget {
  const SalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SalesController controller = Get.put(SalesController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.sales.isEmpty) {
          return const Center(child: Text('No hay ventas disponibles'));
        }
        return ListView.builder(
          itemCount: controller.sales.length,
          itemBuilder: (context, index) {
            final sale = controller.sales[index];
            return ListTile(
              title: Text(sale.id),
              subtitle: Text('Quantity: ${sale}, Price: ${sale}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  controller.deleteSale(sale.id);
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Open a dialog or new page to add a new sale
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
