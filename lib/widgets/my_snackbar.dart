import 'package:flutter/material.dart';
import 'package:smart_snackbars/smart_snackbars.dart';

void launchSnackBar(BuildContext context, String text, Color color) {
  SmartSnackBars.showCustomSnackBar(
    context: context,
    persist: false,
    duration: const Duration(seconds: 2),
    animationCurve: Curves.bounceOut,
    child: Container(
      decoration: BoxDecoration(
        //color: const Color.fromARGB(255, 116, 160, 118),
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Row(
        children: [
          const SizedBox(
            width: 5,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.2),
            ),
            child: const Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}
