class Sound {
  final String id;
  final String categoryId;
  final String name;
  final String extension;
  final int iconCode;
  final String iconFontFamily;
  double volume;

  Sound(
      {required this.id,
      required this.categoryId,
      required this.name,
      required this.extension,
      required this.iconCode,
      required this.iconFontFamily,
      required this.volume});

  Sound.fromJson(Map json)
      : id = json['id'],
        categoryId = json['categoryId'],
        name = json['name'],
        extension = json['extension'],
        iconCode = json['iconCode'],
        iconFontFamily = json['iconFontFamily'],
        volume = json['volume'];

  Map toJson() => {
        'id': id,
        'categoryId': categoryId,
        'name': name,
        'extension': extension,
        'iconCode': iconCode,
        'iconFontFamily': iconFontFamily,
        'volume': volume
      };
}

class SoundDto {
  final String id;
  final String categoryId;
  final String name;
  final int iconCode;
  final String iconFontFamily;
  final String path;
  final String extension;

  SoundDto({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.iconCode,
    required this.iconFontFamily,
    required this.path,
    required this.extension,
  });
}
