import 'package:flutter/material.dart';

class StepperBar extends StatelessWidget {
  const StepperBar();
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          5,
          (i) => Container(
            width: 24,
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: i < 2 ? Colors.white : Colors.white24,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      );
}