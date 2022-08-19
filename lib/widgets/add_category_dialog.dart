import 'package:flutter/material.dart';
import 'package:sounds_of_rpg/entities/category.dart';
import 'package:sounds_of_rpg/models/icons.dart';
import 'package:uuid/uuid.dart';

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({Key? key}) : super(key: key);

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  Category? category;
  String? _name;
  static var icons = allIcons;

  static String _display(MapEntry<String, IconData> icon) => icon.key;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Add category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) => _name = value,
              autofocus: true,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Name',
              ),
            ),
            TextField(
              onChanged: (value) {},
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Icon',
              ),
            ),
            SingleChildScrollView(
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 5,
                children: List.generate(100, (index) => Icon(Icons.abc)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_name == null || _name!.isEmpty) return;
              category = Category(
                id: const Uuid().v4(),
                name: _name!,
                icon: Icons.abc,
              );
              Navigator.pop(context, category);
            },
            child: const Text('OK'),
          ),
        ],
      );
}
