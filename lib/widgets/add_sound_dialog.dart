import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sounds_of_rpg/entities/category.dart';
import 'package:sounds_of_rpg/entities/sound.dart';
import 'package:sounds_of_rpg/models/icons.dart';
import 'package:uuid/uuid.dart';

class AddSoundDialog extends StatefulWidget {
  late Category selectedCategory;
  AddSoundDialog({Key? key, required this.selectedCategory}) : super(key: key);

  @override
  State<AddSoundDialog> createState() => _AddSoundDialogState();
}

class _AddSoundDialogState extends State<AddSoundDialog> {
  SoundDto? sound;
  String? _name;
  String _iconSearch = '';
  IconData? _selectedIcon;
  PlatformFile? _selectedFile;

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
            TextButton(
              onPressed: () async {
                var result = await FilePicker.platform.pickFiles();
                if (result == null || result.count < 1) return;
                setState(() {
                  _selectedFile = result.files.first;
                });
              },
              child: const Text('Pick file'),
            ),
            Text(
              _selectedFile == null ? 'No file selected' : _selectedFile!.name,
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
              height: 275,
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
              if (_name == null || _name!.isEmpty || _selectedFile == null) {
                return;
              }

              sound = SoundDto(
                id: const Uuid().v4(),
                categoryId: widget.selectedCategory.id,
                name: '',
                iconCode: 0,
                iconFontFamily: '',
                path: _selectedFile!.path!,
              );
              Navigator.pop(context, sound);
            },
            child: const Text('OK'),
          ),
        ],
      );
}
