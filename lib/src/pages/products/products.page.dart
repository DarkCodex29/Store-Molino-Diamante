import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_molino_diamante/src/widgets/custom.dropdown.dart';
import 'package:store_molino_diamante/src/widgets/custom.textfield.dart';
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
            return Card(
              color: Colors.grey[100],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Colors.blue, width: 1)),
              child: ListTile(
                title: Text(product.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                subtitle:
                    Text('Precio: S/. ${product.price.toStringAsFixed(2)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showEditProductDialog(context, product, controller);
                      },
                    ),
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _showDeleteConfirmationDialog(context, product);
                      },
                    ),
                  ],
                ),
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Añadir producto',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextField(
                  controller: controller.nameController,
                  labelText: 'Nombre',
                ),
                CustomTextField(
                  controller: controller.barcodeController,
                  labelText: 'Código de barras',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.qr_code),
                    onPressed: () => controller.scanMobile(context),
                  ),
                ),
                CustomTextField(
                  controller: controller.priceController,
                  labelText: 'Precio de Venta',
                  keyboardType: TextInputType.number,
                ),
                CustomTextField(
                  controller: controller.stockController,
                  labelText: 'Stock',
                  keyboardType: TextInputType.number,
                ),
                CustomDropdownButton<String>(
                  labelText: 'Categoría',
                  value: controller.selectedCategoryId,
                  items: controller.categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category.id,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    controller.selectedCategoryId = value!;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blue)),
              onPressed: () {
                final product = Product(
                  id: '',
                  name: controller.nameController.text,
                  barcode: controller.barcodeController.text,
                  price:
                      double.tryParse(controller.priceController.text) ?? 0.0,
                  stock: int.tryParse(controller.stockController.text) ?? 0,
                  category: controller.selectedCategoryId,
                );
                controller.addProduct(product);
                controller.clearFields();
                Navigator.of(context).pop();
              },
              child:
                  const Text('Añadir', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showEditProductDialog(
      BuildContext context, Product product, ProductsController controller) {
    controller.nameController.text = product.name;
    controller.barcodeController.text = product.barcode;
    controller.priceController.text = product.price.toString();
    controller.stockController.text = product.stock.toString();
    controller.selectedCategoryId = product.category;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar producto',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextField(
                  controller: controller.nameController,
                  labelText: 'Nombre',
                ),
                CustomTextField(
                  controller: controller.barcodeController,
                  labelText: 'Código de barras',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.qr_code),
                    onPressed: () => controller.scanMobile(context),
                  ),
                ),
                CustomTextField(
                  controller: controller.priceController,
                  labelText: 'Precio de Venta',
                  keyboardType: TextInputType.number,
                ),
                CustomTextField(
                  controller: controller.stockController,
                  labelText: 'Stock',
                  keyboardType: TextInputType.number,
                ),
                CustomDropdownButton<String>(
                  labelText: 'Categoría',
                  value: controller.selectedCategoryId,
                  items: controller.categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category.id,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    controller.selectedCategoryId = value!;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.clearFields();
                Navigator.of(context).pop();
              },
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blue)),
              onPressed: () async {
                product.name = controller.nameController.text;
                product.barcode = controller.barcodeController.text;
                product.price =
                    double.tryParse(controller.priceController.text) ?? 0.0;
                product.stock =
                    int.tryParse(controller.stockController.text) ?? 0;
                product.category = controller.selectedCategoryId;

                await Product.updateProduct(product.id, product);
                Get.snackbar('Producto actualizado',
                    'El producto se actualizó correctamente.',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                    duration: const Duration(milliseconds: 1500));
                controller.clearFields();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
              child:
                  const Text('Guardar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar producto',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(
              '¿Está seguro de que desea eliminar el producto ${product.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Product.deleteProduct(product.id);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child:
                  const Text('Eliminar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
