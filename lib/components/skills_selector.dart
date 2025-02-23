import 'package:flutter/material.dart';

class SkillsSelector extends StatefulWidget {
  final Function(List<String>) onSkillsSelected;
  final List<String> initialSelectedSkills;

  const SkillsSelector({
    super.key,
    required this.onSkillsSelected,
    this.initialSelectedSkills = const [],
  });

  @override
  State<SkillsSelector> createState() => _SkillsSelectorState();
}

class _SkillsSelectorState extends State<SkillsSelector> {
  late List<String> selectedSkills;

  final List<String> allSkills = [
    'البرمجة',
    'إدارة الوقت',
    'الابتكار',
    'العمل الجماعي',
    'التسويق الرقمي',
    'التفكير النقدي',
    'إدارة العلاقات',
    'حل المشكلات',
    'العصف الذهني',
    'الإبداع',
    'كتابة المحتوى',
    'القيادة',
    'تحرير الفيديو',
    'المرونة',
    'التفكير الإبداعي',
    'التفاوض',
    'إعداد العروض التقديمية',
    'التخطيط الاستراتيجي',
    'العمل تحت الضغط',
    'التواصل الفعال',
    'كتابة الأكواد',
    'كتابة التقارير',
    'مهارات البيع',
    'إدارة المشاريع',
    'تحليل الأسواق',
    'تحليل البيانات',
    'AI الإلمام بتقنيات',
    'البحث'
  ];

  @override
  void initState() {
    super.initState();
    selectedSkills = List.from(widget.initialSelectedSkills);
  }

  @override
  Widget build(BuildContext context) {
    // حساب عدد الأعمدة بناءً على حجم الشاشة
    int crossAxisCount = 3;
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      // للموبايل
      crossAxisCount = 2;
    } else if (screenWidth < 900) {
      // للتابلت
      crossAxisCount = 3;
    } else {
      // للديسكتوب
      crossAxisCount = 4;
    }

    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'المهارات',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: allSkills.length,
                itemBuilder: (context, index) {
                  final skill = allSkills[index];
                  final isSelected = selectedSkills.contains(skill);
                  return Card(
                    elevation: isSelected ? 4 : 1,
                    color: isSelected
                        ? Theme.of(context).primaryColor.withOpacity(0.1)
                        : null,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedSkills.remove(skill);
                          } else {
                            selectedSkills.add(skill);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                skill,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isSelected
                                      ? Theme.of(context).primaryColor
                                      : Colors.black,
                                  fontWeight:
                                      isSelected ? FontWeight.bold : null,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: Theme.of(context).primaryColor,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
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
                    widget.onSkillsSelected(selectedSkills);
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
