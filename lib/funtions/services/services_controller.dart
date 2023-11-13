
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care_customer/model/service.dart';
import 'package:pet_care_customer/network/firebase_helper.dart';
import 'package:pet_care_customer/util/dialog_util.dart';

class ServiceController extends GetxController {
  RxList<ServiceModel> services = RxList();

  @override
  void onReady() async {
    await getAllService();
    super.onReady();
  }

  Future getAllService() async {
    DialogUtil.showLoading();
    await FirebaseHelper.getAllServices().then((value) {
      if (value.docs.isNotEmpty) {
        List<ServiceModel> result = [];

        for (var doc in value.docs) {
          ServiceModel service =
          ServiceModel.fromDocument(doc.data() as Map<String, dynamic>);
          service.id = doc.id;
          result.add(service);
        }
        services.value = result;
        DialogUtil.hideLoading();
      }
    });
  }
}