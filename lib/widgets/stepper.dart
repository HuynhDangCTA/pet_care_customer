import 'package:flutter/material.dart';
import 'package:pet_care_customer/core/colors.dart';

class MyStepper extends StatefulWidget {
  final List<MyStep> steps;
  int currentStep;
  final Function(int) onStepTapped;

  MyStepper(
      {super.key,
      required this.steps,
      this.currentStep = 0,
      required this.onStepTapped});

  @override
  State<MyStepper> createState() => _MyStepperState();
}

class _MyStepperState extends State<MyStepper> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          width: size.width,
          height: 50,
          // margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0xFFA3A3A3).withOpacity(0.2),
          ),
          child: Row(
            children: List.generate(widget.steps.length, (index) {
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    widget.onStepTapped(index);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    decoration: BoxDecoration(
                      color: (widget.steps[index].isActive == true)
                          ? MyColors.primaryColor.withOpacity(0.8)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Text(
                      widget.steps[index].title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: (widget.steps[index].isActive == true)
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: (widget.steps[index].isActive == true)
                            ? Colors.white
                            : Colors.grey.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        )
      ],
    );
  }
}

class MyStep {
  String title;
  bool? isActive;

  MyStep({required this.title, this.isActive});
}
