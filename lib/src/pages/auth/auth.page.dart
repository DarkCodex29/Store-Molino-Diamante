import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_molino_diamante/src/pages/auth/auth.controller.dart';
import 'package:store_molino_diamante/src/widgets/custom.textfield.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  final PageController pageController = PageController();
  int _selectedIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.put(AuthController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Image.asset(
                  'assets/logo.png',
                  height: 200,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                margin: const EdgeInsets.only(bottom: 20),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTabItem('Iniciar sesión', 0),
                    _buildTabItem('Registrarse', 1),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10.0,
                      spreadRadius: 5.0,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                width: 300,
                child: SizedBox(
                  height: 300,
                  child: PageView(
                    controller: pageController,
                    onPageChanged: _onPageChanged,
                    children: [
                      _buildLoginPage(controller, pageController),
                      _buildRegisterPage(controller, pageController),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildTabItem(String title, int index) {
    return GestureDetector(
      onTap: () {
        pageController.animateToPage(index,
            duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
      },
      child: Container(
        width: 150,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _selectedIndex == index ? Colors.grey[200] : Colors.white,
          borderRadius: _selectedIndex == index
              ? BorderRadius.only(
                  topLeft: Radius.circular(index == 0 ? 20 : 0),
                  topRight: Radius.circular(index == 1 ? 20 : 0),
                )
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight:
                _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
            color: _selectedIndex == index ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginPage(
      AuthController controller, PageController pageController) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CustomTextField(
              controller: controller.loginEmail,
              labelText: 'Email',
              prefixIcon: const Icon(Icons.email),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: controller.loginPassword,
              labelText: 'Constraseña',
              obscureText: true,
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: const Icon(Icons.visibility),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Colors.blue,
                    Color.fromARGB(255, 133, 216, 255),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ElevatedButton(
                onPressed: () {
                  controller.login(controller.loginEmail.text,
                      controller.loginPassword.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Iniciar sesión',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              },
              child: const Text('¿No tienes cuenta? Regístrate',
                  style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterPage(
      AuthController controller, PageController pageController) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CustomTextField(
              controller: controller.registerEmail,
              labelText: 'Email',
              prefixIcon: const Icon(Icons.email),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: controller.registerPassword,
              labelText: 'Contraseña',
              obscureText: true,
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: const Icon(Icons.visibility),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: controller.name,
              labelText: 'Nombres',
              prefixIcon: const Icon(Icons.person),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: controller.lastName,
              labelText: 'Apellidos',
              prefixIcon: const Icon(Icons.person_outline),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: controller.phone,
              labelText: 'Celular',
              prefixIcon: const Icon(Icons.phone),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: 'worker',
              items: const [
                DropdownMenuItem(value: 'admin', child: Text('Administrador')),
                DropdownMenuItem(value: 'worker', child: Text('Trabajador')),
              ],
              onChanged: (value) {
                controller.role = value;
              },
              decoration: InputDecoration(
                labelText: 'Rol',
                labelStyle: const TextStyle(color: Colors.blue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Colors.blue,
                    Color.fromARGB(255, 133, 216, 255),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ElevatedButton(
                onPressed: () {
                  controller.register();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Registrarse',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              },
              child: const Text('¿Ya tienes una cuenta? Inicia sesión',
                  style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }
}
