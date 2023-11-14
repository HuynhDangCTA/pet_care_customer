import 'dart:async';

import 'package:get/get.dart';
import 'package:pet_care_customer/funtions/home/home_controller.dart';
import 'package:pet_care_customer/model/user_response.dart';
import 'package:pet_care_customer/model/voucher.dart';
import 'package:pet_care_customer/network/firebase_helper.dart';
import 'package:pet_care_customer/routes/routes_const.dart';
import 'package:pet_care_customer/util/dialog_util.dart';

class VoucherController extends GetxController {
  RxList<Voucher> vouchers = <Voucher>[].obs;
  UserResponse? user = HomeController.instants.userCurrent;
  List<Voucher> voucherSaved = [];
  late StreamSubscription voucherListener;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    await getVoucher();
    listenVoucher();
  }

  Future saveVoucher(Voucher voucher) async {
    if (user == null) {
      Get.toNamed(RoutesConst.login);
      return;
    }
    if (voucher.used >= voucher.amount!) {
      DialogUtil.showSnackBar('Voucher đã hết');
      return;
    }
    await FirebaseHelper.saveVoucher(voucher, user!.id!).then((value) async {
      int used = voucher.used + 1;
      voucher.isSave = true;
      voucherSaved.add(voucher);
      await FirebaseHelper.updateVoucher(used, voucher.id!);
      DialogUtil.showSnackBar('Lưu thành công');
    });
  }

  void listenVoucher() {
    voucherListener = FirebaseHelper.listenVoucher(
      DateTime.now(),
      addEvent: (voucher) {
        if (voucher.fromDate!.isBefore(DateTime.now())) {
          bool used = false;
          if (voucherSaved.contains(voucher)) {
            voucher.isSave = true;
            if (voucherSaved[voucherSaved.indexOf(voucher)].used == -10) {
              used = true;
            }
          }
          if (!used) {
            vouchers.add(voucher);
          }
        }
      },
      modifyEvent: (voucher) {
        for (int i = 0; i < vouchers.length; i++) {
          if (vouchers[i].id == voucher.id) {
            if (voucherSaved.contains(voucher)) {
              voucher.isSave = true;
            }
            vouchers[i] = voucher;
          }
        }
        vouchers.refresh();
      },
      deleteEvent: (Voucher voucher) {
        vouchers.remove(voucher);
        vouchers.refresh();
      },
    );
  }

  Future getVoucher() async {
    if (user == null) return;
    await FirebaseHelper.getVoucherUser(user!.id!, DateTime.now())
        .then((value) {
      for (var doc in value.docs) {
        Voucher voucher = Voucher.fromMap(doc.data() as Map<String, dynamic>);
        voucher.id = doc.id;
        if (voucher.fromDate!.isBefore(DateTime.now())) {
          voucherSaved.add(voucher);
        }
      }
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    voucherListener.cancel();
  }
}
