import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care_customer/core/constants.dart';
import 'package:pet_care_customer/funtions/product/product_page.dart';
import 'package:pet_care_customer/model/user_request.dart';
import 'package:pet_care_customer/model/user_response.dart';
import 'package:pet_care_customer/routes/routes_const.dart';
import 'package:pet_care_customer/util/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  static HomeController get instants => Get.find();

  RxInt currentPage = 0.obs;
  UserResponse? userCurrent;

  List titleCustomer = ['Sản phẩm', 'Dịch vụ', 'Cá nhân'];

  List pagesCustomer = [
    const ProductPage(),
    Container(),
    Container()
  ];

  @override
  void onInit() async {
    UserResponse? user = await SharedPref.getUser();
    userCurrent = user;
    super.onInit();

  }

  void changePage(int index) {
    currentPage.value = index;
  }

  void logout() async {
    await SharedPref.removeUser();
    Get.offAndToNamed(RoutesConst.login);
  }

}