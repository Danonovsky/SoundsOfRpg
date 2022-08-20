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
  String _iconSearch = '';
  IconData? _selectedIcon;
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
              onChanged: (value) {
                setState(() {
                  _iconSearch = value;
                });
              },
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Search',
              ),
            ),
            Icon(_selectedIcon),
            Container(
              height: 300,
              width: 300,
              child: GridView.count(
                crossAxisCount: 5,
                children: allIcons.entries
                    .where((element) => element.key.contains(_iconSearch))
                    .map((e) => IconButton(
                          onPressed: () {
                            setState(() {
                              _selectedIcon = e.value;
                            });
                          },
                          icon: Icon(e.value),
                        ))
                    .toList(),
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
              IconData icon = _selectedIcon ?? Icons.abc;
              category = Category(
                id: const Uuid().v4(),
                name: _name!,
                iconCode: icon.codePoint,
                iconFontFamily: icon.fontFamily!,
              );
              Navigator.pop(context, category);
            },
            child: const Text('OK'),
          ),
        ],
      );
}
