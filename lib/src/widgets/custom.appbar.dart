import 'package:flutter/material.dart';
import 'package:store_molino_diamante/src/models/app.user.dart';

// ignore: must_be_immutable
class CustomAppBar extends AppBar {
  CustomAppBar({super.key, required BuildContext context})
      : super(
          backgroundColor: Colors.blue,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(25),
            ),
          ),
          leading: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Cerrar sesión'),
                        content: const Text(
                            '¿Estás seguro de que quieres cerrar sesión?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(color: Colors.grey),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Cerrar Sesión',
                                style: TextStyle(color: Colors.blue)),
                            onPressed: () {
                              Navigator.of(context).pop();
                              AppUser.logout();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.power_settings_new),
                color: Colors.white,
              )),
          title: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 20,
            child: Image.asset(
              'assets/logo.png',
              fit: BoxFit.fitHeight,
              height: kToolbarHeight - 15,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              color: Colors.white,
              onPressed: () {
                _showUserInfoDialog(context);
              },
            ),
          ],
        );

  static void _showUserInfoDialog(BuildContext context) {
    final AppUser? user = AppUser.getUser();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 40,
                backgroundImage:
                    AssetImage('assets/logo.png'), // Imagen del logo
              ),
              const SizedBox(height: 10),
              Text(
                '${user?.name} ${user?.lastName}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                user?.email ?? 'Correo desconocido',
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                user?.phone ?? 'Teléfono desconocido',
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Cerrar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
