
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_text.dart';

class EmptyDataWidget extends StatelessWidget {
  const EmptyDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: Get.width,
      child: Column(
        children: [
          Expanded(child: Image.asset('images/empty_data.png')),
          const Expanded(child: AppText(text: 'Không có dữ liệu', color: Colors.grey, size: 16,))
        ],
      ),
    );
  }
}
