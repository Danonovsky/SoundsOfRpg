import 'package:flutter/material.dart';
import 'package:sounds_of_rpg/entities/category.dart';
import 'package:uuid/uuid.dart';

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({Key? key}) : super(key: key);

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  Category? category;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Add category'),
        content: const Text('Category name and icon'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                category = Category(
                    id: const Uuid().v4(), name: 'Name', icon: Icons.abc);
                Navigator.pop(context, category);
              },
              child: const Text('OK')),
        ],
      );
}
