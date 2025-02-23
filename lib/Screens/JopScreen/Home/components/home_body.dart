import 'package:flutter/material.dart';
import 'package:jop_project/Providers/Job/job_provider.dart';
import 'package:jop_project/Providers/Companies/companies_provider.dart';
import 'package:jop_project/Screens/JopScreen/Home/components/home_list_tile_widget.dart';
import 'package:jop_project/Screens/JopScreen/Jop_Info/jop_info_screen.dart';
import 'package:jop_project/constants.dart';
import 'package:jop_project/size_config.dart';
import 'package:provider/provider.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final companyProvider = Provider.of<CompaniesProvider>(context);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
              width: SizeConfig.screenW,
              child: Text(
                'قم بالبحث عن الوظيفة التي تناسبك',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: kBorderColor),
                textAlign: TextAlign.center,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Expanded(
                flex: 6,
                child: TextField(
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  minLines: 1,
                  maxLines: 1,
                  decoration: InputDecoration(
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: const Color.fromARGB(255, 209, 209, 209),
                            width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(
                            color: const Color.fromARGB(255, 209, 209, 209),
                            width: 2.0),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                      ),
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      hintText: 'البحث',
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 72, 131),
                    borderRadius: BorderRadius.circular(7)),
                child: const Icon(
                  Icons.list,
                  color: Colors.white,
                  size: defaultPadding * 2,
                ),
              ),
            ],
          ),
          Expanded(
            child:
                Consumer<JobsProvider>(builder: (context, jobsProvider, child) {
              return !jobsProvider.isLoading
                  ? jobsProvider.jobs.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: jobsProvider.jobs.length,
                          itemBuilder: (context, index) => HomeListTileWidget(
                            phone: companyProvider.companies[index].phone
                                .toString(),
                            icon: Icons.person,
                            title: companyProvider.companies
                                .where((element) {
                                  return element.id ==
                                      jobsProvider.jobs[index].companyId;
                                })
                                .first
                                .nameCompany
                                .toString(),
                            subtitle:
                                jobsProvider.jobs[index].nameJob.toString(),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JopInfoScreen(
                                    jobData: jobsProvider.jobs[index],
                                    companyData: companyProvider.companies
                                        .where((element) {
                                      return element.id ==
                                          jobsProvider.jobs[index].companyId;
                                    }).first,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : const Center(
                          child: Text('لا توجد اي وظائف حالياً'),
                        )
                  : const Center(
                      child: CircularProgressIndicator(),
                    );
            }),
          )
        ],
      ),
    );
  }
}
