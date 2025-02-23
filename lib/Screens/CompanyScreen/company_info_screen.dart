import 'package:flutter/material.dart';
import 'package:jop_project/components/background.dart';
import 'package:jop_project/Models/company_model.dart';

class CompanyInfoScreen extends StatelessWidget {
  final CompanyModel company;

  const CompanyInfoScreen({
    super.key,
    required this.company,
  });

  @override
  Widget build(BuildContext context) {
    return Background(
      title: 'معلومات الشركة',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(company.img!),
            ),
            const SizedBox(height: 24),
            _buildInfoCard([
              _buildInfoRow('اسم الشركة', company.nameCompany!),
              _buildInfoRow('التخصص', company.special!),
              _buildInfoRow('الموقع', company.location!),
              _buildInfoRow('الفرع', company.special.toString()),
              _buildInfoRow('رقم الهاتف', company.phone!),
              _buildInfoRow('البريد الإلكتروني', company.email!),
              _buildInfoRow('الوصف', company.desc.toString()),
              _buildInfoRow('نوع الشكرة', company.typeCompany!),
            ]),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B3B77),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  // تعديل معلومات الشركة
                },
                child: const Text('تعديل المعلومات'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16, color: Colors.black),
              textDirection: TextDirection.rtl,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '$label:',
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }
}
