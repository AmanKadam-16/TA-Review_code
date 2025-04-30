import 'package:flutter/material.dart';

class HelpTooltipButton extends StatelessWidget {
  final String tooltipMessage; // Tooltip message to display
  final Color backgroundColor; // Background color for the button
  final Color iconColor; // Color of the question mark icon
  final double size; // Size of the button

  /// Constructs a [HelpTooltipButton] widget.
  ///
  /// The [tooltipMessage] parameter is required and specifies the message to display in the tooltip.
  ///
  /// The [backgroundColor] and [iconColor] parameters are optional and specify the background color of the button and the color of the question mark icon, respectively. The default values are `const Color(0xFF009688)` and `Colors.white`.
  // #region Constructor  /// The [size] parameter is optional and specifies the size (diameter) of the circular button. The default value is `32.0`.
  
  const HelpTooltipButton({
    super.key,
    required this.tooltipMessage,
    this.backgroundColor = const Color(0xFF009688), // Default background color
    this.iconColor = Colors.white, // Default icon color
    this.size = 32.0, // Default size (circle diameter)
  });
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltipMessage,
      child: InkWell(
        borderRadius: BorderRadius.circular(size / 2),
        onTap: () {
          // Show an alert dialog with the tooltip message
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Information'),
                backgroundColor: Colors.white, // White background color
                content: Text(
                  tooltipMessage,
                  style: TextStyle(color: Colors.black), // Black text color
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text(
                      "Close",
                      style: TextStyle(color: Color(0xFF009688)),
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: backgroundColor, // Button background color
            shape: BoxShape.circle, // Circular shape
          ),
          child: Icon(
            Icons.info,
            size: size / 2, // Icon size
            color: iconColor, // Icon color
          ),
        ),
      ),
    );
  }
}