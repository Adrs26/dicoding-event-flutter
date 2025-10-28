import 'package:flutter/material.dart';

const bluePrimary = Color(0xFF0077C0);
const softWhite = Color(0xFFF8FCFB);
const softBlack = Color(0xFF1E1E1E);
const green600 = Color(0xFF43A047);
const orange600 = Color(0xFFFB8C00);

final myColorScheme = const ColorScheme.light().copyWith(
  primary: bluePrimary,
  surface: softWhite,
  onSurface: softBlack,
  surfaceContainerHighest: Colors.black45,
);
