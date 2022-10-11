import 'dart:typed_data';

class Sound {
  final String id;
  final String categoryId;
  final String name;
  final int iconCode;
  final String iconFontFamily;

  const Sound(
      {required this.id,
      required this.categoryId,
      required this.name,
      required this.iconCode,
      required this.iconFontFamily});

  Sound.fromJson(Map json)
      : id = json['id'],
        categoryId = json['categoryId'],
        name = json['name'],
        iconCode = json['iconCode'],
        iconFontFamily = json['iconFontFamily'];

  Map toJson() => {
        'id': id,
        'categoryId': categoryId,
        'name': name,
        'iconCode': iconCode,
        'iconFontFamily': iconFontFamily,
      };
}

class SoundDto {
  final String id;
  final String categoryId;
  final String name;
  final int iconCode;
  final String iconFontFamily;
  final String path;

  SoundDto({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.iconCode,
    required this.iconFontFamily,
    required this.path,
  });
}
