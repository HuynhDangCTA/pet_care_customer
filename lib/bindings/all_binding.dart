import 'package:get/get.dart';
import 'package:pet_care_customer/funtions/home/home_controller.dart';
import 'package:pet_care_customer/funtions/login/login_controller.dart';
import 'package:pet_care_customer/funtions/product/product_contronller.dart';
import 'package:pet_care_customer/funtions/register/register_controller.dart';
import 'package:pet_care_customer/funtions/splash/splash_controller.dart';

class AllBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController());
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => RegisterController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => ProductController());
  }
}
