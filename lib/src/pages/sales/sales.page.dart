import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sales.controller.dart';

class SalesPage extends StatelessWidget {
  const SalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SalesController controller = Get.put(SalesController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Page'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: controller.sales.length,
          itemBuilder: (context, index) {
            final sale = controller.sales[index];
            return ListTile(
              title: Text(sale.productId),
              subtitle: Text('Quantity: ${sale.quantity}, Price: ${sale.price}'),
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
