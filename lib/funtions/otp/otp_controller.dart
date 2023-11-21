import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care_customer/model/user_response.dart';
import 'package:pet_care_customer/network/firebase_helper.dart';
import 'package:pet_care_customer/routes/routes_const.dart';
import 'package:pet_care_customer/services/fcm_service.dart';
import 'package:pet_care_customer/util/dialog_util.dart';
import 'package:pet_care_customer/util/shared_pref.dart';

class OTPController extends GetxController {
  TextEditingController pin1 = TextEditingController();
  TextEditingController pin2 = TextEditingController();
  TextEditingController pin3 = TextEditingController();
  TextEditingController pin4 = TextEditingController();
  TextEditingController pin5 = TextEditingController();
  TextEditingController pin6 = TextEditingController();

  UserResponse user = Get.arguments;

  Future submitOTP() async {
    String otp =
        pin1.text + pin2.text + pin3.text + pin4.text + pin5.text + pin6.text;
    if (otp.length < 6) return;

    try {
      DialogUtil.showLoading();
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: user.verificationId!, smsCode: otp);

      await FirebaseAuth.instance.signInWithCredential(credential);

      await FirebaseHelper.register(user).then((value) async {
        user.id = value.id;
        String? token = await FCMService.getToken(value.id!);
        user.token = token;
        await SharedPref.setUser(user);
        String? id = await FirebaseHelper.getCustomer(user.phoneNumber!);
        if (id == null || id.isEmpty) {
          await FirebaseHelper.newCustomer(user);
        }
        Get.offAllNamed(RoutesConst.home);
      }).catchError((error) {
        DialogUtil.showSnackBar(error.toString());
      });
      DialogUtil.hideLoading();
    } catch (e) {
      DialogUtil.hideLoading();
      DialogUtil.showSnackBar('OTP không chính xác');
    }
  }
}
