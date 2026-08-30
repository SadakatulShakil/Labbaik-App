import 'package:flutter/material.dart';

/// Maps the icon-name strings used in the bundled content JSON
/// (assets/data/umrah.json, hajj.json) to their [IconData].
IconData iconFromName(String name) {
  switch (name) {
    case 'help_outline':
      return Icons.help_outline;
    case 'luggage':
      return Icons.luggage;
    case 'map':
      return Icons.map;
    case 'checkroom':
      return Icons.checkroom;
    case 'record_voice_over':
      return Icons.record_voice_over;
    case 'mosque':
      return Icons.mosque;
    case 'rotate_right':
      return Icons.rotate_right;
    case 'local_drink':
      return Icons.local_drink;
    case 'directions_walk':
      return Icons.directions_walk;
    case 'content_cut':
      return Icons.content_cut;
    case 'star':
      return Icons.star;
    case 'category':
      return Icons.category;
    case 'how_to_reg':
      return Icons.how_to_reg;
    case 'brightness_3':
      return Icons.brightness_3;
    case 'looks_one':
      return Icons.looks_one;
    case 'looks_two':
      return Icons.looks_two;
    case 'looks_3':
      return Icons.looks_3;
    case 'looks_4':
      return Icons.looks_4;
    case 'waving_hand':
      return Icons.waving_hand;
    default:
      return Icons.circle;
  }
}
