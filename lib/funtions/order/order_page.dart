import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care_customer/core/colors.dart';
import 'package:pet_care_customer/funtions/order/order_controller.dart';
import 'package:pet_care_customer/model/product.dart';
import 'package:pet_care_customer/util/number_util.dart';
import 'package:pet_care_customer/widgets/app_button.dart';
import 'package:pet_care_customer/widgets/app_text.dart';

class OrderPage extends GetView<OrderController> {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget personalAddress = Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: MyColors.primaryColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: controller.user!.name!,
            isBold: true,
          ),
          const SizedBox(
            height: 3,
          ),
          AppText(text: controller.user!.phoneNumber!),
          const SizedBox(
            height: 3,
          ),
          AppText(
            text: controller.user!.address!,
            maxLines: 3,
          ),
        ],
      ),
    );

    Widget shopAddress = Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: MyColors.primaryColor)),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: 'Tiệm nhà Chuột',
            isBold: true,
          ),
          SizedBox(
            height: 3,
          ),
          AppText(text: '0773850202'),
          SizedBox(
            height: 3,
          ),
          AppText(
            text:
                'Số 108/42 đường 30/4, phường An Phú, quận Ninh Kiều, TP. Cần Thơ',
            maxLines: 3,
          ),
        ],
      ),
    );

    Widget cardAddress = Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: 'Địa chỉ nhận hàng',
              size: 16,
              isBold: true,
              color: MyColors.primaryColor,
            ),
            Obx(() => Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                        value: 'Nhà',
                        groupValue: controller.address.value,
                        onChanged: (value) {
                          controller.ship.value = 15000;
                          controller.address.value = value!;
                        },
                        title: const Text('Nhà'),
                      ),
                    ),
                    Expanded(
                        child: RadioListTile(
                      value: 'Shop',
                      groupValue: controller.address.value,
                      onChanged: (value) {
                        controller.address.value = value!;
                        controller.ship.value = 0;
                      },
                      title: const AppText(
                        text: 'Shop',
                      ),
                    )),
                  ],
                )),
            Obx(() => (controller.address.value == 'Nhà')
                ? personalAddress
                : shopAddress)
          ],
        ),
      ),
    );

    Widget cardProduct = Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: 'Sản phẩm',
              size: 16,
              isBold: true,
              color: MyColors.primaryColor,
            ),
            const SizedBox(
              height: 10,
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                Product product = controller.products[index];
                return Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(product.image!))),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(text: product.name ?? ''),
                            AppText(
                                text: NumberUtil.formatCurrency(product.price! *
                                    (100 - product.discount!) /
                                    100))
                          ],
                        )
                      ],
                    ),
                    Positioned(
                        bottom: 0,
                        right: 8,
                        child: AppText(
                          text: 'x${product.sold}',
                          color: Colors.grey,
                        ))
                  ],
                );
              },
              itemCount: controller.products.length,
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            )
          ],
        ),
      ),
    );

    Widget cardVoucher = Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: 'Voucher',
              size: 16,
              isBold: true,
              color: MyColors.primaryColor,
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                controller.showBottomSheet();
              },
              child: Container(
                width: Get.width,
                height: 60,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey)),
                child: Obx(() => (controller.voucher.value == null)
                    ? Image.asset('images/add_voucher.png')
                    : Center(
                        child: AppText(
                          text:
                              '${controller.voucher.value!.code!} - Giảm ${controller.voucher.value!.discount!}%',
                        ),
                      )),
              ),
            )
          ],
        ),
      ),
    );

    Widget cardMoney = Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: 'Thanh toán',
              size: 16,
              isBold: true,
              color: MyColors.primaryColor,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Expanded(child: AppText(text: 'Tổng tiên')),
                Expanded(
                    child: AppText(
                  text: NumberUtil.formatCurrency(controller.getTotalMoney()),
                  textAlign: TextAlign.end,
                ))
              ],
            ),
            const SizedBox(
              height: 3,
            ),
            Row(
              children: [
                const Expanded(child: AppText(text: 'Giảm giá')),
                Expanded(
                    child: AppText(
                  text: NumberUtil.formatCurrency(controller.getDiscount()),
                  textAlign: TextAlign.end,
                ))
              ],
            ),
            const SizedBox(
              height: 3,
            ),
            Row(
              children: [
                const Expanded(child: AppText(text: 'Voucher')),
                Expanded(
                    child: Obx(() => AppText(
                          text: NumberUtil.formatCurrency(
                              ((controller.totalMoney -
                                          controller.discountMoney) *
                                      (controller.discountVoucher.value)) /
                                  100),
                          textAlign: TextAlign.end,
                        )))
              ],
            ),
            const SizedBox(
              height: 3,
            ),
            Obx(() => (controller.address.value == 'Nhà')
                ? Row(
                    children: [
                      const Expanded(child: AppText(text: 'Phí ship')),
                      Expanded(
                          child: AppText(
                        text: NumberUtil.formatCurrency(controller.ship.value),
                        textAlign: TextAlign.end,
                      ))
                    ],
                  )
                : Container()),
            const Divider(),
            Row(
              children: [
                const Expanded(child: AppText(text: 'Thanh toán')),
                Expanded(
                    child: Obx(() => AppText(
                          text: NumberUtil.formatCurrency(
                              (controller.totalMoney -
                                      controller.discountMoney) -
                                  (((controller.totalMoney -
                                              controller.discountMoney) *
                                          (controller.discountVoucher.value)) /
                                      100) +
                                  controller.ship.value),
                          textAlign: TextAlign.end,
                        )))
              ],
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đặt hàng'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            cardAddress,
            cardProduct,
            cardVoucher,
            cardMoney,
            Padding(
              padding: const EdgeInsets.all(10),
              child: AppButton(
                onPressed: () async {
                  await controller.orderCart();
                },
                isResponsive: true,
                isShadow: false,
                text: 'Đặt hàng',
              ),
            )
          ],
        ),
      ),
    );
  }
}
