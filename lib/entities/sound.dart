class Sound {
  final String id;
  final String categoryId;
  final String name;
  final String extension;
  final int iconCode;
  final String iconFontFamily;
  double volume;
  bool delayMode;
  double minTime;
  double maxTime;
  bool loopMode;

  Sound({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.extension,
    required this.iconCode,
    required this.iconFontFamily,
    required this.volume,
    required this.delayMode,
    required this.minTime,
    required this.maxTime,
    required this.loopMode,
  });

  Sound.fromJson(Map json)
      : id = json['id'],
        categoryId = json['categoryId'],
        name = json['name'],
        extension = json['extension'],
        iconCode = json['iconCode'],
        iconFontFamily = json['iconFontFamily'],
        volume = json['volume'] ?? 50,
        delayMode = json['delayMode'] ?? false,
        minTime = json['minTime'] ?? 0,
        maxTime = json['maxTime'] ?? 60,
        loopMode = json['loopMode'] ?? false;

  Map toJson() => {
        'id': id,
        'categoryId': categoryId,
        'name': name,
        'extension': extension,
        'iconCode': iconCode,
        'iconFontFamily': iconFontFamily,
        'volume': volume,
        'delayMode': delayMode,
        'minTime': minTime,
        'maxTime': maxTime,
        'loopMode': loopMode
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
