import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'products.controller.dart';
import 'package:store_molino_diamante/src/models/product.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductsController controller = Get.put(ProductsController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.products.isEmpty) {
          return const Center(child: Text('No hay productos disponibles'));
        }
        return ListView.builder(
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            return ListTile(
              title: Text(product.name),
              subtitle: Text('Stock: ${product.stock}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  controller.deleteProduct(product.id);
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddProductDialog(context, controller);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddProductDialog(
      BuildContext context, ProductsController controller) {
    final nameController = TextEditingController();
    final barcodeController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Añadir Producto'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: barcodeController,
                  decoration:
                      const InputDecoration(labelText: 'Código de barras'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Precio'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: stockController,
                  decoration: const InputDecoration(labelText: 'Stock'),
                  keyboardType: TextInputType.number,
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
                final product = Product(
                  id: '', // ID generado automáticamente
                  name: nameController.text,
                  barcode: barcodeController.text,
                  price: double.tryParse(priceController.text) ?? 0.0,
                  stock: int.tryParse(stockController.text) ?? 0,
                );
                controller.addProduct(product);
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
