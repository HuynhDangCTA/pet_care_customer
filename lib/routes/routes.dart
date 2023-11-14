import 'package:get/get.dart';
import 'package:pet_care_customer/bindings/all_binding.dart';
import 'package:pet_care_customer/funtions/cart/cart_page.dart';
import 'package:pet_care_customer/funtions/home/home_page.dart';
import 'package:pet_care_customer/funtions/order/order_page.dart';
import 'package:pet_care_customer/funtions/personal/contact/contact_page.dart';
import 'package:pet_care_customer/funtions/personal/info/change_password_page.dart';
import 'package:pet_care_customer/funtions/personal/info/info_page.dart';
import 'package:pet_care_customer/funtions/personal/my_order/detail/my_order_detail_page.dart';
import 'package:pet_care_customer/funtions/personal/my_order/my_order_page.dart';
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
    GetPage(
        name: RoutesConst.myOrder,
        page: () => const MyOrderPage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.myOrderDetail,
        page: () => MyOrderDetailPage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.contact,
        page: () => const ContactPage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.info,
        page: () => const InfoPage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
    GetPage(
        name: RoutesConst.changePass,
        page: () => const ChangePasswordPage(),
        transition: Transition.rightToLeft,
        binding: AllBinding()),
  ];
}
