import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_molino_diamante/src/models/detail.buy.dart';
import 'package:store_molino_diamante/src/models/product.dart';
import 'package:store_molino_diamante/src/models/supplier.dart';
import 'package:store_molino_diamante/src/widgets/custom.dropdown.dart';
import 'package:store_molino_diamante/src/widgets/custom.textfield.dart';
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
            return Card(
              color: Colors.grey[100],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Colors.blue, width: 1)),
              child: ExpansionTile(
                title: Text(
                    'Compra ${controller.buys.length - index}: ${supplier.name}'),
                subtitle: Text(
                    'Costo Total: S/. ${buy.totalCost.toStringAsFixed(2)}'),
                children: buy.details.map((detail) {
                  final product = controller.getProductById(detail.productId);
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text(
                        'Cantidad: ${detail.quantity}, Costo: S/. ${detail.totalCost.toStringAsFixed(2)}'),
                  );
                }).toList(),
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
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
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

            return AlertDialog(
              title: const Text('Agregar compra',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
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
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.blue)),
                        onPressed: addDetail,
                        child: const Text('Agregar Producto',
                            style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.blue)),
                        onPressed: () {
                          showAddProductDialog(context, controller);
                        },
                        child: const Text('Añadir Nuevo Producto',
                            style: TextStyle(color: Colors.white)),
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
                  child: const Text('Cancelar',
                      style: TextStyle(color: Colors.grey)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.blue)),
                  child: const Text('Guardar',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
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

  void showAddProductDialog(BuildContext context, BuysController controller) {
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
}
