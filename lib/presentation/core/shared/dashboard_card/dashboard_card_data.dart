import 'package:flutter/material.dart';

class DashboardCardData {
  final String title;
  final IconData icon;
  final String quantity;
  final String info;
  final Color infoColor;

  const DashboardCardData({
    required this.title,
    required this.icon,
    required this.quantity,
    required this.info,
    required this.infoColor,
  });
}
