import 'package:flutter/material.dart';

class Feature {
  final IconData icon;
  final String title;
  final Color color;

  // final String routing;
  Feature(this.title, this.icon, this.color);
  // Feature (this.title, this.icon, this.color, )
}

var featureForAdmin = [
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
  Feature("Statistics", Icons.bubble_chart, Colors.green),
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

var featureForWaiter = [
  Feature(
    "Services",
    Icons.note_add,
    Colors.red[200],
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

var featureForBartender = [
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
