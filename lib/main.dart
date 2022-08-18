import 'package:flutter/material.dart';
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
  int _selectedIndex = 0;
  bool _useLightMode = true;

  Brightness get brightness =>
      _useLightMode ? Brightness.light : Brightness.dark;
  ThemeMode get themeMode => _useLightMode ? ThemeMode.light : ThemeMode.dark;

  void changeDestination(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void updateLightMode() {
    setState(() {
      _useLightMode = !_useLightMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
            IconButton(
              onPressed: updateLightMode,
              icon: Icon(_useLightMode ? Icons.dark_mode : Icons.light_mode),
            ),
          ],
        ),
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: changeDestination,
              extended: true,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.list),
                  label: Text('All'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.location_city),
                  label: Text('City'),
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 5,
                        children: List.generate(
                            10, (index) => SoundTile(title: '$index')),
                      ),
                    ),
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
