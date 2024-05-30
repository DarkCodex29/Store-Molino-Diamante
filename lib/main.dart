import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:store_molino_diamante/src/app.dart';
import 'package:store_molino_diamante/src/models/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await GetStorage.init();
  //await dotenv.load(fileName: ".envQAS");

  // CONECTIVIDAD
  final List<ConnectivityResult> connectivityResult =
      await (Connectivity().checkConnectivity());
  bool isConnected = (connectivityResult.contains(ConnectivityResult.mobile) ||
      connectivityResult.contains(ConnectivityResult.wifi));

  // USER
  User user = User.getUser();
  runApp(MyApp(isConnected: isConnected, user: user));
}
