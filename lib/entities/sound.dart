import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Sound {
  final Uuid id;
  final Uuid categoryId;
  final String name;
  final String path;
  final Icon icon;

  const Sound({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.path,
    required this.icon,
  });
}
