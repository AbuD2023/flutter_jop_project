import 'package:flutter/material.dart';
import 'package:jop_project/Models/searcher_model.dart';
import 'package:jop_project/Providers/Job/job_provider.dart';
import 'package:jop_project/Providers/Orders/order_provider.dart';
import 'package:jop_project/Providers/Searchers/searchers_provider.dart';
import 'package:jop_project/Providers/SignUp/company_signin_login_provider.dart';
import 'package:jop_project/Screens/CompanyScreen/applicants_screen.dart';
import 'package:jop_project/components/background.dart';
import 'package:jop_project/responsive.dart';
import 'package:provider/provider.dart';

class AcceptedScreen extends StatelessWidget {
  final List<SearchersModel> searchers;

  const AcceptedScreen({
    super.key,
    required this.searchers,
  });

  @override
  Widget build(BuildContext context) {
    final searchersProvider = Provider.of<SearchersProvider>(context);
    final orders = Provider.of<OrderProvider>(context);
    final jobsProvider = Provider.of<JobsProvider>(context);
    final companySigninLoginProvider =
        Provider.of<CompanySigninLoginProvider>(context);
    final job = jobsProvider.jobs
        .where(
          (element) =>
              element.companyId ==
              companySigninLoginProvider.currentCompany?.id,
        )
        .toList();
    final order = orders.orders
        .where((element) => job
            .where((jo) =>
                jo.id == element.jobAdvertisementId && element.accept == 1)
            .isNotEmpty)
        .toList();
    final searcher = searchersProvider.searchers
        .where((element) =>
            order.where((order) => order.searcherId == element.id).isNotEmpty)
        .toList();
    return Background(
      title: 'المقبولين',
      child: Responsive(
        mobile: Stack(
          children: [
            ApplicantsList(
              searchers: searcher,
              orderCount: order,
              accept: true,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  tooltip: "تحديث",
                  onPressed: () {
                    searchersProvider.getAllSearchers();
                  },
                  icon: const Icon(Icons.refresh),
                ),
              ),
            ),
          ],
        ),
        desktop: Row(
          children: [
            Expanded(child: Container()),
            Expanded(
              child: ApplicantsList(
                searchers: searcher,
                orderCount: order,
                accept: true,
                job: null,
              ),
            ),
          ],
        ),
      ),
      // ListView.builder(
      //   itemCount: searchers.length,
      //   padding: const EdgeInsets.all(16),
      //   itemBuilder: (context, index) {
      //     final searcher = searchers[index];
      //     return Card(
      //       margin: const EdgeInsets.only(bottom: 16),
      //       child: ListTile(
      //         leading: CircleAvatar(
      //           backgroundImage: searcher.img != null
      //               ? NetworkImage(searcher.img!)
      //               : const AssetImage('assets/images/profile.png'),
      //         ),
      //         title: Text(
      //           searcher.fullName ?? '',
      //           textAlign: TextAlign.right,
      //         ),
      //         subtitle: Text(
      //           searcher.email ?? '',
      //           textAlign: TextAlign.right,
      //         ),
      //         trailing: Row(
      //           mainAxisSize: MainAxisSize.min,
      //           children: [
      //             IconButton(
      //               icon: const Icon(Icons.message),
      //               onPressed: () {
      //                 // فتح المحادثة
      //               },
      //             ),
      //             IconButton(
      //               icon: const Icon(Icons.info),
      //               onPressed: () {
      //                 // عرض التفاصيل
      //               },
      //             ),
      //           ],
      //         ),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
