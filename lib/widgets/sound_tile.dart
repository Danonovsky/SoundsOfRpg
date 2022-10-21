import 'package:flutter/material.dart';
import 'package:sounds_of_rpg/entities/sound.dart';

class SoundTile extends StatelessWidget {
  final Sound sound;

  const SoundTile({super.key, required this.sound});

  playSingle() {}
  playLoop() {}

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
                  onPressed: playSingle,
                  icon: const Icon(Icons.repeat),
                ),
              ),
            ),
          ],
        ),
      );
}
