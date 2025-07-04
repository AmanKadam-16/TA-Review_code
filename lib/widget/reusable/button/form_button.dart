import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomButtons extends StatelessWidget {
  final VoidCallback onSavePressed;
  final VoidCallback onCancelPressed;
  final Color saveButtonColor;
  final Color cancelButtonColor;
  final Color textColor;

  const CustomButtons({
    super.key,
    required this.onSavePressed,
    required this.onCancelPressed,
    this.saveButtonColor = const Color.fromARGB(255, 62, 237, 27),
    this.cancelButtonColor = const Color.fromARGB(255, 247, 145, 145),
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onCancelPressed,
              hoverColor: cancelButtonColor.withOpacity(0.4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                decoration: const BoxDecoration(
                  // Border removed
                ),
                child: Text(
                  'Clear',
                  style: TextStyle(color: textColor),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onSavePressed,
              hoverColor: saveButtonColor.withOpacity(0.4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                decoration: const BoxDecoration(
                  // Border removed
                ),
                child: Text(
                  'Save',
                  style: TextStyle(color: textColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}