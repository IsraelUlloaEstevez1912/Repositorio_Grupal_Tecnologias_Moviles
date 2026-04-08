import 'package:flutter/material.dart';

class PersonAvatar extends StatelessWidget {
  const PersonAvatar({
    super.key,
    required this.name,
    this.radius = 24,
    this.backgroundColor = const Color(0xFFE8EEF9),
    this.foregroundColor = const Color(0xFF3559A8),
  });

  final String name;
  final double radius;
  final Color backgroundColor;
  final Color foregroundColor;

  String get _initials {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return '?';
    }

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: Text(
        _initials,
        style: TextStyle(
          color: foregroundColor,
          fontWeight: FontWeight.w800,
          fontSize: radius * 0.72,
        ),
      ),
    );
  }
}
