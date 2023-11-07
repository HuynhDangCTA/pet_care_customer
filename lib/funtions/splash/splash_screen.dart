import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care_customer/funtions/splash/splash_controller.dart';

import '../../core/colors.dart';
import '../../widgets/app_text.dart';


class SplashPage extends GetView<SplashController> {

  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'images/logo_rebg.png',
              width: 200,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          AppText(
            text: controller.name,
            color: MyColors.primaryColor,
            isBold: true,
            size: 25,
          )
        ],
      ),
    );
  }
}
