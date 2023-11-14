import 'package:get/get.dart';
import 'package:pet_care_customer/funtions/cart/cart_controller.dart';
import 'package:pet_care_customer/funtions/home/home_controller.dart';
import 'package:pet_care_customer/funtions/login/login_controller.dart';
import 'package:pet_care_customer/funtions/order/order_controller.dart';
import 'package:pet_care_customer/funtions/personal/info/change_password_controller.dart';
import 'package:pet_care_customer/funtions/personal/my_order/my_order_controller.dart';
import 'package:pet_care_customer/funtions/personal/personal_controller.dart';
import 'package:pet_care_customer/funtions/product/product_contronller.dart';
import 'package:pet_care_customer/funtions/register/register_controller.dart';
import 'package:pet_care_customer/funtions/services/room/room_controller.dart';
import 'package:pet_care_customer/funtions/services/services_controller.dart';
import 'package:pet_care_customer/funtions/splash/splash_controller.dart';
import 'package:pet_care_customer/funtions/voucher/voucher_controller.dart';

class AllBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController());
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => RegisterController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => ProductController());
    Get.lazyPut(() => CartController());
    Get.lazyPut(() => OrderController());
    Get.lazyPut(() => VoucherController());
    Get.lazyPut(() => ServiceController());
    Get.lazyPut(() => RoomController());
    Get.lazyPut(() => PersonalController());
    Get.lazyPut(() => MyOrderController());
    Get.lazyPut(() => ChangePasswordController());
  }
}
