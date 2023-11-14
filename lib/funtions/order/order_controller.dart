import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care_customer/core/colors.dart';
import 'package:pet_care_customer/core/constants.dart';
import 'package:pet_care_customer/funtions/cart/cart_controller.dart';
import 'package:pet_care_customer/funtions/home/home_controller.dart';
import 'package:pet_care_customer/funtions/order/order_status.dart';
import 'package:pet_care_customer/funtions/product/product_contronller.dart';
import 'package:pet_care_customer/model/order_model.dart';
import 'package:pet_care_customer/model/product.dart';
import 'package:pet_care_customer/model/user_response.dart';
import 'package:pet_care_customer/model/voucher.dart';
import 'package:pet_care_customer/network/firebase_helper.dart';
import 'package:pet_care_customer/routes/routes_const.dart';
import 'package:pet_care_customer/services/send_notify.dart';
import 'package:pet_care_customer/util/date_util.dart';
import 'package:pet_care_customer/util/dialog_util.dart';
import 'package:pet_care_customer/util/number_util.dart';
import 'package:pet_care_customer/widgets/app_button.dart';
import 'package:pet_care_customer/widgets/app_text.dart';

class OrderController extends GetxController {
  RxString address = 'Nhà'.obs;
  UserResponse? user = HomeController.instants.userCurrent;
  List<Product> products = Get.arguments;
  Rx<Voucher?> voucher = Rx(null); // lưu voucher đã chọn
  List<Voucher> vouchers = [];
  Rx<Voucher?> voucherSelectd =
      Rx(null); // sử dụng cho chọn voucher ở bottom sheet
  RxInt discountVoucher = 0.obs;
  int totalMoney = 0;
  int discountMoney = 0;
  RxInt ship = 15000.obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    await getAllVoucher();
  }

  int getTotalMoney() {
    int total = 0;
    for (var product in products) {
      total += product.sold * product.price!;
    }
    totalMoney = total;
    return total;
  }

  int getDiscount() {
    int total = 0;
    for (var product in products) {
      debugPrint('price: ${product.discount}');
      total +=
          (product.sold * product.price! * (product.discount! / 100)).round();
    }
    discountMoney = total;
    return total;
  }

  Future getAllVoucher() async {
    await FirebaseHelper.getVoucherUser(user!.id!, DateTime.now())
        .then((value) {
      if (value.docs.isNotEmpty) {
        for (var doc in value.docs) {
          Voucher voucher = Voucher.fromMap(doc.data() as Map<String, dynamic>);
          voucher.id = doc.id;
          if (voucher.fromDate!.isBefore(DateTime.now()) &&
              voucher.used != -10) {
            vouchers.add(voucher);
          }
        }
      }
    });
  }

  Future orderCart() async {
    DialogUtil.showLoading();
    int pay = ((totalMoney - discountMoney) -
            (((totalMoney - discountMoney) * (discountVoucher.value)) / 100) +
            ship.value)
        .round();
    int voucherMoney = 0;
    if (voucher.value != null) {
      voucherMoney =
          ((totalMoney - discountMoney) * (voucher.value!.discount!) / 100)
              .round();
    }

    OrderModel order = OrderModel(
      address: address.value,
      product: products,
      voucher: voucher.value,
      orderBy: user,
      totalMoney: totalMoney,
      discountMoney: discountMoney,
      shipFee: ship.value,
      payMoney: pay,
      status: OrderStatusConst.choXacNhan,
      voucherMoney: voucherMoney,
    );
    String docId = '';
    //  tạo order
    await FirebaseHelper.newOrder(order).then((value) async {
      // thêm customer
      docId = value.id;
      await FirebaseHelper.addCustomerInOrder(user!, value.id);
    });
    if (voucher.value != null) {
      await FirebaseHelper.addVoucherInOrder(voucher.value!, docId)
          .then((value) async {
        await FirebaseHelper.deleteVoucherInUser(voucher.value!.id!, user!.id!);
      });
    }
    // thêm product vào
    for (var product in products) {
      await FirebaseHelper.addProductInOrder(product, docId)
          .then((value) async {
        // update lại số lương sản phẩm
        int amount = product.amount - product.sold;
        await FirebaseHelper.updateAmountProduct(product.id!, amount);
        // update lại số lượng đã bán
        await FirebaseHelper.getProductFromID(product.id!).then((value) async {
          if (value.exists) {
            int sold = value.get(Constants.sold);
            sold += product.sold;
            await FirebaseHelper.updateSoldProduct(product.id!, sold);
          }
        });
        await FirebaseHelper.deleteProductFromCart(user!.id!, product.id!);
      });
    }
    DialogUtil.hideLoading();
    DialogUtil.showOrderSuccess();

    List<String> tokens = [];
    await FirebaseHelper.getAllManager().then((value) {
      if (value.docs.isNotEmpty) {
        for (var doc in value.docs) {
          UserResponse response =
              UserResponse.fromMap(doc.data() as Map<String, dynamic>);
          tokens.add(response.token!);
        }
      }
    });

    SendNotify.sendNotifyFromMultipleUser(
        'Có đơn hàng mới',
        'Đơn hàng vừa được ${user!.name} tạo. Hãy vào để xử lý đơn hàng!',
        tokens);
    Future.delayed(
      const Duration(seconds: 1),
      () {
        Get.back();
        Get.back();
        Get.back();
        ProductController.instance.getAllProducts();
      },
    );
  }

  void showBottomSheet() {
    Get.bottomSheet(
        Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10), topLeft: Radius.circular(10))),
          padding: const EdgeInsets.all(10.0),
          width: Get.width,
          child: Stack(
            children: [
              Column(
                children: [
                  const AppText(
                    text: 'Chọn Voucher',
                    isBold: true,
                    color: MyColors.primaryColor,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SingleChildScrollView(
                    child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          Voucher voucher = vouchers[index];
                          return Obx(() => InkWell(
                                onTap: () {
                                  if (voucher.condition! <=
                                      (totalMoney - discountMoney)) {
                                    voucherSelectd.value = voucher;
                                  }
                                },
                                child: Stack(
                                  children: [
                                    Row(
                                      children: [
                                        Radio(
                                          value: voucher,
                                          groupValue: voucherSelectd.value,
                                          onChanged: (value) {
                                            if (voucher.condition! <=
                                                (totalMoney - discountMoney)) {
                                              voucherSelectd.value = value!;
                                            }
                                          },
                                        ),
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'images/gift.jpg'))),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AppText(
                                              text:
                                                  '${voucher.code} - ${voucher.name}',
                                              isBold: true,
                                              maxLines: 2,
                                              color: MyColors.primaryColor,
                                            ),
                                            AppText(
                                                text:
                                                    'Giảm giá: ${voucher.discount}%'),
                                            AppText(
                                                maxLines: 2,
                                                text: 'Điều kiện hóa đơn trên '
                                                    '${NumberUtil.formatCurrency(voucher.condition)}'),
                                          ],
                                        )
                                      ],
                                    ),
                                    (voucher.condition! >
                                            (totalMoney - discountMoney))
                                        ? Container(
                                            width: Get.width,
                                            height: 80,
                                            color: Colors.black26,
                                            child: const Center(
                                                child: AppText(
                                              text: "Không đủ điều kiện",
                                              color: Colors.white,
                                            )),
                                          )
                                        : Container()
                                  ],
                                ),
                              ));
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        itemCount: vouchers.length),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                ],
              ),
              Positioned(
                  top: 0,
                  right: 0,
                  child: InkWell(
                      onTap: () {
                        voucherSelectd.value = voucher.value;
                        Get.back();
                      },
                      child: const Icon(Icons.close))),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AppButton(
                  onPressed: () {
                    if (voucherSelectd.value != null) {
                      voucher.value = voucherSelectd.value;
                      discountVoucher.value = voucherSelectd.value!.discount!;
                    }
                    Get.back();
                  },
                  isResponsive: true,
                  text: 'Chọn',
                  isShadow: false,
                ),
              ),
            ],
          ),
        ),
        isDismissible: false,
        backgroundColor: Colors.white);
  }
}
