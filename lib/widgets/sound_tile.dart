import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sounds_of_rpg/entities/sound.dart';
import 'package:sounds_of_rpg/services/storage_service.dart';

class SoundTile extends StatefulWidget {
  const SoundTile({
    super.key,
    required this.sound,
    required this.player,
    required this.onDelete,
  });
  final Sound sound;
  final AudioPlayer player;
  final void Function() onDelete;

  @override
  State<SoundTile> createState() => _SoundTileState();
}

class _SoundTileState extends State<SoundTile> {
  final StorageService _storageService = StorageService();
  @override
  void initState() {
    super.initState();
    widget.player.onPlayerStateChanged.listen((event) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<DeviceFileSource> get source async =>
      DeviceFileSource(await _storageService.getSoundFilePath(widget.sound));

  Future playSingle() async {
    if (widget.player.state == PlayerState.playing) {
      await widget.player.stop();
      return;
    }
    await widget.player.play(await source);
  }

  Future setLoop() async {
    setState(() {
      widget.player.setReleaseMode(ReleaseMode.loop);
    });
  }

  Future setSingle() async {
    setState(() {
      widget.player.setReleaseMode(ReleaseMode.stop);
    });
  }

  @override
  Widget build(BuildContext context) => Card(
        child: Stack(
          children: [
            Center(
              child: Tooltip(
                message: widget.sound.name,
                preferBelow: false,
                child: Icon(
                  IconData(
                    widget.sound.iconCode,
                    fontFamily: widget.sound.iconFontFamily,
                  ),
                  size: 75,
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              left: 15,
              child: Tooltip(
                message: 'Play',
                child: IconButton(
                  onPressed: playSingle,
                  icon: widget.player.state == PlayerState.playing
                      ? const Icon(Icons.stop)
                      : const Icon(Icons.play_arrow),
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              right: 15,
              child: widget.player.releaseMode == ReleaseMode.stop
                  ? Tooltip(
                      message: 'Switch to loop mode',
                      child: IconButton(
                          onPressed: setLoop,
                          icon: const Icon(Icons.repeat_one)),
                    )
                  : Tooltip(
                      message: 'Switch to single mode',
                      child: IconButton(
                        onPressed: setSingle,
                        icon: const Icon(Icons.repeat_outlined),
                      ),
                    ),
            ),
            Positioned(
              top: 15,
              right: 15,
              child: Tooltip(
                message: 'Delete',
                child: IconButton(
                  onPressed: widget.onDelete,
                  icon: const Icon(Icons.delete),
                ),
              ),
            ),
          ],
        ),
      );
}
