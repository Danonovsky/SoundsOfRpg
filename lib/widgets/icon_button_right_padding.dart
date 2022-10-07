import 'package:flutter/material.dart';

class IconButtonRightPadding extends StatelessWidget {
  const IconButtonRightPadding({Key? key, required this.saveCategories})
      : super(key: key);
  final Function saveCategories;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: IconButton(
        onPressed: () => saveCategories,
        icon: const Icon(Icons.save),
      ),
    );
  }
}
