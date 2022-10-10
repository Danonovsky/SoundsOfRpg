import 'dart:convert';
import 'dart:io';

import 'package:sounds_of_rpg/entities/category.dart';
import 'package:sounds_of_rpg/entities/sound.dart';

class StorageService {
  Future<List<Category>> loadCategories() async {
    var jsonString = await (await _getJsonFileForCategories()).readAsString();
    var categories = jsonDecode(jsonString) as List<dynamic>;
    return categories.map((e) => Category.fromJson(e)).toList();
  }

  saveCategories(List<Category> categories) async {
    var jsonFile = await _getJsonFileForCategories();
    var jsonString = jsonEncode(categories);
    await jsonFile.writeAsString(jsonString);
  }

  Future<List<Sound>> loadSounds() async {
    var jsonString = await (await _getJsonFileForSounds()).readAsString();
    var sounds = jsonDecode(jsonString) as List<dynamic>;
    return sounds.map((e) => Sound.fromJson(e)).toList();
  }

  saveFiles(List<Sound> sounds) async {
    var jsonFile = await _getJsonFileForSounds();
    var jsonString = jsonEncode(sounds);
    await jsonFile.writeAsString(jsonString);
  }

  Future<File> _getJsonFileForSounds() async {
    var jsonFile = File('storage/sounds.json');
    if (await jsonFile.exists() == false) {
      jsonFile = await File('storage/sounds.json').create(recursive: true);
      await jsonFile.writeAsString('[]');
    }
    return jsonFile;
  }

  Future<File> _getJsonFileForCategories() async {
    var jsonFile = File('storage/categories.json');
    if (await jsonFile.exists() == false) {
      jsonFile = await File('storage/categories.json').create(recursive: true);
      await jsonFile.writeAsString('[]');
    }
    return jsonFile;
  }
}
