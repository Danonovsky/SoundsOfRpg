import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sounds_of_rpg/entities/category.dart';
import 'package:sounds_of_rpg/services/storage_service.dart';
import 'package:sounds_of_rpg/widgets/add_category_dialog.dart';

class Sidebar extends StatefulWidget {
  int selectedIndex = 0;
  List<Category> categories;
  void Function(int) changeDestination;
  Sidebar({
    Key? key,
    required this.selectedIndex,
    required this.categories,
    required this.changeDestination,
  }) : super(key: key);

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  final StorageService _storageService = StorageService();

  void showAddDialog(BuildContext context) async {
    var category = await showDialog<Category>(
      context: context,
      builder: (context) => const AddCategoryDialog(),
    );
    if (category == null) return;
    var directory = Directory('storage/${category.id}');
    await directory.create(recursive: true);

    _storageService.saveCategories(widget.categories);

    setState(() {
      widget.categories.add(category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: widget.selectedIndex,
      onDestinationSelected: widget.changeDestination,
      extended: true,
      destinations: [
        const NavigationRailDestination(
            icon: Icon(Icons.list), label: Text('All')),
        const NavigationRailDestination(
            icon: Icon(Icons.abc), label: Text('xD')),
        ...widget.categories.map((e) => NavigationRailDestination(
            icon: Icon(
              IconData(
                e.iconCode,
                fontFamily: e.iconFontFamily,
              ),
            ),
            label: Text(e.name))),
      ],
      trailing: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            showAddDialog(context);
          }),
    );
  }
}
