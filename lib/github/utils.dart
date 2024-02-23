import 'package:flutter/material.dart';

Color getStateColor(String? state) {
  switch (state?.toLowerCase()) {
    case 'open':
      return Colors.greenAccent.shade400;
    case 'closed':
      return Colors.redAccent.shade100;
    case 'merged':
      return Colors.purpleAccent.shade100;
    default:
      return Colors.grey.shade300;
  }
}
