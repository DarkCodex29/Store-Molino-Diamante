import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'inventory.controller.dart';
import 'package:store_molino_diamante/src/models/product.dart';

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
        if (controller.products.isEmpty) {
          return const Center(child: Text('El inventario está vacío'));
        }
        return ListView.builder(
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            return ExpansionTile(
              title: Text(product.name),
              subtitle: Text('Stock: ${product.stock}'),
              children: [
                ListTile(
                  title: Text('Código de Barras: ${product.barcode}'),
                ),
                ListTile(
                  title: Text(
                      'Precio de Venta: S/. ${product.price.toStringAsFixed(2)}'),
                ),
                ListTile(
                  title: Text(
                      'Categoría: ${controller.categories.firstWhere((category) => category.id == product.category).name}'),
                ),
                ...product.suppliersInfo.map((supplierInfo) {
                  final supplierName =
                      controller.getSupplierName(supplierInfo.supplierId);
                  return ListTile(
                    title: Text('Proveedor: $supplierName'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Precio de Compra: S/. ${supplierInfo.purchasePrice.toStringAsFixed(2)}'),
                        Text('Cantidad: ${supplierInfo.quantity}'),
                      ],
                    ),
                  );
                }).toList(),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    controller.deleteProduct(product.id);
                  },
                ),
              ],
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
      BuildContext context, InventoryController controller) {
    final nameController = TextEditingController();
    final barcodeController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();
    String selectedCategoryId =
        controller.categories.isNotEmpty ? controller.categories.first.id : '';

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
                  decoration:
                      const InputDecoration(labelText: 'Precio de Venta'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: stockController,
                  decoration: const InputDecoration(labelText: 'Stock'),
                  keyboardType: TextInputType.number,
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Categoría'),
                  value: selectedCategoryId,
                  onChanged: (value) {
                    selectedCategoryId = value!;
                  },
                  items: controller.categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category.id,
                      child: Text(category.name),
                    );
                  }).toList(),
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
                  category: selectedCategoryId,
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
