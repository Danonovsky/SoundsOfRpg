import 'package:flutter/material.dart';

class SoundTile extends StatelessWidget {
  final String title;

  const SoundTile({super.key, required this.title});

  playSingle() {}
  playLoop() {}

  @override
  Widget build(BuildContext context) => Card(
        child: Stack(
          children: [
            Center(
              child: Tooltip(
                message: title,
                preferBelow: false,
                child: const Icon(
                  Icons.music_note,
                  size: 50,
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
