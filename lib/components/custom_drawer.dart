import 'package:flutter/material.dart';
import 'package:jop_project/Models/company_model.dart';
import 'package:jop_project/Providers/Companies/companies_provider.dart';
import 'package:jop_project/Providers/Orders/order_provider.dart';
import 'package:jop_project/Providers/SignUp/company_signin_login_provider.dart';
import 'package:jop_project/Screens/CompanyScreen/applicants_screen.dart';
import 'package:jop_project/Screens/CompanyScreen/company_dashboard_screen.dart';
import 'package:jop_project/Screens/CompanyScreen/company_jobs_screen.dart';
import 'package:jop_project/Screens/CompanyScreen/messages_screen.dart';
import 'package:jop_project/Screens/JopScreen/Home/home_screen.dart';
import 'package:jop_project/Screens/JopScreen/OrderScreen/order_screen.dart';
import 'package:jop_project/Screens/JopScreen/Profile/cv_screen.dart';
import 'package:jop_project/Screens/ShareScreen/Login/login_screen.dart';
import 'package:jop_project/Screens/Settings/Statistics/statistics_screen.dart';
import 'package:jop_project/data/mock_data.dart';
import 'package:jop_project/size_config.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  final bool isCompany;
  final String name;
  final String? imagePath;
  final int availableJobs;

  const CustomDrawer({
    super.key,
    required this.isCompany,
    required this.name,
    this.imagePath,
    this.availableJobs = 0,
  });

  @override
  Widget build(BuildContext context) {
    final companyProvider = Provider.of<CompanySigninLoginProvider>(context);
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF6B8CC7),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), bottomLeft: Radius.circular(50)),
        ),
        width: (SizeConfig.screenW! <= 750)
            ? SizeConfig.screenW! * 0.85
            : SizeConfig.screenW! * 0.5,
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 40),
                // Profile Section
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child:
                            //  imagePath != null && imagePath != ''
                            //     ?
                            Image.network(imagePath!,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.high,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(loadingProgress.expectedTotalBytes != null
                                  ? (loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!)
                                      .toStringAsFixed(2)
                                  : ''),
                              const CircularProgressIndicator(),
                            ],
                          );
                        }, errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            size: 50,
                          );
                        })
                        // : const Icon(
                        //     Icons.person,
                        //     size: 50,
                        //   ),
                        ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 20),
                // Menu Items
                if (isCompany) ...[
                  _buildMenuItem(
                    context: context,
                    icon: Icons.dashboard,
                    title: 'لوحة التحكم',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CompanyDashboardScreen(
                            company:
                                Provider.of<CompanySigninLoginProvider>(context)
                                        .currentCompany ??
                                    CompanyModel(),
                          ),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.work,
                    title: 'الوظائف المنشورة',
                    onTap: () {
                      // التنقل إلى صفحة الوظائف المنشورة
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CompanyJobsScreen(
                              company: Provider.of<CompanySigninLoginProvider>(
                                      context)
                                  .currentCompany!),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.people,
                    title: 'المتقدمين',
                    onTap: () {
                      // التنقل إلى صفحة المتقدمين
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ApplicantsScreen(),
                        ),
                      );
                    },
                  ),
                ] else ...[
                  // Employee Menu Items
                  _buildMenuItem(
                    context: context,
                    icon: Icons.home,
                    title: 'الصفحة الرئيسية',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.person,
                    title: 'اعدادت السيرة الذاتيه',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CVScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.work,
                    title: 'الوظائف المتقدم لها',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrderScreen(),
                          ));
                      // التنقل إلى صفحة الوظائف المتقدم لها
                    },
                  ),
                ],
                _buildMenuItem(
                  context: context,
                  icon: Icons.message,
                  title: 'الرسائل',
                  onTap: () {
                    // التنقل إلى صفحة الرسائل
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MessagesScreen(messages: mockMessages),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  context: context,
                  icon: Icons.notifications,
                  title: 'الاشعارات',
                  onTap: () {
                    // التنقل إلى صفحة الإشعارات
                  },
                ),
                _buildMenuItem(
                  context: context,
                  icon: Icons.language,
                  title: 'اللغة',
                  onTap: () {
                    Navigator.pop(context);
                    _showLanguageDialog(context);
                  },
                ),
                _buildMenuItem(
                  context: context,
                  icon: Icons.settings,
                  title: 'الاعدادات',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: إضافة صفحة الإعدادات
                  },
                ),
                _buildMenuItem(
                  context: context,
                  icon: Icons.group,
                  title: 'عن الفريق',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: إضافة صفحة عن الفريق
                  },
                ),
                const Divider(
                  color: Colors.white,
                  thickness: 1,
                  indent: 20,
                  endIndent: 0,
                ),
                const SizedBox(height: 20),
                // Statistics Circle
                if (!isCompany) ...[
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${Provider.of<CompaniesProvider>(context).companies.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'شركة متاحة',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  // Company Statistics
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${Provider.of<OrderProvider>(context).orders.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'متقدم جديد',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                // Bottom Buttons
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          _buildWhiteButton(
                            'المزيد من الاحصائيات والتقييم',
                            context,
                            isFullColor: true,
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const StatisticsScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          _buildWhiteButton(
                            'قيمنا',
                            context,
                            isFullColor: false,
                            onTap: () {
                              // TODO: إضافة صفحة التقييم
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const StatisticsScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 1,
                      indent: 20,
                      endIndent: 0,
                    ),
                    const SizedBox(height: 10),
                    _buildLogoutButton(
                      context,
                      onTap: () async {
                        await companyProvider.logout();
                        if (companyProvider.token == null) {
                          Navigator.pop(context);
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                              (route) => false);
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ],
            ),
            // Close Button
            Positioned(
              top: 40,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return Column(
      children: [
        const Divider(
          color: Colors.white,
          thickness: 1,
          indent: 20,
          endIndent: 0,
        ),
        ListTile(
          trailing: Icon(icon, color: Colors.white),
          title: Text(
            title,
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          onTap: onTap,
        ),
      ],
    );
  }

  Widget _buildWhiteButton(
    String text,
    BuildContext context, {
    bool isFullColor = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isFullColor ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          border: !isFullColor
              ? Border.all(
                  color: isFullColor ? Colors.transparent : Colors.white,
                  width: 2,
                )
              : null,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: isFullColor
              ? Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: Colors.black)
              : Theme.of(context).textTheme.labelMedium,
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'تسجيل الخروج',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(width: 8),
            const Icon(Icons.power_settings_new,
                color: Color.fromARGB(255, 255, 255, 255)),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'اللغة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildLanguageOption('العربية'),
              _buildLanguageOption('الانجليزية'),
              _buildLanguageOption('حسب لغة الجهاز'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    return RadioListTile(
      title: Text(language),
      value: language,
      groupValue: 'العربية',
      onChanged: (value) {},
    );
  }
}
