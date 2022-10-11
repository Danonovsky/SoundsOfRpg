import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sounds_of_rpg/entities/category.dart';
import 'package:sounds_of_rpg/entities/sound.dart';
import 'package:sounds_of_rpg/widgets/add_sound_dialog.dart';
import 'package:sounds_of_rpg/widgets/sound_tile.dart';

class MainSection extends StatefulWidget {
  MainSection({Key? key, required this.sounds, required this.selectedCategory})
      : super(key: key);

  late List<Sound> sounds;
  late Category? selectedCategory;

  @override
  State<MainSection> createState() => _MainSectionState();
}

class _MainSectionState extends State<MainSection> {
  void showAddDialog() async {
    var sound = await showDialog<SoundDto>(
      context: context,
      builder: (context) => AddSoundDialog(
        selectedCategory: widget.selectedCategory!,
      ),
    );
    if (sound == null) return;
    var file = File(sound.path);
    var newFile = File('storage/${sound.categoryId}/${sound.id}');
    var data = await file.readAsBytes();
    await newFile.create();
    await newFile.writeAsBytes(data);
    /*var directory = Directory('storage/${category.id}');
    await directory.create(recursive: true);

    _storageService.saveCategories(widget.categories);

    setState(() {
      widget.categories.add(category);
    })*/
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          children: [
            Visibility(
              visible: widget.selectedCategory != null,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: IconButton(
                    onPressed: () {
                      showAddDialog();
                    },
                    icon: const Icon(Icons.add),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 5,
                children: widget.sounds
                    .where(
                      (element) {
                        if (widget.selectedCategory == null) return true;
                        return element.categoryId ==
                            widget.selectedCategory!.id;
                      },
                    )
                    .map(
                      (e) => SoundTile(title: e.name),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}