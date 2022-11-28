// ignore_for_file: unused_field, prefer_final_fields

import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sounds_of_rpg/entities/sound.dart';
import 'package:sounds_of_rpg/services/storage_service.dart';

class MyPlayer {
  late AudioPlayer player;
  late Sound sound;
  bool isActive = false;
  int height = 0;
  int playCount = 0;
  final StorageService _storageService = StorageService();
  StreamSubscription? _subscription;
  StreamSubscription? _durationSubscription;
  late RangeValues values = RangeValues(sound.minTime, sound.maxTime);
  late Function updateTimer;
  late Function updateState;

  MyPlayer({
    required this.player,
    required this.sound,
    required this.updateTimer,
    required this.updateState,
  }) {
    ensureSubscribed();
  }

  Future<DeviceFileSource> get source async =>
      DeviceFileSource(await _storageService.getSoundFilePath(sound));

  ensureSubscribed() {
    _subscription?.cancel();
    _durationSubscription?.cancel();
    _subscription = player.onPlayerComplete.listen((event) async {
      isActive = false;
      var lastPlayCount = playCount;
      if (sound.loopMode) {
        isActive = true;
        if (sound.delayMode) {
          height = 100;
          var timeToWait =
              Random().nextInt(sound.maxTime.toInt() - sound.minTime.toInt()) +
                  sound.minTime.toInt();
          var period = Duration(milliseconds: (timeToWait * 10).toInt());
          Timer.periodic(period, (timer) {
            updateTimer(height, timer);
          });
          await Future.delayed(Duration(seconds: timeToWait));
        }
        if (isActive && lastPlayCount == playCount) {
          await start();
        }
      }
      updateState();
      /*if (mounted) {
        setState(() {});
      }*/
    });
  }

  play() async {
    ensureSubscribed();
    if (isActive) {
      await player.stop();
      isActive = false;
      height = 0;
      return;
    }
    await start();
    isActive = true;
  }

  Future start() async {
    playCount++;
    await player.play(await source);
  }

  setLoop() {
    ensureSubscribed();
    sound.loopMode = true;
  }

  setSingle() {
    ensureSubscribed();
    sound.loopMode = false;
  }
}
