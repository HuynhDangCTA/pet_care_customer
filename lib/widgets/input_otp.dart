import 'package:flutter/material.dart';
import 'package:pet_care_customer/core/colors.dart';


class InputOTP extends StatefulWidget {
  final bool isFirst;
  final bool isLast;
  final TextEditingController? controller;

  const InputOTP(
      {super.key, this.controller, this.isFirst = false, this.isLast = false});

  @override
  State<InputOTP> createState() => _InputOTPState();
}

class _InputOTPState extends State<InputOTP> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 55,
      height: 55,
      child: TextFormField(
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.top,
        maxLines: 1,
        controller: widget.controller,
        maxLength: 1,
        onChanged: (value) {
          if (value.isNotEmpty && widget.isLast == false) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty && widget.isFirst == false) {
            FocusScope.of(context).previousFocus();
          }
        },
        showCursor: false,
        keyboardType: TextInputType.number,
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            height: 1),
        decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: Colors.white,
            labelStyle: const TextStyle(
                fontWeight: FontWeight.w400, color: MyColors.textColor),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: MyColors.textColor, width: 2)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: MyColors.primaryColor, width: 3))),
      ),
    );
  }
}
