
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care_customer/core/colors.dart';
import 'package:pet_care_customer/funtions/personal/personal_controller.dart';
import 'package:pet_care_customer/widgets/app_text.dart';
import 'package:pet_care_customer/widgets/text_form_field.dart';

class InfoPage extends GetView<PersonalController> {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget profile = GestureDetector(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: MyColors.primaryColor, width: 1),
                  color: MyColors.primaryColor,
                  borderRadius: BorderRadius.circular(1000),
                ),
                child: ClipOval(
                    child: (controller.user != null)
                        ? Image.network(
                      controller.user!.avatar!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('images/profile.png');
                      },
                    )
                        : Image.asset('images/profile.png')),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          const AppText(
            text: 'Nguyễn Văn A',
            color: MyColors.primaryColor,
            size: 20,
            isBold: true,
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Thông tin tài khoản'),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: profile),
            const SizedBox(height: 20,),
            const AppText(
              text: 'Họ tên',
              color: MyColors.textColor,
            ),
            const SizedBox(
              height: 10,
            ),
            MyTextFormField(
              label: '',
              readOnly: true,
              initText: controller.user!.name,
              keyboardType: TextInputType.phone ,
            ),
            const SizedBox(
              height: 20,
            ),
            const AppText(
              text: 'Số điện thoại',
              color: MyColors.textColor,
            ),
            const SizedBox(
              height: 10,
            ),
            MyTextFormField(
              label: '',
              readOnly: true,
              initText: controller.user!.phoneNumber,
              keyboardType: TextInputType.phone ,
            ),
            const SizedBox(
              height: 20,
            ),
            const AppText(
              text: 'Địa chỉ',
              color: MyColors.textColor,
            ),
            const SizedBox(
              height: 10,
            ),
            MyTextFormField(
              label: '',
              readOnly: true,
              initText: controller.user!.address,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
