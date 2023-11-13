import 'package:get/get.dart';
import 'package:pet_care_customer/bindings/all_binding.dart';
import 'package:pet_care_customer/funtions/cart/cart_page.dart';
import 'package:pet_care_customer/funtions/home/home_page.dart';
import 'package:pet_care_customer/funtions/order/order_page.dart';
import 'package:pet_care_customer/funtions/personal/personal_page.dart';
import 'package:pet_care_customer/funtions/product/product_detail/product_detail_page.dart';
import 'package:pet_care_customer/funtions/product/product_page.dart';
import 'package:pet_care_customer/funtions/services/room/room_page.dart';
import 'package:pet_care_customer/funtions/splash/splash_screen.dart';
import 'package:pet_care_customer/routes/routes_const.dart';
import '../funtions/login/login_page.dart';
import '../funtions/register/register_page.dart';

class Routes {
  static final routes = [
    GetPage(
        name: '/',
        page: () => const SplashPage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.splash,
        page: () => const SplashPage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.home,
        page: () => const HomePage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.login,
        page: () => const LoginPage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.register,
        page: () => const RegisterPage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.product,
        page: () => const ProductPage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.productDetail,
        page: () => const ProductDetailPage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.cart,
        page: () => const CartPage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.order,
        page: () => const OrderPage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.room,
        page: () => const RoomPage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.personal,
        page: () => const PersonalPage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
  ];
}
