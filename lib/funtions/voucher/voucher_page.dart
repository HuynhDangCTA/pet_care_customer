import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care_customer/core/colors.dart';
import 'package:pet_care_customer/funtions/voucher/voucher_controller.dart';
import 'package:pet_care_customer/model/voucher.dart';
import 'package:pet_care_customer/util/date_util.dart';
import 'package:pet_care_customer/util/number_util.dart';
import 'package:pet_care_customer/widgets/app_text.dart';
import 'package:pet_care_customer/widgets/card_control.dart';

class VoucherPage extends GetView<VoucherController> {
  const VoucherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(() => ListView.builder(
              itemCount: controller.vouchers.value.length,
              itemBuilder: (context, index) {
                Voucher voucher = controller.vouchers[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    image: const DecorationImage(
                                        image: AssetImage('images/gift.jpg'),
                                        fit: BoxFit.cover)),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      text: '${voucher.code} - ${voucher.name}',
                                      isBold: true,
                                      maxLines: 2,
                                      color: MyColors.primaryColor,
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    AppText(
                                        text: 'Giảm giá: ${voucher.discount}%'),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    AppText(
                                        maxLines: 2,
                                        text: 'Điều kiện hóa đơn trên '
                                            '${NumberUtil.formatCurrency(voucher.condition)}'),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    AppText(
                                        text:
                                            '${DateTimeUtil.formatDate(voucher.fromDate!)}'
                                            ' - ${DateTimeUtil.formatDate(voucher.toDate!)}')
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (!voucher.isSave) {
                            await controller.saveVoucher(voucher);
                          }
                        },
                        child: Container(
                          height: 180,
                          width: 50,
                          decoration: BoxDecoration(
                              color: (!voucher.isSave &&
                                      voucher.used < voucher.amount!)
                                  ? Colors.green
                                  : (voucher.isSave &&
                                          voucher.used < voucher.amount!)
                                      ? Colors.grey
                                      : Colors.red,
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10))),
                          child: Center(
                            child: AppText(
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              text: (!voucher.isSave &&
                                      voucher.used < voucher.amount!)
                                  ? 'Lưu'
                                  : (voucher.isSave &&
                                          voucher.used < voucher.amount!)
                                      ? 'Đã lưu'
                                      : 'Hết',
                              color: Colors.white,
                              isBold: true,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            )));
  }
}
