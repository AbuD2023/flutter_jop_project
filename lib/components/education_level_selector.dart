import 'package:flutter/material.dart';

class EducationLevelSelector extends StatefulWidget {
  final Function(String) onLevelSelected;
  final String initialSelectedLevel;

  const EducationLevelSelector({
    super.key,
    required this.onLevelSelected,
    this.initialSelectedLevel = '',
  });

  @override
  State<EducationLevelSelector> createState() => _EducationLevelSelectorState();
}

class _EducationLevelSelectorState extends State<EducationLevelSelector> {
  late String selectedLevel;

  final List<String> educationLevels = [
    'ثانوية',
    'بكالوريوس',
    'ماجستير',
    'دكتوراه',
    'لايوجد',
  ];

  @override
  void initState() {
    super.initState();
    selectedLevel = widget.initialSelectedLevel;
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
              'المستوى التعليمي',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...educationLevels.map((level) => RadioListTile(
                  title: Text(level),
                  value: level,
                  groupValue: selectedLevel,
                  onChanged: (value) {
                    setState(() {
                      selectedLevel = value.toString();
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
                    widget.onLevelSelected(selectedLevel);
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