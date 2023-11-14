import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pet_care_customer/core/colors.dart';
import 'package:pet_care_customer/widgets/app_text.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget item(
            {required IconData icon,
            required String title,
            required String content,
            required Function() onTap}) =>
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: MyColors.primaryColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: AppText(
                    text: title,
                    maxLines: 1,
                    isBold: true,
                  ))
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: AppText(
                  text: content,
                  maxLines: 4,
                ),
              )
            ],
          ),
        );

    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin liên hệ'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: Get.width * 0.5,
                  height: Get.width * 0.5,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('images/logo_rebg.png'))),
                ),
                const AppText(
                  text: 'TIỆM NHÀ CHUỘT',
                  color: MyColors.primaryColor,
                  isBold: true,
                  size: 20,
                ),
              ],
            ),
          ),
          item(
              title: 'Địa chỉ',
              icon: Icons.location_on,
              onTap: () {},
              content:
                  'Số 108/42 đường 30/4, phường An Phú, quận Ninh Kiều, Thành phố Cần Thơ'),
          item(
            icon: Icons.email,
            title: 'Email',
            content: 'tiemnhachuot2023@gmail.com',
            onTap: () {},
          ),
          item(
            icon: Icons.phone,
            title: 'Số điện thoại',
            content: '077 385 0202',
            onTap: () {},
          ),
          item(
            icon: Icons.timelapse,
            title: 'Mở cửa',
            content: '8h - 20h',
            onTap: () {},
          ),
          item(
            icon: FontAwesomeIcons.squareFacebook,
            title: 'Fanpage',
            content: 'www.facebook.com/tiemnhachuot2023',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
