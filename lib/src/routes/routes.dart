import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:store_molino_diamante/src/pages/home/home.page.dart';
import 'package:store_molino_diamante/src/pages/inventory/inventory.page.dart';
import 'package:store_molino_diamante/src/pages/login/login.page.dart';
import 'package:store_molino_diamante/src/pages/products/products.page.dart';
import 'package:store_molino_diamante/src/pages/sales/sales.page.dart';

class RoutesClass {
  static String login = '/login';
  static String home = '/home';
  static String invetory = '/inventory';
  static String products = '/products';
  static String sales = '/sales';
  

  static String getLogin() => login;
  static String getHome() => home;
  static String getInventory() => invetory;
  static String getProducts() => products;
  static String getSales() => sales;

  static List<GetPage> routes = [
    GetPage(name: login, page: () => LoginPage()),
    GetPage(name: home, page: () => HomePage()),
    GetPage(name: invetory, page: () => InventoryPage()),
    GetPage(name: products, page: () => ProductsPage()),
    GetPage(name: sales, page: () => SalesPage()),
  ];
}
