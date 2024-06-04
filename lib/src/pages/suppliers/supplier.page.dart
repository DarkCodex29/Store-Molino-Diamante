import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_molino_diamante/src/models/supplier.dart';
import 'package:store_molino_diamante/src/pages/suppliers/supplier.controller.dart';

class SuppliersPage extends StatelessWidget {
  const SuppliersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SuppliersController controller = Get.put(SuppliersController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.suppliers.isEmpty) {
          return const Center(child: Text('No hay proveedores disponibles'));
        }
        return ListView.builder(
          itemCount: controller.suppliers.length,
          itemBuilder: (context, index) {
            final supplier = controller.suppliers[index];
            return Card(
              color: Colors.grey[100],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Colors.blue, width: 1)),
              child: ListTile(
                title: Text(supplier.name),
                subtitle: Text('Contacto: ${supplier.contact}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    controller.deleteSupplier(supplier.id);
                  },
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddSupplierDialog(context, controller);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddSupplierDialog(
      BuildContext context, SuppliersController controller) {
    final nameController = TextEditingController();
    final contactController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar proveedor',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: contactController,
                decoration: const InputDecoration(labelText: 'Contacto'),
              ),
            ],
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                final newSupplier = Supplier(
                  id: '',
                  name: nameController.text.trim(),
                  contact: contactController.text.trim(),
                  email: '',
                  address: '',
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );
                controller.addSupplier(newSupplier);
                Navigator.of(context).pop();
              },
              child:
                  const Text('Agregar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
