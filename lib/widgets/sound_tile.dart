import 'package:flutter/material.dart';
import 'package:sounds_of_rpg/entities/sound.dart';

class SoundTile extends StatelessWidget {
  final Sound sound;

  const SoundTile({
    super.key,
    required this.sound,
    required this.onDelete,
    required this.playSingle,
    required this.playLoop,
  });

  final void Function() playSingle;
  final void Function() playLoop;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) => Card(
        child: Stack(
          children: [
            Center(
              child: Tooltip(
                message: sound.name,
                preferBelow: false,
                child: Icon(
                  IconData(
                    sound.iconCode,
                    fontFamily: sound.iconFontFamily,
                  ),
                  size: 75,
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              left: 15,
              child: Tooltip(
                message: 'Play single',
                child: IconButton(
                  onPressed: playSingle,
                  icon: const Icon(Icons.play_arrow),
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              right: 15,
              child: Tooltip(
                message: 'Play in loop',
                child: IconButton(
                  onPressed: playLoop,
                  icon: const Icon(Icons.repeat),
                ),
              ),
            ),
            Positioned(
              top: 15,
              right: 15,
              child: Tooltip(
                message: 'Delete',
                child: IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete),
                ),
              ),
            ),
          ],
        ),
      );
}
