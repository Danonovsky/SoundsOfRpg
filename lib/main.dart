import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sounds_of_rpg/entities/category.dart';
import 'package:sounds_of_rpg/widgets/sidebar.dart';
import 'package:sounds_of_rpg/widgets/sound_tile.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WindowManager.instance.ensureInitialized();
  await WindowManager.instance.setResizable(false);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      const MyHomePage(title: 'Flutter Demo Home Page');
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String _useLightModePrefsName = 'useLightMode';
  List<Category> _categories = [];
  int _selectedIndex = 0;
  bool _useLightMode = true;
  late SharedPreferences prefs;

  _MyHomePageState() {
    SharedPreferences.getInstance().then((value) {
      prefs = value;
      var lightModeFromPrefs = prefs.getBool(_useLightModePrefsName);
      if (lightModeFromPrefs == null) return;
      setState(() {
        _useLightMode = lightModeFromPrefs;
      });
    });
    loadCategories();
  }

  Brightness get brightness =>
      _useLightMode ? Brightness.light : Brightness.dark;
  ThemeMode get themeMode => _useLightMode ? ThemeMode.light : ThemeMode.dark;

  void updateLightMode() async {
    setState(() {
      _useLightMode = !_useLightMode;
    });
    var result = await prefs.setBool(_useLightModePrefsName, _useLightMode);
  }

  void changeDestination(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  loadCategories() async {
    var directory = Directory('storage');
    if (await directory.exists() == false) {
      directory = await Directory('storage').create();
    }
    var jsonFile = File('storage/categories.json');
    if (await jsonFile.exists() == false) {
      jsonFile = await File('storage/categories.json').create();
      await jsonFile.writeAsString('[]');
    }
    var jsonString = await jsonFile.readAsString();
    var categories = jsonDecode(jsonString) as List<dynamic>;
    for (var entity in categories) {
      var category = Category.fromJson(entity);
      setState(() {
        _categories.add(category);
      });
    }
  }

  saveCategories() async {
    var directory = Directory('storage');
    if (await directory.exists() == false) {
      directory = await Directory('storage').create();
    }
    var jsonFile = File('storage/categories.json');
    if (await jsonFile.exists() == false) {
      jsonFile = await File('storage/categories.json').create();
      await jsonFile.writeAsString('[]');
    }
    var jsonString = jsonEncode(_categories);
    await jsonFile.writeAsString(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: themeMode,
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
        brightness: brightness,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sounds of RPG'),
          elevation: 0.5,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: IconButton(
                onPressed: saveCategories,
                icon: const Icon(Icons.save),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: IconButton(
                onPressed: updateLightMode,
                icon: Icon(_useLightMode ? Icons.dark_mode : Icons.light_mode),
              ),
            ),
          ],
        ),
        body: Row(
          children: [
            Sidebar(
              selectedIndex: _selectedIndex,
              categories: _categories,
              changeDestination: changeDestination,
            ),
            Expanded(
              child: Center(
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 5,
                        children: List.generate(
                            100, (index) => SoundTile(title: '$index')),
                      ),
                    ),
                    Text('$_selectedIndex'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
