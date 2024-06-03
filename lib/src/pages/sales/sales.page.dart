import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_molino_diamante/src/models/detail.sale.dart';
import 'package:store_molino_diamante/src/models/sale.dart';
import 'sales.controller.dart';
import 'package:store_molino_diamante/src/models/product.dart';

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
            final saleNumber = controller.getSaleNumber(sale.id);
            final saleDetails = sale.details.map((detail) {
              final product = controller.getProductById(detail.productId);
              return 'Producto: ${product.name}, Cantidad: ${detail.quantity}, Precio: S/. ${detail.price.toStringAsFixed(2)}';
            }).join('\n');
            return ListTile(
              title: Text('Venta: $saleNumber'),
              subtitle: Text(saleDetails),
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
          _showAddSaleDialog(context, controller);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

void _showAddSaleDialog(BuildContext context, SalesController controller) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String selectedProductId =
      controller.products.isNotEmpty ? controller.products.first.id : '';
  final quantityController = TextEditingController();
  double totalPrice = 0.0;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          void updateTotalPrice() {
            final selectedProduct =
                controller.getProductById(selectedProductId);
            final quantity = int.tryParse(quantityController.text) ?? 0;
            totalPrice = selectedProduct.price * quantity;
            setState(() {});
          }

          return AlertDialog(
            title: const Text('Agregar Venta'),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Producto'),
                      value: selectedProductId,
                      onChanged: (value) {
                        selectedProductId = value!;
                        updateTotalPrice();
                      },
                      items: controller.products.map((Product product) {
                        return DropdownMenuItem<String>(
                          value: product.id,
                          child: Text(product.name),
                        );
                      }).toList(),
                    ),
                    TextFormField(
                      controller: quantityController,
                      decoration: const InputDecoration(labelText: 'Cantidad'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        updateTotalPrice();
                      },
                    ),
                    const SizedBox(height: 10),
                    Text('Precio Total: S/. ${totalPrice.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: const Text('Guardar'),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final sale = Sale(
                      id: '',
                      date: DateTime.now(),
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                      details: [
                        SaleDetail(
                          id: '',
                          saleId: '',
                          productId: selectedProductId,
                          quantity: int.tryParse(quantityController.text) ?? 0,
                          price: totalPrice,
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                        ),
                      ],
                    );
                    controller.addSale(sale);
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
