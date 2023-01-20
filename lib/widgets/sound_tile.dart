import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sounds_of_rpg/models/my_player.dart';

class SoundTile extends StatefulWidget {
  const SoundTile({
    super.key,
    required this.player,
    required this.onDelete,
  });
  final MyPlayer player;
  final void Function() onDelete;

  @override
  State<SoundTile> createState() => _SoundTileState();
}

class _SoundTileState extends State<SoundTile> {
  MyPlayer get player => widget.player;
  @override
  void initState() {
    super.initState();
    widget.player.ensureSubscribed();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future play() async {
    setState(() {
      player.play();
    });
  }

  Future setLoop() async {
    setState(() {
      player.setLoop();
    });
  }

  Future setSingle() async {
    setState(() {
      player.setSingle();
    });
  }

  showModal() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.only(
                  bottom: 15, top: 15, left: 100, right: 100),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Settings',
                    style: TextStyle(fontSize: 22),
                  ),
                  Row(
                    children: [
                      const Text('Volume'),
                      Slider(
                        max: 100,
                        min: 0,
                        divisions: 100,
                        value: player.sound.volume,
                        label: player.sound.volume.toStringAsFixed(0),
                        onChanged: (value) {
                          setModalState(() {
                            player.sound.volume = value;
                            player.player.setVolume(player.sound.volume / 100);
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: player.sound.delayMode,
                        onChanged: (value) {
                          if (value == null) return;
                          setModalState(() {
                            player.sound.delayMode = value;
                          });
                        },
                      ),
                      const Text('Delay Mode'),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Delay'),
                      RangeSlider(
                          min: 0,
                          max: 60,
                          divisions: 60,
                          labels: RangeLabels(
                              player.values.start.toStringAsFixed(0),
                              player.values.end.toStringAsFixed(0)),
                          values: player.values,
                          onChanged: (values) {
                            setModalState(() {
                              player.values = values;
                              player.sound.minTime = values.start;
                              player.sound.maxTime = values.end;
                            });
                          }),
                    ],
                  )
                ],
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) => Card(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            FractionallySizedBox(
              heightFactor: player.height / 100,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: player.height == 100
                      ? const BorderRadius.all(Radius.circular(12))
                      : const BorderRadius.only(
                          bottomRight: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                  color: Theme.of(context).disabledColor,
                ),
              ),
            ),
            Center(
              child: Tooltip(
                message: player.sound.name,
                preferBelow: false,
                child: Icon(
                  IconData(
                    player.sound.iconCode,
                    fontFamily: player.sound.iconFontFamily,
                  ),
                  size: 75,
                ),
              ),
            ),
            Positioned.fill(
              bottom: 15,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Tooltip(
                  message: player.isActive ? 'Stop' : 'Play',
                  child: IconButton(
                    onPressed: play,
                    icon: player.isActive
                        ? const Icon(Icons.stop)
                        : const Icon(Icons.play_arrow),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              left: 15,
              child: player.sound.loopMode
                  ? Tooltip(
                      message: 'Switch to single mode',
                      child: IconButton(
                        onPressed: setSingle,
                        icon: const Icon(Icons.repeat_outlined),
                      ),
                    )
                  : Tooltip(
                      message: 'Switch to loop mode',
                      child: IconButton(
                        onPressed: setLoop,
                        icon: const Icon(Icons.repeat_one),
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
            Positioned(
              bottom: 15,
              right: 15,
              child: Tooltip(
                message: 'Edit',
                child: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: showModal,
                ),
              ),
            ),
          ],
        ),
      );
}
