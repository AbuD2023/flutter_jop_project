import 'package:flutter/material.dart';
import 'package:jop_project/Providers/Job/job_provider.dart';
import 'package:jop_project/Providers/Orders/order_provider.dart';
import 'package:jop_project/Providers/Searchers/searchers_provider.dart';
import 'package:jop_project/Screens/CompanyScreen/add_job_screen.dart';
import 'package:jop_project/Screens/CompanyScreen/applicants_screen.dart';
import 'package:jop_project/Screens/CompanyScreen/company_jobs_screen.dart';
import 'package:jop_project/Screens/CompanyScreen/company_info_screen.dart';
import 'package:jop_project/Screens/CompanyScreen/accepted_screen.dart';
import 'package:jop_project/Screens/CompanyScreen/messages_screen.dart';
import 'package:jop_project/components/background.dart';
import 'package:jop_project/Models/company_model.dart';
import 'package:jop_project/constants.dart';
import 'package:jop_project/data/mock_data.dart';
import 'package:provider/provider.dart';

class CompanyDashboardScreen extends StatelessWidget {
  final CompanyModel company;

  const CompanyDashboardScreen({
    super.key,
    required this.company,
  });

  @override
  Widget build(BuildContext context) {
    return Background(
      showListNotiv: true,
      title: 'الرئيسية',
      isCompany: true,
      userImage: company.img,
      userName: company.nameCompany,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildCompanyHeader(),
              const SizedBox(height: 32),
              _buildDashboardGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: company.img != null
              ? NetworkImage(company.img!)
              : const AssetImage('assets/images/profile.png'),
        ),
        const SizedBox(height: 16),
        Text(
          company.nameCompany!,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          company.location!,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardGrid(BuildContext context) {
    final orders = Provider.of<OrderProvider>(context);
    final jobs = Provider.of<JobsProvider>(context);
    final searchersProvider = Provider.of<SearchersProvider>(context);
    final job =
        jobs.jobs.where((element) => element.companyId == company.id).toList();
    final order = orders.orders.where(
        (element) => job.any((job) => job.id == element.jobAdvertisementId));
    final count = order.length;
    final countAccepted = order.where((element) => element.accept == 1);
    final searchers = searchersProvider.searchers
        .where(
          (searcharr) => order
              .where(
                  (ordr) => ordr.accept == 1 && ordr.searcherId == searcharr.id)
              .isNotEmpty,
        )
        .toList();
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildDashboardCard(
            'عرض الوظائف المقدمة',
            Icons.work,
            () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CompanyJobsScreen(company: company),
                  ),
                ),
            context),
        _buildDashboardCard(
            'اضافة وظيفة شاغرة',
            Icons.add_circle,
            () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddJopScreen()),
                ),
            context),
        _buildDashboardCard('المتقدمين ($count)', Icons.people, () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ApplicantsScreen(
                job: job[0],
              ),
            ),
          );
        }, context),
        _buildDashboardCard(
            'المقبولين (${countAccepted.length})',
            Icons.check_circle,
            () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AcceptedScreen(searchers: searchers),
                  ),
                ),
            context),
        _buildDashboardCard(
            'الرسائل (8)',
            Icons.message,
            () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MessagesScreen(messages: mockMessages),
                  ),
                ),
            context),
        _buildDashboardCard(
            'معلومات الشركة',
            Icons.info,
            () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CompanyInfoScreen(company: company),
                  ),
                ),
            context),
      ],
    );
  }

  Widget _buildDashboardCard(
      String title, IconData icon, VoidCallback onTap, BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: const Color(0xFF6B8CC7),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
