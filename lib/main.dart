import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sounds_of_rpg/entities/category.dart';
import 'package:sounds_of_rpg/entities/sound.dart';
import 'package:sounds_of_rpg/services/storage_service.dart';
import 'package:sounds_of_rpg/widgets/main_section.dart';
import 'package:sounds_of_rpg/widgets/icon_button_with_padding.dart';
import 'package:sounds_of_rpg/widgets/sidebar.dart';
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
  List<Sound> _sounds = [];
  final StorageService _storageService = StorageService();
  Category? _selectedCategory;
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
    _storageService.loadCategories().then((value) {
      setState(() => _categories = value);
    });
    _storageService.loadSounds().then((value) {
      setState(() => _sounds = value);
    });
  }

  Brightness get brightness =>
      _useLightMode ? Brightness.light : Brightness.dark;
  ThemeMode get themeMode => _useLightMode ? ThemeMode.light : ThemeMode.dark;

  updateLightMode() async {
    setState(() {
      _useLightMode = !_useLightMode;
    });
    await prefs.setBool(_useLightModePrefsName, _useLightMode);
  }

  void changeDestination(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedCategory =
          _selectedIndex < 2 ? null : _categories[_selectedIndex - 2];
    });
  }

  removeCategory() async {
    if (_selectedCategory == null) {
      return;
    }
    if (_sounds.any((element) => element.categoryId == _selectedCategory?.id)) {
      return;
    }
    await _storageService.removeCategory(_selectedCategory!);
    var indexToRemove = _selectedIndex - 2;
    changeDestination(_selectedIndex - 1);
    setState(() {
      _categories.removeAt(indexToRemove);
    });
    await _storageService.saveCategories(_categories);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sounds of RPG',
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
            Visibility(
              visible: _selectedCategory != null,
              child: IconButtonWithPadding(
                click: removeCategory,
                icon: const Icon(Icons.delete),
                padding: const EdgeInsets.only(right: 15),
              ),
            ),
            IconButtonWithPadding(
              click: updateLightMode,
              icon: Icon(_useLightMode ? Icons.dark_mode : Icons.light_mode),
              padding: const EdgeInsets.only(right: 15),
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
            MainSection(
              sounds: _sounds,
              selectedCategory: _selectedCategory,
            ),
          ],
        ),
      ),
    );
  }
}
