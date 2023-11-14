import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care_customer/core/constants.dart';
import 'package:pet_care_customer/funtions/personal/personal_page.dart';
import 'package:pet_care_customer/funtions/product/product_page.dart';
import 'package:pet_care_customer/funtions/services/service_page.dart';
import 'package:pet_care_customer/funtions/voucher/voucher_page.dart';
import 'package:pet_care_customer/model/user_request.dart';
import 'package:pet_care_customer/model/user_response.dart';
import 'package:pet_care_customer/network/firebase_helper.dart';
import 'package:pet_care_customer/routes/routes_const.dart';
import 'package:pet_care_customer/services/fcm_service.dart';
import 'package:pet_care_customer/util/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  static HomeController get instants => Get.find();

  RxInt currentPage = 0.obs;
  UserResponse? userCurrent;
  RxInt itemCart = 0.obs;
  late StreamSubscription cartListener;
  List titleCustomer = ['Sản phẩm', 'Dịch vụ', 'Voucher', 'Cá nhân'];

  List pagesCustomer = [
    const ProductPage(),
    const ServicePage(),
    const VoucherPage(),
    const PersonalPage()
  ];

  @override
  void onInit() async {
    UserResponse? user = await SharedPref.getUser();
    userCurrent = user;
    if (userCurrent != null) {
      await FCMService.setUpFCM(userCurrent!.id!);
    }
    listenCart();
    super.onInit();
  }

  void changePage(int index) {
    currentPage.value = index;
  }

  void logout() async {
    await SharedPref.removeUser();
    Get.offAndToNamed(RoutesConst.login);
  }

  void listenCart() {
    if (userCurrent == null) return;
    cartListener =
        FirebaseHelper.listenCart(userCurrent!.id!, listener: (data) {
      itemCart.value = data.length;
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    cartListener.cancel();
  }
}
