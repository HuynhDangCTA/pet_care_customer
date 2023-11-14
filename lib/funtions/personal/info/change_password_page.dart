import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care_customer/core/colors.dart';
import 'package:pet_care_customer/funtions/personal/info/change_password_controller.dart';
import 'package:pet_care_customer/widgets/app_button.dart';
import 'package:pet_care_customer/widgets/app_text.dart';
import 'package:pet_care_customer/widgets/text_form_field.dart';

class ChangePasswordPage extends GetView<ChangePasswordController> {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đổi mật khẩu'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText(
                text: 'Mật khẩu cũ',
                color: MyColors.textColor,
              ),
              const SizedBox(
                height: 10,
              ),
              Obx(() => MyTextFormField(
                    label: '',
                    controller: controller.oldPasswordController,
                    obscureText: controller.oldPasswordInVisible.value,
                    suffixIcon: InkWell(
                      child: (controller.oldPasswordInVisible.value)
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                      onTap: () {
                        controller.oldPasswordInVisible.value =
                            !controller.oldPasswordInVisible.value;
                      },
                    ),
                  )),
              const SizedBox(
                height: 30,
              ),
              const AppText(
                text: 'Mật khẩu mới',
                color: MyColors.textColor,
              ),
              const SizedBox(
                height: 10,
              ),
              Obx(() => MyTextFormField(
                    label: '',
                    controller: controller.newPasswordController,
                    obscureText: controller.newPasswordInVisible.value,
                    suffixIcon: InkWell(
                      child: (controller.newPasswordInVisible.value)
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                      onTap: () {
                        controller.newPasswordInVisible.value =
                            !controller.newPasswordInVisible.value;
                      },
                    ),
                  )),
              const SizedBox(
                height: 30,
              ),
              const AppText(
                text: 'Nhập lại mật khẩu',
                color: MyColors.textColor,
              ),
              const SizedBox(
                height: 10,
              ),
              Obx(() => MyTextFormField(
                    label: '',
                    controller: controller.repasswordController,
                    obscureText: controller.repasswordInVisible.value,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value != controller.newPasswordController.text) {
                        return 'Mật khẩu nhập lại không đúng';
                      }
                      return null;
                    },
                    suffixIcon: InkWell(
                      child: (controller.repasswordInVisible.value)
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                      onTap: () {
                        controller.repasswordInVisible.value =
                            !controller.repasswordInVisible.value;
                      },
                    ),
                  )),
              const SizedBox(
                height: 30,
              ),
              AppButton(
                onPressed: () async {
                  await controller.changePass();
                },
                isResponsive: true,
                isShadow: false,
                text: 'Cập nhật',
              )
            ],
          ),
        ),
      ),
    );
  }
}
