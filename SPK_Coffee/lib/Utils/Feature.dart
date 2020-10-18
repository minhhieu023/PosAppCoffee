import 'package:SPK_Coffee/Components/ServiceScreen/MainServiceScreen.dart';
import 'package:flutter/material.dart';

class Feature {
  final IconData icon;
  final String title;
  final Color color;

  // final String routing;
  Feature(this.title, this.icon, this.color);
  // Feature (this.title, this.icon, this.color, )
}

var listFeature = [
  Feature(
    "Services",
    Icons.note_add,
    Colors.red[200],
  ),
  Feature(
    "Kitchen",
    Icons.kitchen,
    Colors.blue[100],
  ),
  Feature(
    "Storage",
    Icons.storage,
    Colors.brown[200],
  ),
  Feature(
    "Setting",
    Icons.settings,
    Colors.purple[100],
  ),
  Feature(
    "Logout",
    Icons.exit_to_app,
    Colors.yellow[100],
  )
];