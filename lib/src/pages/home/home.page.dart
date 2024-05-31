import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_molino_diamante/src/pages/home/home.controller.dart';
import 'package:store_molino_diamante/src/pages/inventory/inventory.page.dart';
import 'package:store_molino_diamante/src/pages/products/products.page.dart';
import 'package:store_molino_diamante/src/pages/sales/sales.page.dart';
import 'package:store_molino_diamante/src/pages/buys/buys.page.dart';
import 'package:store_molino_diamante/src/widgets/custom.appbar.dart'; // Importa la página de compras

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final HomeController controller = Get.put(HomeController());
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const InventoryPage(),
    const ProductsPage(),
    const SalesPage(),
    const BuysPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
      ),
      body: Center(
        child: _pages[_selectedIndex],
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.inventory,
                  color: Colors.white,
                ),
                label: 'Inventario',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.shopping_bag,
                  color: Colors.white,
                ),
                label: 'Productos',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.point_of_sale,
                  color: Colors.white,
                ),
                label: 'Ventas',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                label: 'Compras',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.7),
            onTap: _onItemTapped,
            backgroundColor: Colors.blue,
          ),
        ),
      ),
    );
  }
}
