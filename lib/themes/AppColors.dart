import 'package:flutter/material.dart';

class AppColors {
  //  che do sang
  static const Color lightGradientStart = Color(0xFFAECDFF);
  static const Color lightGradientEnd = Color(0xFF5896FD);
  static const Color lightSurface = Colors.white;
  //  che do toi
  static const Color darkGradientStart = Color.fromARGB(146, 0, 0, 0);
  static const Color darkGradientEnd = Color.fromARGB(183, 30, 22, 22);
  static const Color darkSurface = Color.fromARGB(255, 57, 57, 57);

  //  Các getter cho chế độ Tối/Sáng
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  //  Màu nền chính
  static const Color darkBackground = Color(0xFF1E1E1E);
  static const Color lightBackground = Colors.white;

  //  Văn bản
  static const Color darkText = Colors.white;
  static const Color lightText = Colors.black;
}
