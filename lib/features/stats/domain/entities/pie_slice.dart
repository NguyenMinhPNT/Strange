import 'package:flutter/material.dart';

class PieSlice {
  const PieSlice({
    required this.label,
    required this.totalSeconds,
    required this.color,
  });

  final String label;
  final int totalSeconds;
  final Color color;
}
