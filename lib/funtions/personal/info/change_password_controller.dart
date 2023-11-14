import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care_customer/funtions/home/home_controller.dart';
import 'package:pet_care_customer/model/user_response.dart';
import 'package:pet_care_customer/network/firebase_helper.dart';
import 'package:pet_care_customer/util/dialog_util.dart';
import 'package:pet_care_customer/util/encode_util.dart';
import 'package:pet_care_customer/util/shared_pref.dart';

class ChangePasswordController extends GetxController {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController repasswordController = TextEditingController();
  RxBool oldPasswordInVisible = true.obs;
  RxBool newPasswordInVisible = true.obs;
  RxBool repasswordInVisible = true.obs;

  UserResponse? user = HomeController.instants.userCurrent;

  Future changePass() async {
    String oldPass = oldPasswordController.text;
    String newPass = newPasswordController.text;
    String rePass = repasswordController.text;

    if (EncodeUtil.generateSHA256(oldPass) != user!.password) {
      DialogUtil.showSnackBar('Mật khẩu không đúng');
      return;
    }
    if (newPass != rePass) return;
    String passEncode = EncodeUtil.generateSHA256(newPass);
    DialogUtil.showLoading();
    await FirebaseHelper.changePassword(passEncode, user!.id!)
        .then((value) async {
      user!.password = passEncode;
      await SharedPref.setUser(user!);
      DialogUtil.hideLoading();
      DialogUtil.showSnackBar('Cập nhật thành công');
    });
  }
}
