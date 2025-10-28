import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final String text;

  const SettingsPage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(text));
  }
}