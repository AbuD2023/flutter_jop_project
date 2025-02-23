import 'package:flutter/material.dart';

class PreferencesSelector extends StatefulWidget {
  final Function(List<String>) onPreferencesSelected;
  final List<String> initialSelectedPreferences;

  const PreferencesSelector({
    super.key,
    required this.onPreferencesSelected,
    this.initialSelectedPreferences = const [],
  });

  @override
  State<PreferencesSelector> createState() => _PreferencesSelectorState();
}

class _PreferencesSelectorState extends State<PreferencesSelector> {
  late List<String> selectedPreferences;

  final List<String> allPreferences = [
    'مكتبي',
    'عن بعد',
    'دوام جزئي',
    'دوام كامل',
  ];

  @override
  void initState() {
    super.initState();
    selectedPreferences = List.from(widget.initialSelectedPreferences);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'التفضيلات',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...allPreferences.map((preference) => CheckboxListTile(
                  title: Text(preference),
                  value: selectedPreferences.contains(preference),
                  onChanged: (checked) {
                    setState(() {
                      if (checked!) {
                        selectedPreferences.add(preference);
                      } else {
                        selectedPreferences.remove(preference);
                      }
                    });
                  },
                )),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إلغاء'),
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.onPreferencesSelected(selectedPreferences);
                    Navigator.pop(context);
                  },
                  child: const Text('تم'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 