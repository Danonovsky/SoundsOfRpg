import 'package:flutter/material.dart';
import 'package:sounds_of_rpg/entities/sound.dart';
import 'package:sounds_of_rpg/models/icons.dart';
import 'package:uuid/uuid.dart';

class AddSoundDialog extends StatefulWidget {
  const AddSoundDialog({Key? key}) : super(key: key);

  @override
  State<AddSoundDialog> createState() => _AddSoundDialogState();
}

class _AddSoundDialogState extends State<AddSoundDialog> {
  Sound? sound;
  String? _name;
  String _iconSearch = '';
  IconData? _selectedIcon;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Add sound'),
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
            SizedBox(
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
              sound = Sound(
                id: const Uuid().v4(),
                categoryId: const Uuid().v4(),
                name: '',
                iconCode: 0,
                iconFontFamily: '',
              );
              Navigator.pop(context, sound);
            },
            child: const Text('OK'),
          ),
        ],
      );
}
