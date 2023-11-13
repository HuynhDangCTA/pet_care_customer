import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care_customer/funtions/services/services_controller.dart';
import 'package:pet_care_customer/routes/routes_const.dart';
import 'package:pet_care_customer/widgets/card_control.dart';
import 'package:pet_care_customer/widgets/empty_data.dart';
import 'package:pet_care_customer/widgets/service_card.dart';

class ServicePage extends GetView<ServiceController> {
  const ServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget serviceWidget = Obx(() => (controller.services.isNotEmpty)
        ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.services.length,
            itemBuilder: (context, index) {
              return ServiceCard(
                service: controller.services[index],
              );
            },
          )
        : const Center(child: EmptyDataWidget()));

    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CardControl(
                    image: 'images/ic_cat_box.png',
                    text: 'Phòng khách sạn',
                    onTap: () {
                      Get.toNamed(RoutesConst.room);
                    },
                  ),
                ],
              ),
            ),
            serviceWidget
          ],
        ),
      ),
    ));
  }
}
