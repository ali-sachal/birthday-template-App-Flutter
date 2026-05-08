import 'package:get/get.dart';
import '../controllers/birthday_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BirthdayController>(() => BirthdayController());
  }
}
