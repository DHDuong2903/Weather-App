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
  static final Color darkSubText = Colors.white70;
  static final Color lightSubText = Colors.black54;

  static Color text(BuildContext context) =>
    isDark(context) ? Colors.white : Colors.black87;

  static Color subText(BuildContext context) =>
    isDark(context) ? Colors.white70 : Colors.black54;
  
  static Color cardBackground(BuildContext context) =>
      isDark(context) ? const Color(0xFF1C1C1E) : Colors.white;

  static Color border(BuildContext context) =>
      isDark(context) ? Colors.white24 : Colors.grey.shade400;

  //  Rain chart màu gradient
  static const Color darkRainTop = Colors.lightBlueAccent;
  static const Color lightRainTop = Colors.blueAccent;
  static const Color darkRainFill = Color(0xFF2A2A2A);
  static const Color lightRainFill = Color(0xFFF2F2F7);

  //  Viền & grid
  static final Color darkBorder = Colors.grey.shade700;
  static final Color lightBorder = Colors.grey.shade300;
  static final Color darkGrid = Colors.white12;
  static final Color lightGrid = Colors.grey.shade300;
  
  // điểm nhấn
  static const Color lightAccent = Color.fromARGB(255, 64, 179, 255);
  static const Color darkAccent = Colors.lightBlueAccent;
}
