import 'package:flutter/material.dart';

class ExperiencesSelector extends StatefulWidget {
  final Function(List<String>) onExperiencesSelected;
  final List<String> initialSelectedExperiences;

  const ExperiencesSelector({
    super.key,
    required this.onExperiencesSelected,
    this.initialSelectedExperiences = const [],
  });

  @override
  State<ExperiencesSelector> createState() => _ExperiencesSelectorState();
}

class _ExperiencesSelectorState extends State<ExperiencesSelector> {
  late List<String> selectedExperiences;

  final List<String> allExperiences = [
    'إدارة فريق عمل',
    'الإشراف على مشاريع كبيرة',
    'التفاوض مع الموردين',
    'تحسين العمليات',
    'تقديم استشارات مهنية',
    'تحليل بيانات السوق',
    'تخطيط حملات تسويقية',
    'إنشاء قواعد بيانات',
    'إدارة منصات التواصل الاجتماعي',
    'تقديم دورات تدريبية',
    'إعداد خطط الأعمال',
    'قيادة مبادرات استراتيجية',
    'التعامل مع الشكاوى',
    'تطوير نظم الحوكمة',
    'تقديم تقارير إلى الإدارة العليا',
    'تحليل المشاكل وحلها',
    'تجربة في مجال البرمجيات',
    'العمل مع فرق متعددة الجنسيات',
    'المشاركة في معارض تجارية',
    'تصميم وتنفيذ استراتيجيات المبيعات',
    'الإشراف على عمليات الإنتاج',
    'كتابة عقود ومناقصات',
    'تنفيذ دراسات جدوى',
    'إدارة الاجتماعات',
    'تقييم الأداء',
    'دعم العملاء',
    'إنشاء محتوى إبداعي',
    'تجربة في التعليم والتدريب',
    'تصميم استبيانات',
    'تطوير أنظمة رقمية',
    'إدارة حسابات مالية',
    'كتابة مقترحات مشاريع',
    'تخطيط الحملات الإعلانية',
    'إجراء دراسات بحثية',
    'إنشاء شراكات استراتيجية',
    'تقديم حلول تقنية',
    'إدارة الفعاليات',
    'التعامل مع البرمجيات المتقدمة',
    'مراقبة جودة المنتجات',
    'تصميم مواقع إلكترونية',
  ];

  @override
  void initState() {
    super.initState();
    selectedExperiences = List.from(widget.initialSelectedExperiences);
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
              'الخبرات',
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
                itemCount: allExperiences.length,
                itemBuilder: (context, index) {
                  final experience = allExperiences[index];
                  final isSelected = selectedExperiences.contains(experience);
                  return Card(
                    elevation: isSelected ? 4 : 1,
                    color: isSelected
                        ? Theme.of(context).primaryColor.withOpacity(0.1)
                        : null,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedExperiences.remove(experience);
                          } else {
                            selectedExperiences.add(experience);
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
                                experience,
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
                    widget.onExperiencesSelected(selectedExperiences);
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
