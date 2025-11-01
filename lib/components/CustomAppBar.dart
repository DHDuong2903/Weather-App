import 'package:flutter/material.dart';
import 'package:weather_app/utils/translations.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback toggleTheme;
  final String city;
  final String language;
  final Function(String) onCityChanged;
  final Function(String) onLanguageChanged;

  const CustomAppBar({
    super.key,
    required this.toggleTheme,
    required this.city,
    required this.language,
    required this.onCityChanged,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(0, 168, 176, 189),
      elevation: 0,
      title: Text(
        city,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      centerTitle: true,
      actions: [
        _buildDropdownButton(
          context,
          icon: Icons.share_location,
          items: const ["Hanoi", "New York", "Tokyo", "London"],
          currentValue: city,
          onSelected: onCityChanged,
          labels: {
            "Hanoi": AppLocalizations.get('city_hanoi', language),
            "New York": AppLocalizations.get('city_newyork', language),
            "Tokyo": AppLocalizations.get('city_tokyo', language),
            "London": AppLocalizations.get('city_london', language),
          },
        ),
        const SizedBox(width: 8),
        _buildDropdownButton(
          context,
          icon: Icons.public,
          items: const ["vi", "en"],
          currentValue: language,
          onSelected: onLanguageChanged,
          labels: {
            "vi": AppLocalizations.get('lang_vi', language),
            "en": AppLocalizations.get('lang_en', language),
          },
        ),
        const SizedBox(width: 8),
        IconButton(
          tooltip: "Đổi giao diện",
          onPressed: toggleTheme,
          icon: const Icon(Icons.brightness_6, color: Colors.white),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildDropdownButton(
    BuildContext context, {
    required IconData icon,
    required List<String> items,
    required String currentValue,
    required Function(String) onSelected,
    required Map<String, String> labels,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return PopupMenuButton<String>(
      offset: const Offset(0, 45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDarkMode
          ? const Color(0xFF2C2C2E).withOpacity(0.95)
          : const Color(0xFF5896FD).withOpacity(0.9),
      elevation: 8,
      onSelected: (value) => onSelected(value),
      itemBuilder: (context) {
        return items.map((item) {
          final isActive = item == currentValue;
          return PopupMenuItem<String>(
            value: item,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    labels[item] ?? item,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: isActive
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
                if (isActive)
                  const Icon(Icons.check, color: Colors.white, size: 18),
              ],
            ),
          );
        }).toList();
      },
      icon: Icon(icon, color: Colors.white),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
