import 'package:get/get.dart';
import 'package:ivr_frontend/presentation/getx/controllers/home_controller.dart';

class HomeBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}