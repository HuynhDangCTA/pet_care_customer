import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care_customer/widgets/app_text.dart';
import 'package:pet_care_customer/widgets/loading.dart';

class DialogUtil {
  static void showSnackBar(String message) async {
    if (Get.isSnackbarOpen) {
      await Get.closeCurrentSnackbar();
    }
    Get.showSnackbar(GetSnackBar(
      message: message,
      padding: const EdgeInsets.all(15),
      duration: const Duration(milliseconds: 1500),
      borderRadius: 10.0,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
    ));
  }

  static void showLoading() async {
    if (Get.isSnackbarOpen) {
      await Get.closeCurrentSnackbar();
    }
    await Get.dialog(
        WillPopScope(
          onWillPop: () async {
            Get.back();
            Get.back();
            return false;
          },
          child: const AlertDialog(
            backgroundColor: Colors.transparent,
            content: LoadingWidget(),
            surfaceTintColor: Colors.transparent,
          ),
        ),
        barrierDismissible: false,
        barrierColor: Colors.transparent);
  }

  static void hideLoading()  {
    if (Get.isSnackbarOpen) {
      Get.back();
      Future.delayed(
        const Duration(seconds: 1),
        () {
          Get.back();
        },
      );
    } else {
      Get.back();
    }
  }

  static void showOrderSuccess() {
    Get.defaultDialog(
        title: 'Thông báo',
        barrierDismissible: false,
        content: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: SizedBox(
            width: Get.width,
            child: Column(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset(
                    'images/ic_checked.png',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const AppText(text: 'Đặt hàng thành công')
              ],
            ),
          ),
        ));
  }
}
