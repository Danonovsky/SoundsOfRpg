import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sounds_of_rpg/entities/category.dart';
import 'package:sounds_of_rpg/entities/sound.dart';

class StorageService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/sounds-of-rpg/';
  }

  Future<List<Category>> loadCategories() async {
    var jsonString = await (await _getJsonFileForCategories()).readAsString();
    var categories = jsonDecode(jsonString) as List<dynamic>;
    return categories.map((e) => Category.fromJson(e)).toList();
  }

  saveCategoryDirectory(Category category) async {
    var directory = Directory('${await _localPath}storage/${category.id}');
    await directory.create(recursive: true);
  }

  saveSoundFile(SoundDto sound) async {
    var newPath = '${await _localPath}storage/${sound.categoryId}/${sound.id}';

    var file = File(sound.path);
    await file.copy(newPath);
  }

  saveCategories(List<Category> categories) async {
    var jsonFile = await _getJsonFileForCategories();
    var jsonString = jsonEncode(categories);
    await jsonFile.writeAsString(jsonString);
  }

  removeCategory(Category category) async {
    var directory = Directory('${await _localPath}storage/${category.id}');
    if (await directory.exists() == false) return;
    await directory.delete();
  }

  removeSound(Sound sound) async {
    var file =
        Directory('${await _localPath}storage/${sound.categoryId}/${sound.id}');
    print(file.path);
    if (await file.exists() == false) return;
    print('Deleting file');
    await file.delete();
  }

  Future<List<Sound>> loadSounds() async {
    var jsonString = await (await _getJsonFileForSounds()).readAsString();
    var sounds = jsonDecode(jsonString) as List<dynamic>;
    return sounds.map((e) => Sound.fromJson(e)).toList();
  }

  saveSounds(List<Sound> sounds) async {
    var jsonFile = await _getJsonFileForSounds();
    var jsonString = jsonEncode(sounds);
    await jsonFile.writeAsString(jsonString);
  }

  Future<File> _getJsonFileForSounds() async {
    var jsonFile = File('${await _localPath}storage/sounds.json');
    if (await jsonFile.exists() == false) {
      jsonFile = await File('${await _localPath}storage/sounds.json')
          .create(recursive: true);
      await jsonFile.writeAsString('[]');
    }
    return jsonFile;
  }

  Future<File> _getJsonFileForCategories() async {
    var jsonFile = File('${await _localPath}storage/categories.json');
    if (await jsonFile.exists() == false) {
      jsonFile = await File('${await _localPath}storage/categories.json')
          .create(recursive: true);
      await jsonFile.writeAsString('[]');
    }
    return jsonFile;
  }
}
