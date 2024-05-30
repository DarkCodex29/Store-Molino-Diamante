import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_molino_diamante/src/models/user.dart';
import 'package:store_molino_diamante/src/routes/routes.dart';

class MyApp extends StatefulWidget {
  final bool isConnected;
  final User? user;
  const MyApp({super.key, required this.isConnected, required this.user});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late StreamSubscription<List<ConnectivityResult>> subscription;

  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        Get.snackbar('Conexión perdida', 'Se ha perdido la conexión a internet',
            colorText: Colors.white, backgroundColor: Colors.red);
      } else {
        Get.snackbar(
            'Conexión establecida', 'Se ha establecido la conexión a internet',
            colorText: Colors.white, backgroundColor: Colors.green);
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String initialWidget = '';

    if (widget.isConnected) {
      if (widget.user?.accessToken != null) {
        initialWidget = RoutesClass.getHome();
      } else {
        initialWidget = RoutesClass.getLogin();
      }
    }

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Store Molino Diamante',
      initialRoute: initialWidget,
      getPages: RoutesClass.routes,
      navigatorKey: Get.key,
    );
  }
}
