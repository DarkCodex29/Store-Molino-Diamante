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
            final supplier = controller.getSupplierById(buy.supplierId);
            return ExpansionTile(
              title: Text('Compra ${index + 1}: ${supplier.name}'),
              subtitle:
                  Text('Costo Total: S/. ${buy.totalCost.toStringAsFixed(2)}'),
              children: buy.details.map((detail) {
                final product = controller.getProductById(detail.productId);
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text(
                      'Cantidad: ${detail.quantity}, Costo: S/. ${detail.totalCost.toStringAsFixed(2)}'),
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

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            void addDetail() {
              details.add(BuyDetail(
                id: '',
                buyId: '',
                productId: controller.products.first.id,
                quantity: 0,
                unitCost: controller.products.first.price,
                totalCost: controller.products.first.price,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
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

            void showAddProductDialog() {
              final nameController = TextEditingController();
              final barcodeController = TextEditingController();
              final priceController = TextEditingController();
              final stockController = TextEditingController();
              String selectedCategoryId = controller.categories.isNotEmpty
                  ? controller.categories.first.id
                  : '';

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
                            decoration:
                                const InputDecoration(labelText: 'Nombre'),
                          ),
                          TextField(
                            controller: barcodeController,
                            decoration: const InputDecoration(
                                labelText: 'Código de barras'),
                          ),
                          TextField(
                            controller: priceController,
                            decoration: const InputDecoration(
                                labelText: 'Precio de venta'),
                            keyboardType: TextInputType.number,
                          ),
                          TextField(
                            controller: stockController,
                            decoration:
                                const InputDecoration(labelText: 'Stock'),
                            keyboardType: TextInputType.number,
                          ),
                          DropdownButtonFormField<String>(
                            decoration:
                                const InputDecoration(labelText: 'Categoría'),
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
                            id: '',
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

            return AlertDialog(
              title: const Text('Agregar Compra'),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      DropdownButtonFormField<String>(
                        decoration:
                            const InputDecoration(labelText: 'Proveedor'),
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
                      ElevatedButton(
                        onPressed: showAddProductDialog,
                        child: const Text('Añadir Nuevo Producto'),
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        child: Column(
                          children: details.asMap().entries.map((entry) {
                            int index = entry.key;
                            BuyDetail detail = entry.value;
                            return Card(
                              child: ListTile(
                                title: DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                      labelText: 'Producto'),
                                  value: detail.productId,
                                  onChanged: (value) {
                                    Product selectedProduct =
                                        controller.products.firstWhere(
                                            (product) => product.id == value);
                                    detail.productId = value!;
                                    detail.unitCost = selectedProduct.price;
                                    detail.totalCost =
                                        selectedProduct.price * detail.quantity;
                                    updateDetail(index, detail);
                                  },
                                  items: controller.products
                                      .map((Product product) {
                                    return DropdownMenuItem<String>(
                                      value: product.id,
                                      child: Text(product.name),
                                    );
                                  }).toList(),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      initialValue: detail.quantity.toString(),
                                      decoration: const InputDecoration(
                                          labelText: 'Cantidad'),
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        detail.quantity =
                                            int.tryParse(value) ?? 1;
                                        detail.totalCost =
                                            detail.unitCost * detail.quantity;
                                        updateDetail(index, detail);
                                      },
                                    ),
                                    TextFormField(
                                      initialValue: detail.unitCost.toString(),
                                      decoration: const InputDecoration(
                                          labelText: 'Costo Unitario'),
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        detail.unitCost =
                                            double.tryParse(value) ?? 0.0;
                                        detail.totalCost =
                                            detail.unitCost * detail.quantity;
                                        updateDetail(index, detail);
                                      },
                                    ),
                                    Text(
                                        'Costo total: S/. ${detail.totalCost.toStringAsFixed(2)}'),
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
                      ),
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
                TextButton(
                  child: const Text('Guardar'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      double totalCost = details.fold(
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
