import 'package:flutter/material.dart';

class SoundTile extends StatelessWidget {
  final String title;

  const SoundTile({super.key, required this.title});

  playSingle() {}
  playLoop() {}

  @override
  Widget build(BuildContext context) => Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Tooltip(
                message: title,
                preferBelow: false,
                child: const Icon(
                  Icons.music_note,
                  size: 50,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Tooltip(
                  message: 'Play single',
                  child: IconButton(
                    onPressed: playSingle,
                    icon: const Icon(Icons.play_arrow),
                  ),
                ),
                IconButton(
                  onPressed: playLoop,
                  icon: const Icon(Icons.repeat),
                ),
              ],
            ),
          ],
        ),
      );
}
