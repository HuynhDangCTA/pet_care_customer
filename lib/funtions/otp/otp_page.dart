import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care_customer/core/colors.dart';
import 'package:pet_care_customer/funtions/otp/otp_controller.dart';
import 'package:pet_care_customer/widgets/app_button.dart';
import 'package:pet_care_customer/widgets/app_text.dart';
import 'package:pet_care_customer/widgets/input_otp.dart';

class OTPPage extends GetView<OTPController> {
  static const String routeName = '/otp';

  const OTPPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget reSend = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const AppText(
          text: 'Không nhận được mã OTP?',
          color: MyColors.textColor,
        ),
        const SizedBox(width: 15),
        GestureDetector(
          onTap: () {},
          child: const AppText(
            text: 'Gửi lại',
            color: MyColors.primaryColor,
            isBold: true,
          ),
        )
      ],
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Container(
                  width: Get.width * 0.6,
                  height: Get.width * 0.6,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('images/otp.png'),
                          fit: BoxFit.cover)),
                ),
              ),
              const AppText(
                text: 'Xác thực OTP',
               isBold: true,
                size: 25,
                color: MyColors.primaryColor,
              ),
              const AppText(
                text: 'Nhập mã OTP được gửi đến',
                color: MyColors.primaryColor,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.phone_android,
                    color: MyColors.primaryColor,
                  ),
                  AppText(
                    text: controller.user.phoneNumber ?? '',
                    color: MyColors.primaryColor,
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InputOTP(
                    controller: controller.pin1,
                    isFirst: true,
                  ),
                  InputOTP(
                    controller: controller.pin2,
                  ),
                  InputOTP(
                    controller: controller.pin3,
                  ),
                  InputOTP(controller: controller.pin4),
                  InputOTP(controller: controller.pin5),
                  InputOTP(
                    controller: controller.pin6,
                    isLast: true,
                  ),
                ],
              ),
              const SizedBox(
                height: 60,
              ),
              reSend,
              const SizedBox(
                height: 70,
              ),
              AppButton(
                text: 'Xác nhận',
                onPressed: () async {
                  await controller.submitOTP();
                },
                isResponsive: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}
