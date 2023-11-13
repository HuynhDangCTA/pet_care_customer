import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NumberSelected extends StatefulWidget {
  final Function increase;
  final Function decrease;
  final TextEditingController textController;

  NumberSelected(
      {super.key,
      required this.increase,
      required this.decrease,
      required this.textController});

  @override
  State<NumberSelected> createState() => _NumberSelectedState();
}

class _NumberSelectedState extends State<NumberSelected> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              widget.decrease();
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                  border:
                      Border(right: BorderSide(color: Colors.grey, width: 1))),
              child: const Icon(
                FontAwesomeIcons.minus,
                size: 15,
              ),
            ),
          ),
          SizedBox(
            height: 30,
            width: 40,
            child: TextFormField(
              onTapOutside: (value) {
                FocusScope.of(context).unfocus();
              },
              textAlign: TextAlign.center,
              maxLines: 1,
              keyboardType: TextInputType.number,
              controller: widget.textController,
              decoration: const InputDecoration(border: InputBorder.none),
              style: const TextStyle(fontSize: 15, color: Colors.black),
            ),
          ),
          GestureDetector(
            onTap: () {
              widget.increase();
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                  border:
                      Border(left: BorderSide(color: Colors.grey, width: 1))),
              child: const Icon(
                Icons.add,
                size: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
