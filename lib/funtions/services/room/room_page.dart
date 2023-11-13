import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care_customer/core/colors.dart';
import 'package:pet_care_customer/funtions/services/room/room_controller.dart';
import 'package:pet_care_customer/widgets/app_text.dart';
import 'package:pet_care_customer/widgets/empty_data.dart';
import 'package:pet_care_customer/widgets/stepper.dart';

class RoomPage extends GetView<RoomController> {
  const RoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget roomCat = Obx(() => (controller.roomsCat.value.isNotEmpty)
        ? GridView.builder(
            itemCount: controller.roomsCat.value.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {},
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: (controller.roomsCat[index].isEmpty)
                            ? Colors.green
                            : Colors.red, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(controller.roomsCat[index].image!),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Obx(() => Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1000),
                                color: (controller.roomsCat[index].isEmpty)
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            )),
                      ),
                      Positioned(
                          bottom: 0,
                          left: 0,
                          child: Container(
                            width: 100,
                            height: 30,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10))),
                            child: Center(
                              child: AppText(
                                text: controller.roomsCat[index].name ?? '',
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              );
            },
          )
        : const Center(child: EmptyDataWidget()));

    Widget roomDog = Obx(() => (controller.roomsDog.value.isNotEmpty)
        ? GridView.builder(
            itemCount: controller.roomsDog.value.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 5, mainAxisSpacing: 5, crossAxisCount: 3),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {},
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: (controller.roomsDog[index].isEmpty)
                            ? Colors.green
                            : Colors.red, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(controller.roomsDog[index].image!),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1000),
                            color: (controller.roomsDog[index].isEmpty)
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ),
                      Positioned(
                          bottom: 0,
                          left: 0,
                          child: Container(
                            width: 100,
                            height: 30,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10))),
                            child: Center(
                              child: AppText(
                                text: controller.roomsDog[index].name ?? '',
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              );
            },
          )
        : const Center(child: EmptyDataWidget()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phòng khách sạn'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(1000)),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const AppText(
                        text: 'Phòng trống',
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(1000)),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const AppText(
                        text: 'Phòng đầy',
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(() => MyStepper(
                    steps: [
                      MyStep(
                          title: 'Mèo',
                          isActive: (controller.currentStep.value == 0)),
                      MyStep(
                          title: 'Cún',
                          isActive: (controller.currentStep.value == 1)),
                    ],
                    onStepTapped: (value) {
                      controller.currentStep.value = value;
                    })),
            const SizedBox(
              height: 10,
            ),
            Obx(() => (controller.currentStep.value == 0) ? roomCat : roomDog)
          ],
        ),
      ),
    );
  }
}
