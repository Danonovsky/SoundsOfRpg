import 'package:flutter/material.dart';

class IconButtonWithPadding extends StatelessWidget {
  const IconButtonWithPadding({
    Key? key,
    required this.click,
    required this.icon,
    required this.padding,
  }) : super(key: key);
  final Function click;
  final EdgeInsets padding;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: IconButton(
        onPressed: () => click(),
        icon: icon,
      ),
    );
  }
}
