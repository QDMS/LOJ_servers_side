// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  TextWidget({
    Key? key,
    required this.text,
    required this.color,
    required this.textSize,
    this.isTitle = false,
    this.maxLines = 10
  }) : super(key: key);

  final String text;
  final Color color;
  final double textSize;
  bool isTitle;
  int maxLines = 10;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      maxLines: maxLines,
      style: TextStyle(
        overflow: TextOverflow.ellipsis,
        fontSize: textSize,
        color: color,
        fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
