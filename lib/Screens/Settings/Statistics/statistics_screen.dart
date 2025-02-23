import 'package:flutter/material.dart';
import 'package:jop_project/Providers/Companies/companies_provider.dart';
import 'package:jop_project/Providers/Job/job_provider.dart';
import 'package:jop_project/Providers/Orders/order_provider.dart';
import 'package:jop_project/components/background.dart';
import 'package:provider/provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme.bodyLarge;
    return Background(
      // showListNotiv: true,
      title: 'الإحصائيات والتقييم',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStatCard(
              'إحصائيات عامة',
              [
                _buildStatItem(
                    'عدد الوظائف المتاحة',
                    '${Provider.of<JobsProvider>(context).jobs.length}',
                    theme!),
                _buildStatItem(
                    'عدد المتقدمين',
                    '${Provider.of<OrderProvider>(context).orders.length}',
                    theme),
                _buildStatItem(
                    'عدد الشركات',
                    '${Provider.of<CompaniesProvider>(context).companies.length}',
                    theme),
              ],
            ),
            const SizedBox(height: 20),
            _buildStatCard(
              'نشاطك',
              [
                _buildStatItem('الوظائف المتقدم لها', '8', theme),
                _buildStatItem('المقابلات', '3', theme),
                _buildStatItem('العروض المقدمة', '2', theme),
              ],
            ),
            const SizedBox(height: 20),
            _buildRatingSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B8CC7),
              ),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, TextStyle theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: TextDirection.rtl,
        children: [
          Text(label, style: theme),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B8CC7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'تقييم التطبيق',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B8CC7),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => Icon(
                  Icons.star,
                  size: 40,
                  color: index < 4 ? Colors.amber : Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              textAlign: TextAlign.right,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'اكتب تعليقك',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B3B77),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  // إرسال التقييم
                },
                child: const Text('إرسال التقييم'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
