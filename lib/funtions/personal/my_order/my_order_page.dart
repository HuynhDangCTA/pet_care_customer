import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care_customer/core/colors.dart';
import 'package:pet_care_customer/funtions/order/order_status.dart';
import 'package:pet_care_customer/funtions/personal/my_order/my_order_controller.dart';
import 'package:pet_care_customer/model/order_model.dart';
import 'package:pet_care_customer/routes/routes_const.dart';
import 'package:pet_care_customer/util/number_util.dart';
import 'package:pet_care_customer/widgets/app_button.dart';
import 'package:pet_care_customer/widgets/app_text.dart';

class MyOrderPage extends GetView<MyOrderController> {
  const MyOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn hàng của tôi'),
      ),
      body: Obx(() => ListView.builder(
            itemCount: controller.orders.value.length,
            itemBuilder: (context, index) {
              OrderModel order = controller.orders[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(RoutesConst.myOrderDetail, arguments: order);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: AppText(
                              text: '${order.product!.length} sản phẩm',
                              isBold: true,
                            )),
                            Container(
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    8,
                                  ),
                                  color:
                                      OrderStatusConst.getColor(order.status!)),
                              child: AppText(
                                text: order.status ?? '',
                                color: Colors.white,
                                isBold: true,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'images/product_demo.jpg'))),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: SizedBox(
                                width: Get.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      text: order.product!.first.name ?? '',
                                      size: 14,
                                      maxLines: 2,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AppText(
                                          text: NumberUtil.formatCurrency(
                                              order.product!.first.price),
                                          size: 14,
                                        ),
                                        AppText(
                                          text: 'x${order.product!.first.sold}',
                                          size: 14,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Center(
                            child: Icon(
                          Icons.more_horiz_rounded,
                          color: MyColors.textColor,
                        )),
                        const Divider(),
                        Row(
                          children: [
                            const Expanded(
                                child: AppText(
                              text: 'Thành tiền',
                              isBold: true,
                            )),
                            Expanded(
                                child: AppText(
                              text: NumberUtil.formatCurrency(order.payMoney),
                              textAlign: TextAlign.end,
                            ))
                          ],
                        ),
                        const Divider(),
                        (order.status == OrderStatusConst.choXacNhan)
                            ? AppButton(
                                onPressed: () async {
                                  await controller.cancelOrder(order);
                                },
                                text: 'Hủy đơn',
                                width: 150,
                                height: 40,
                                backgroundColor: Colors.red,
                                isShadow: false,
                              )
                            : Container()
                      ],
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }
}
