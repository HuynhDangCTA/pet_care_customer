import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pet_care_customer/core/colors.dart';
import 'package:pet_care_customer/routes/routes_const.dart';
import 'package:pet_care_customer/widgets/app_text.dart';

import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed(RoutesConst.cart);
              },
              icon: SizedBox(
                width: 40,
                height: 40,
                child: Stack(
                  children: [
                    const Positioned(
                        bottom: 0,
                        top: 0,
                        right: 9,
                        child: Icon(Icons.shopping_cart)),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        constraints:
                            const BoxConstraints(minWidth: 20, minHeight: 20),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(1000)),
                        child: Center(
                          child: Obx(() => AppText(
                                text: controller.itemCart.value.toString(),
                                color: Colors.white,
                                size: 9,
                              )),
                        ),
                      ),
                    )
                  ],
                ),
              ))
        ],
        title: Obx(
          () => Text(
            controller.titleCustomer[controller.currentPage.value],
          ),
        ),
      ),
      body: Obx(() => controller.pagesCustomer[controller.currentPage.value]),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
              backgroundColor: Colors.white,
              elevation: 10,
              showUnselectedLabels: true,
              selectedItemColor: MyColors.primaryColor,
              unselectedItemColor: MyColors.textColor,
              currentIndex: controller.currentPage.value,
              onTap: (value) {
                controller.changePage(value);
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.paid_rounded), label: 'Sản phẩm'),
                BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.spa), label: 'Dịch vụ'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.discount), label: 'Voucher'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.people_alt), label: 'Cá nhân'),
              ])),
    );
  }
}
