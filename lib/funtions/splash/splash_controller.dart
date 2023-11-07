import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care_customer/routes/routes_const.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants.dart';

class SplashController extends GetxController {
  String name = 'Tiệm nhà Chuột';

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    await goToHome();
  }

  Future goToHome() async {
    Future.delayed(
      const Duration(seconds: 2),
      () async {
        Get.offAndToNamed(RoutesConst.home);
      },
    );
  }
}
