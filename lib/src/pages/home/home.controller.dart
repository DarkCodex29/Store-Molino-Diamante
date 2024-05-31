import 'package:get/get.dart';

class HomeController extends GetxController {
  // Variables and methods for home page can be defined here
  var message = 'Welcome to Home Page'.obs;

  void updateMessage(String newMessage) {
    message.value = newMessage;
  }
}
