import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sounds_of_rpg/entities/category.dart';
import 'package:sounds_of_rpg/entities/sound.dart';
import 'package:sounds_of_rpg/services/storage_service.dart';
import 'package:sounds_of_rpg/widgets/add_sound_dialog.dart';
import 'package:sounds_of_rpg/widgets/sound_tile.dart';

class MainSection extends StatefulWidget {
  const MainSection(
      {Key? key, required this.sounds, required this.selectedCategory})
      : super(key: key);
  final List<Sound> sounds;
  final Category? selectedCategory;

  @override
  State<MainSection> createState() => _MainSectionState();
}

class _MainSectionState extends State<MainSection> {
  final StorageService _storageService = StorageService();
  final Map<String, AudioPlayer> _players = {};

  @override
  void initState() {
    super.initState();
    for (var sound in widget.sounds) {
      _players[sound.id] = AudioPlayer(playerId: sound.id);
    }
  }

  Future showAddDialog() async {
    var sound = await showDialog<SoundDto>(
      context: context,
      builder: (context) => AddSoundDialog(
        selectedCategory: widget.selectedCategory!,
      ),
    );
    if (sound == null) return;
    await _storageService.saveSoundFile(sound);
    setState(() {
      widget.sounds.add(Sound(
        categoryId: sound.categoryId,
        iconCode: sound.iconCode,
        iconFontFamily: sound.iconFontFamily,
        id: sound.id,
        name: sound.name,
        extension: '',
      ));
    });
    await _storageService.saveSounds(widget.sounds);
  }

  void deleteSound(Sound sound) async {
    setState(() {
      widget.sounds.remove(sound);
    });
    await _storageService.removeSound(sound);
    await _storageService.saveSounds(widget.sounds);
  }

  AudioPlayer getPlayer(Sound sound) {
    if (_players.containsKey(sound.id) == false) {
      _players[sound.id] = AudioPlayer(playerId: sound.id);
    }
    return _players[sound.id]!;
  }

  Future playSingle(Sound sound) async {
    var player = getPlayer(sound);
    await player.play(
      DeviceFileSource(await _storageService.getSoundFilePath(sound)),
    );
  }

  Future playLoop(Sound sound) async {
    var player = getPlayer(sound);
    if (player.releaseMode == ReleaseMode.loop) {
      setState(() {
        player.setReleaseMode(ReleaseMode.release);
      });
      await player.release();
      return;
    }
    await player.play(
      DeviceFileSource(await _storageService.getSoundFilePath(sound)),
    );
    setState(() {
      player.setReleaseMode(ReleaseMode.loop);
    });
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
                    onPressed: () async {
                      await showAddDialog();
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
                      (e) => SoundTile(
                        sound: e,
                        player: getPlayer(e),
                        onDelete: () => deleteSound(e),
                        playSingle: () async => await playSingle(e),
                        playLoop: () async => await playLoop(e),
                      ),
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
