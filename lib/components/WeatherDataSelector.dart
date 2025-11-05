import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:weather_app/utils/translations.dart';

class WeatherDataSelector extends StatefulWidget {
  final Function(String) onSelect;
  final String selectedValue;
  final String lang;

  const WeatherDataSelector({
    super.key,
    required this.onSelect,
    required this.selectedValue,
    required this.lang,
  });

  @override
  State<WeatherDataSelector> createState() => _WeatherDataSelectorState();
}

class _WeatherDataSelectorState extends State<WeatherDataSelector> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  List<Map<String, dynamic>> get options => [
    {
      "label": AppLocalizations.get('weatherCondition', widget.lang),
      "value": "temperature",
      "icon": LucideIcons.cloudSun,
    },
    {
      "label": AppLocalizations.get('wind', widget.lang),
      "value": "wind",
      "icon": LucideIcons.wind,
    },
    {
      "label": AppLocalizations.get('humidity', widget.lang),
      "value": "humidity",
      "icon": LucideIcons.droplet,
    },
    {
      "label": AppLocalizations.get('visibility', widget.lang),
      "value": "visibility",
      "icon": LucideIcons.eye,
    },
    {
      "label": AppLocalizations.get('pressure', widget.lang),
      "value": "pressure",
      "icon": LucideIcons.gauge,
    },
  ];

  void _showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Nền trong suốt để click ra ngoài tắt dropdown
          GestureDetector(
            onTap: _removeOverlay,
            child: Container(color: Colors.transparent),
          ),

          Positioned(
            right:
                MediaQuery.of(context).size.width - (position.dx + size.width),
            top: position.dy + size.height + 6,
            child: Material(
              color: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(
                  minWidth: 160,
                  maxWidth: MediaQuery.of(context).size.width * 0.45,
                ),
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E1E1E).withOpacity(0.95)
                      : const Color(0xFF5896FD).withOpacity(0.85),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(0.6)
                          : Colors.black26,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: options.map((opt) {
                    bool isSelected = widget.selectedValue == opt["value"];
                    return InkWell(
                      onTap: () {
                        widget.onSelect(opt["value"]);
                        _removeOverlay();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            Icon(opt["icon"], color: Colors.white, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                opt["label"],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 18,
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {});
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedIcon = options.firstWhere(
      (opt) => opt["value"] == widget.selectedValue,
      orElse: () => options.first,
    )["icon"];

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: () {
          if (_overlayEntry == null) {
            _showOverlay();
          } else {
            _removeOverlay();
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF303030) : const Color(0xFF5896FD),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.5)
                    : Colors.blue.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(selectedIcon, color: Colors.white, size: 20),
              const SizedBox(width: 4),
              Icon(
                _overlayEntry == null
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_up,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
