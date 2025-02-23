import 'package:flutter/material.dart';
import 'package:jop_project/components/background.dart';

class FreezeAccountScreen extends StatelessWidget {
  const FreezeAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme.bodyLarge;
    return Background(
      showListNotiv: true,
      title: 'تجميد الحساب',
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 80,
                color: Colors.amber,
              ),
              const SizedBox(height: 20),
              const Text(
                'تنبيه!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B8CC7),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'عند تجميد حسابك:',
                textDirection: TextDirection.rtl,
                style: theme,
              ),
              const SizedBox(height: 20),
              _buildWarningPoint('لن تتمكن من التقديم على الوظائف', theme!),
              _buildWarningPoint('لن تظهر سيرتك الذاتية للشركات', theme),
              _buildWarningPoint('يمكنك إلغاء التجميد في أي وقت', theme),
              const SizedBox(height: 40),
              TextField(
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'سبب تجميد الحساب',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    _showConfirmationDialog(context, theme);
                  },
                  child: const Text('تجميد الحساب'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWarningPoint(String text, TextStyle theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          const Icon(Icons.circle, size: 8),
          const SizedBox(width: 8),
          Text(text, style: theme),
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, TextStyle theme) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('تأكيد تجميد الحساب', style: theme),
          content: Text('هل أنت متأكد من رغبتك في تجميد حسابك؟', style: theme),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                // تنفيذ عملية تجميد الحساب
                Navigator.pop(context);
              },
              child: const Text(
                'تأكيد',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
