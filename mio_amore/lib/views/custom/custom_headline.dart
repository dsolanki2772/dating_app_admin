import 'package:flutter/material.dart';

class CustomHeadLine extends StatelessWidget {
  final String text;
  final Color firstPartColor;
  final Color secondPartColor;
  const CustomHeadLine({
    Key? key,
    required this.text,
    this.firstPartColor = Colors.black,
    required this.secondPartColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _textLength = text.length;
    final _firstPart = text.substring(0, _textLength ~/ 2);
    final _secondPart = text.substring(_textLength ~/ 2);

    final _textStyle = Theme.of(context)
        .textTheme
        .headline5!
        .copyWith(fontWeight: FontWeight.bold);

    return Text.rich(
      TextSpan(
        text: _firstPart,
        style: _textStyle.copyWith(color: firstPartColor),
        children: [
          TextSpan(
            text: _secondPart,
            style: _textStyle.copyWith(color: secondPartColor),
          ),
        ],
      ),
    );
  }
}
