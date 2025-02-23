import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jop_project/Models/orders_model.dart';
import 'package:jop_project/Providers/Companies/companies_provider.dart';
import 'package:jop_project/Providers/Job/job_provider.dart';
import 'package:jop_project/Providers/Orders/order_provider.dart';
import 'package:jop_project/Providers/SignUp/searcher_signin_login_provider.dart';
import 'package:jop_project/Screens/JopScreen/Jop_Info/jop_info_screen.dart';
import 'package:jop_project/components/background.dart';
import 'package:jop_project/responsive.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searcherProvider = Provider.of<SearcherSigninLoginProvider>(context);
    return Background(
      title: 'الوظائف المتقدم لها',
      isCompany: false,
      userImage: searcherProvider.currentSearcher!.img ?? '',
      userName: searcherProvider.currentSearcher!.fullName ?? '',
      showListNotiv: true,
      availableJobs: 50,
      child: Responsive(
        mobile: MobileOrderScreen(searcherProvider: searcherProvider),
        desktop: MobileOrderScreen(searcherProvider: searcherProvider),
      ),
    );
  }
}

class MobileOrderScreen extends StatelessWidget {
  final SearcherSigninLoginProvider searcherProvider;
  const MobileOrderScreen({super.key, required this.searcherProvider});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          Expanded(child:
              Consumer<OrderProvider>(builder: (context, orderProvider, child) {
            final order = orderProvider.orders.where(
              (element) {
                // log(element.searcherId.toString());
                // log(searcherProvider.currentSearcher!.id.toString());
                return element.searcherId ==
                    searcherProvider.currentSearcher!.id;
              },
            ).toList();
            return order.isNotEmpty
                ? ListView.builder(
                    itemCount: order.length,
                    itemBuilder: (context, index) {
                      return OrderItem(order: order[index]);
                    },
                  )
                : const Center(
                    child: Text(
                      'لا توجد اي بيانات',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
          })),
        ],
      ),
    );
  }
}

class OrderItem extends StatelessWidget {
  final OrdersModel order;
  const OrderItem({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobsProvider>(context);
    final companiesProvider = Provider.of<CompaniesProvider>(context);
    final job = jobProvider.jobs
        .firstWhere((element) => element.id == order.jobAdvertisementId);
    final company = companiesProvider.companies
        .firstWhere((element) => element.id == job.companyId);

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          title: Text(company.nameCompany.toString()),
          subtitle: Text(
            job.nameJob.toString(),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          trailing: Text(
            order.accept.toString() == '1'
                ? 'مقبول'
                : order.unAccept.toString() == '1'
                    ? 'مرفوض'
                    : 'في الانتظار',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          leading: company.img != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(company.img.toString()),
                )
              : const CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person),
                ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => JopInfoScreen(
                          companyData: company,
                          jobData: job,
                          orderData: order,
                        )));
          },
        ),
      ),
    );
  }
}
