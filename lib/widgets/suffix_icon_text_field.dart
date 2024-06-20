import 'package:flutter/material.dart';

class SuffixIconTextField extends StatelessWidget {
  const SuffixIconTextField({
    super.key,
    required this.textField,
    this.icon = const Icon(Icons.send_sharp),
    this.padding = const EdgeInsets.all(8),
  });
  final TextField textField;
  final Icon icon;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          textField,
          Positioned(bottom: 18, right: 18, child: icon),
        ],
      ),
    );
  }
}
