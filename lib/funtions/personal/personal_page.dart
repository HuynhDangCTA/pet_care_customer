import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pet_care_customer/core/colors.dart';
import 'package:pet_care_customer/funtions/home/home_controller.dart';
import 'package:pet_care_customer/funtions/personal/personal_controller.dart';
import 'package:pet_care_customer/routes/routes_const.dart';
import 'package:pet_care_customer/widgets/app_button.dart';
import 'package:pet_care_customer/widgets/app_text.dart';

class PersonalPage extends GetView<PersonalController> {
  const PersonalPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget profile = GestureDetector(
      onTap: () {},
      child: Column(
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
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        color: MyColors.primaryColor,
                        borderRadius: BorderRadius.circular(100)),
                    child: Center(
                      child: InkWell(
                        onTap: () {},
                        child: const Icon(
                          Icons.edit_note_sharp,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ))
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

    Widget itemSetting(String title, List<Item> items) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: AppText(
                text: title,
                isBold: true,
                size: 18,
                color: Colors.grey,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        items[index].onTap();
                      },
                      leading: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(1000),
                          ),
                          child: Icon(
                            items[index].icon,
                            color: MyColors.primaryColor,
                          )),
                      title: AppText(
                        text: items[index].title,
                        size: 16,
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 3,
                      child: Divider(),
                    );
                  },
                  itemCount: items.length),
            ),
          ],
        );

    return Scaffold(
      backgroundColor: const Color(0xFFf5f5f5),
      body: (controller.user != null)
          ? SingleChildScrollView(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Center(child: profile),
                const SizedBox(
                  height: 10,
                ),
                itemSetting('', [
                  Item(
                      icon: Icons.person_2_outlined,
                      title: 'Thông tin tài khoản',
                      onTap: () {
                        Get.toNamed(RoutesConst.info);
                      }),
                  Item(
                      icon: Icons.password_outlined,
                      title: 'Đổi mật khẩu',
                      onTap: () {
                        Get.toNamed(RoutesConst.changePass);
                      }),
                  Item(
                      icon: Icons.card_travel_outlined,
                      title: 'Đơn hàng của tôi',
                      onTap: () {
                        Get.toNamed(RoutesConst.myOrder);
                      }),
                  Item(
                      icon: Icons.contact_emergency_outlined,
                      title: 'Liên hệ',
                      onTap: () {
                        Get.toNamed(RoutesConst.contact);
                      }),
                  Item(
                      icon: Icons.logout,
                      title: 'Đăng xuất',
                      onTap: () {
                        HomeController.instants.logout();
                      }),
                ]),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AppText(
                          text: 'Phiên bản',
                          color: Colors.grey.withOpacity(0.8),
                        ),
                      ),
                      Expanded(
                        child: AppText(
                          textAlign: TextAlign.right,
                          text: '1.0',
                          color: Colors.grey.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ))
          : Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: AppButton(
                  onPressed: () {
                    Get.toNamed(RoutesConst.login);
                  },
                  text: 'Đăng nhập',
                  isResponsive: true,
                  isShadow: false,
                ),
              ),
            ),
    );
  }
}

class Item {
  IconData icon;
  String title;
  Function() onTap;

  Item({required this.icon, required this.title, required this.onTap});
}
