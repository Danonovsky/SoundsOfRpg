import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sounds_of_rpg/entities/sound.dart';
import 'package:sounds_of_rpg/services/storage_service.dart';

class SoundTile extends StatefulWidget {
  SoundTile({
    super.key,
    required this.sound,
    required this.player,
    required this.onDelete,
  });
  final Sound sound;
  final AudioPlayer player;
  final StorageService _storageService = StorageService();
  final void Function() onDelete;

  @override
  State<SoundTile> createState() => _SoundTileState();
}

class _SoundTileState extends State<SoundTile> {
  Future playSingle() async {
    await widget.player.play(
      DeviceFileSource(
          await widget._storageService.getSoundFilePath(widget.sound)),
    );
  }

  Future playLoop() async {
    if (widget.player.releaseMode == ReleaseMode.loop) {
      setState(() {
        widget.player.setReleaseMode(ReleaseMode.release);
      });
      await widget.player.release();
      return;
    }
    await widget.player.play(
      DeviceFileSource(
          await widget._storageService.getSoundFilePath(widget.sound)),
    );
    setState(() {
      widget.player.setReleaseMode(ReleaseMode.loop);
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
                  icon: widget.player.releaseMode == ReleaseMode.loop
                      ? const Icon(Icons.pause)
                      : const Icon(Icons.loop),
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
// class SoundTile extends StatelessWidget {
//   final Sound sound;
//   final AudioPlayer player;
//   final StorageService _storageService = StorageService();

//   SoundTile({
//     super.key,
//     required this.sound,
//     required this.player,
//     required this.onDelete,
//   });

  
//   final void Function() onDelete;

//   @override
//   Widget build(BuildContext context) => Card(
//         child: Stack(
//           children: [
//             Center(
//               child: Tooltip(
//                 message: sound.name,
//                 preferBelow: false,
//                 child: Icon(
//                   IconData(
//                     sound.iconCode,
//                     fontFamily: sound.iconFontFamily,
//                   ),
//                   size: 75,
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 15,
//               left: 15,
//               child: Tooltip(
//                 message: 'Play single',
//                 child: IconButton(
//                   onPressed: playSingle,
//                   icon: const Icon(Icons.play_arrow),
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 15,
//               right: 15,
//               child: Tooltip(
//                 message: 'Play in loop',
//                 child: IconButton(
//                   onPressed: playLoop,
//                   icon: player.releaseMode == ReleaseMode.loop
//                       ? const Icon(Icons.pause)
//                       : const Icon(Icons.loop),
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 15,
//               right: 15,
//               child: Tooltip(
//                 message: 'Delete',
//                 child: IconButton(
//                   onPressed: onDelete,
//                   icon: const Icon(Icons.delete),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
// }
