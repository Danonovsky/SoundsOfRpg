import 'dart:async';
import 'dart:math';

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
  StreamSubscription? _subscription;
  StreamSubscription? _durationSubscription;
  late RangeValues _values =
      RangeValues(widget.sound.minTime, widget.sound.maxTime);
  bool loopMode = false;
  bool isActive = false;
  int _height = 0;
  int _playCount = 0;

  @override
  void initState() {
    super.initState();
    if (_subscription != null) return;
    ensureSubscribed();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

  Future<DeviceFileSource> get source async =>
      DeviceFileSource(await _storageService.getSoundFilePath(widget.sound));

  ensureSubscribed() {
    _subscription?.cancel();
    _durationSubscription?.cancel();
    _subscription = widget.player.onPlayerComplete.listen((event) async {
      isActive = false;
      var lastPlayCount = _playCount;
      if (loopMode) {
        isActive = true;
        if (widget.sound.delayMode) {
          _height = 100;
          var timeToWait = Random().nextInt(
                  widget.sound.maxTime.toInt() - widget.sound.minTime.toInt()) +
              widget.sound.minTime.toInt();
          var period = Duration(milliseconds: (timeToWait * 10).toInt());
          Timer.periodic(period, (timer) {
            if (_height == 0) {
              setState(() {
                timer.cancel();
              });
              return;
            }
            if (mounted) {
              setState(() {
                _height--;
              });
            }
          });
          await Future.delayed(Duration(seconds: timeToWait));
        }
        if (isActive && lastPlayCount == _playCount) {
          await start();
        }
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future play() async {
    ensureSubscribed();
    if (isActive) {
      await widget.player.stop();
      setState(() {
        isActive = false;
        _height = 0;
      });
      return;
    }
    await start();
    isActive = true;
    setState(() {});
  }

  Future start() async {
    _playCount++;
    await widget.player.play(await source);
  }

  Future setLoop() async {
    ensureSubscribed();
    setState(() {
      loopMode = true;
    });
  }

  Future setSingle() async {
    ensureSubscribed();
    setState(() {
      loopMode = false;
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
                        value: widget.sound.volume,
                        label: widget.sound.volume.toStringAsFixed(0),
                        onChanged: (value) {
                          setModalState(() {
                            widget.sound.volume = value;
                            widget.player.setVolume(widget.sound.volume / 100);
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: widget.sound.delayMode,
                        onChanged: (value) {
                          if (value == null) return;
                          setModalState(() {
                            widget.sound.delayMode = value;
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
                          labels: RangeLabels(_values.start.toStringAsFixed(0),
                              _values.end.toStringAsFixed(0)),
                          values: _values,
                          onChanged: (values) {
                            setModalState(() {
                              _values = values;
                              widget.sound.minTime = values.start;
                              widget.sound.maxTime = values.end;
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
              heightFactor: _height / 100,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: _height == 100
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
            Positioned.fill(
              bottom: 15,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Tooltip(
                  message: isActive ? 'Stop' : 'Play',
                  child: IconButton(
                    onPressed: play,
                    icon: isActive
                        ? const Icon(Icons.stop)
                        : const Icon(Icons.play_arrow),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              left: 15,
              child: loopMode
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
            Positioned(
              top: 15,
              left: 15,
              child: Text('$_height'),
            ),
          ],
        ),
      );
}
