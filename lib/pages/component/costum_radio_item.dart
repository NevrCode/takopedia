import 'package:flutter/material.dart';

class RadioButtonWidget extends StatefulWidget {
  const RadioButtonWidget({super.key});

  @override
  State<RadioButtonWidget> createState() => _RadioButtonWidgetState();
}

class _RadioButtonWidgetState extends State<RadioButtonWidget> {
  int value = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CostumRadioButtonWidget("Card", 0),
        CostumRadioButtonWidget("Qris", 1),
      ],
    );
  }

  Widget CostumRadioButtonWidget(String text, int index) {
    return TextButton(
      onPressed: () {
        setState(() {
          value = index;
        });
      },
      style: ButtonStyle(
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          backgroundColor: MaterialStatePropertyAll(value == index
              ? Color.fromARGB(255, 255, 255, 255)
              : const Color.fromARGB(255, 212, 212, 212))),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(
              color: (value == index)
                  ? Color.fromARGB(255, 0, 0, 0)
                  : const Color.fromARGB(255, 105, 105, 105),
            ),
          ),
        ],
      ),
    );
  }
}
