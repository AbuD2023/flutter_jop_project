import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jop_project/Models/job_advertisement_model.dart';
import 'package:jop_project/Providers/Job/job_provider.dart';
import 'package:jop_project/Providers/SignUp/company_signin_login_provider.dart';
import 'package:jop_project/components/background.dart';
import 'package:jop_project/responsive.dart';
import 'package:jop_project/size_config.dart';
import 'package:provider/provider.dart';

class AddJopScreen extends StatelessWidget {
  const AddJopScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final companyProvider = Provider.of<CompanySigninLoginProvider>(context);

    final descriptionController = TextEditingController();
    final addrees = TextEditingController();
    final requiredQualifications = TextEditingController();
    final workType = TextEditingController();
    final area = TextEditingController();
    final applicationPeriod = TextEditingController();
    final salary = TextEditingController();
    final jopNameController = TextEditingController();
    final expController = TextEditingController();
    return Background(
      showListNotiv: true,
      title: 'إضافة وظيفة',
      isCompany: true,
      userImage: companyProvider.currentCompany!.img,
      userName: companyProvider.currentCompany!.nameCompany,
      child: Center(
        child: SingleChildScrollView(
          child: Responsive(
            mobile: MobileHomeJopInfoScreen(
              expController: expController,
              jopNameController: jopNameController,
              descriptionController: descriptionController,
              addrees: addrees,
              requiredQualifications: requiredQualifications,
              workType: workType,
              area: area,
              applicationPeriod: applicationPeriod,
              salary: salary,
            ),
            desktop: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100)),
                        child: companyProvider.currentCompany!.img == null
                            ? Image.asset(
                                'assets/images/YKB.png',
                                fit: BoxFit.fill,
                              )
                            : Image.network(
                                companyProvider.currentCompany!.img!,
                                fit: BoxFit.fill,
                              ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.all(16),
                        color: const Color(0xFF6B8CC7),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              companyProvider.currentCompany!.nameCompany!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              companyProvider.currentCompany!.location!,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: InfoBodyWidget(
                      expController: expController,
                      jopNameController: jopNameController,
                      descriptionController: descriptionController,
                      addrees: addrees,
                      requiredQualifications: requiredQualifications,
                      workType: workType,
                      area: area,
                      applicationPeriod: applicationPeriod,
                      salary: salary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MobileHomeJopInfoScreen extends StatelessWidget {
  final TextEditingController descriptionController;
  final TextEditingController addrees;
  final TextEditingController requiredQualifications;
  final TextEditingController workType;
  final TextEditingController area;
  final TextEditingController applicationPeriod;
  final TextEditingController salary;
  final TextEditingController jopNameController;
  final TextEditingController expController;
  const MobileHomeJopInfoScreen({
    super.key,
    required this.descriptionController,
    required this.expController,
    required this.addrees,
    required this.requiredQualifications,
    required this.workType,
    required this.area,
    required this.applicationPeriod,
    required this.salary,
    required this.jopNameController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Center(
            child: SizedBox(
              width: SizeConfig.screenW! / 1.2,
              child: const CardMainInfoWidget(),
            ),
          ),
          const SizedBox(height: 16),
          InfoBodyWidget(
            expController: expController,
            jopNameController: jopNameController,
            descriptionController: descriptionController,
            addrees: addrees,
            requiredQualifications: requiredQualifications,
            workType: workType,
            area: area,
            applicationPeriod: applicationPeriod,
            salary: salary,
          ),
        ],
      ),
    );
  }
}

class InfoBodyWidget extends StatelessWidget {
  final TextEditingController descriptionController;
  final TextEditingController addrees;
  final TextEditingController requiredQualifications;
  final TextEditingController workType;
  final TextEditingController area;
  final TextEditingController applicationPeriod;
  final TextEditingController salary;
  final TextEditingController jopNameController;
  final TextEditingController expController;
  const InfoBodyWidget({
    super.key,
    required this.expController,
    required this.descriptionController,
    required this.addrees,
    required this.requiredQualifications,
    required this.workType,
    required this.area,
    required this.applicationPeriod,
    required this.salary,
    required this.jopNameController,
  });

  @override
  Widget build(BuildContext context) {
    final jopProvider = Provider.of<JobsProvider>(context);
    final companyProvider = Provider.of<CompanySigninLoginProvider>(context);
    final keyForm = GlobalKey<FormState>();
    return Form(
      key: keyForm,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            'معلومات الوظيفة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B8CC7),
            ),
          ),
          const Divider(
            color: Color(0xFF6B8CC7),
          ),
          RectanglText(descriptionController: descriptionController),
          const SizedBox(height: 16),
          _buildInfoItem(Icons.work, 'أسم الوظيفة', //----
              controller: jopNameController),
          _buildInfoItem(
            Icons.add_location,
            'عنوان', //----
            controller: addrees,
          ),
          _buildInfoItem(Icons.school, 'المؤهلات المطلوبة', //----
              controller: requiredQualifications),
          _buildInfoItem(Icons.school, 'مدة الخبرة',
              controller: expController), //----
          _buildInfoItem(Icons.access_time, 'نوع الدوام',
              controller: workType), //----
          _buildInfoItem(Icons.location_on, 'المنطقة',
              controller: area), //--------******
          _buildInfoItem(Icons.calendar_today, 'مدة التقديم', //----
              controller: applicationPeriod),
          _buildInfoItem(Icons.attach_money, 'الراتب',
              controller: salary), //----
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (keyForm.currentState!.validate()) {
                  // log('العنوان: ${addrees.text}المؤهلات المطلوبة: ${requiredQualifications.text}نوع الدوام: ${workType.text}المنطقة: ${area.text}مدة التقديم: ${applicationPeriod.text}الراتب: ${salary.text}');
                  final jobAdvertisementModel = JobAdvertisementModel(
                    id: 0, //----
                    descrip: descriptionController.text, //----
                    companyId: companyProvider.currentCompany!.id, //----
                    countryId: companyProvider.currentCompany!.countryId, //----
                    location: addrees.text, // الموقع المطلوب //----
                    nameJob: jopNameController.text, // اسم الوظيفة//----
                    periodExper: expController.text, //فترة الخبرة //----
                    periodWork: null, //فترة العمل
                    permanenceType: workType.text, //النوع الدائم //----
                    salry: salary.text, // الراتب //----
                    special: requiredQualifications.text, // تخصص //----
                    timeWork: applicationPeriod.text, //نوع الوقت //----
                    typeOfPlace: area.text, //نوع المكان //--------******
                    worksFileId: 2,
                  );
                  await jopProvider.addJobs(
                    jobAdvertisementModel: jobAdvertisementModel,
                  );
                  if (jopProvider.error != null) {
                    Get.snackbar('خطأ', jopProvider.error!,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        icon: const Icon(Icons.error, color: Colors.white),
                        duration: const Duration(seconds: 3),
                        snackPosition: SnackPosition.BOTTOM);
                  } else {
                    Get.snackbar('تمت الإضافة بنجاح', 'تمت الإضافة بنجاح',
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        icon: const Icon(Icons.check, color: Colors.white),
                        duration: const Duration(seconds: 3),
                        snackPosition: SnackPosition.TOP);
                    // ignore: use_build_context_synchronously
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B3B77),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: jopProvider.isLoading
                  ? const SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.language, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'إضافة الوظيفة',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String title,
      {required TextEditingController controller}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        height: (SizeConfig.screenW! <= 750) ? 35 : 35,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: TextFormField(
                  // autofocus: true,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(fontSize: 11),
                  controller: controller,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    isDense: true,
                    suffixIcon: const Icon(
                      Icons.edit,
                      color: Colors.black,
                      size: 11,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 6.0),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            bottomLeft: Radius.circular(25))),
                    hintText: title,
                    hintStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                    ),
                    errorStyle: const TextStyle(
                      fontSize: 5,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الحقل مطلوب *';
                    }
                    return null;
                  },
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF6B8CC7),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                title,
                textAlign: TextAlign.end,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF6B8CC7),
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RectanglText extends StatelessWidget {
  final TextEditingController descriptionController;

  const RectanglText({
    super.key,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blueGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF6B8CC7),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  'الوصف',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    // autofocus: true,
                    controller: descriptionController,
                    maxLines: 3,
                    textAlign: TextAlign.right,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الحقل مطلوب *';
                      }
                      return null;
                    },
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class CardMainInfoWidget extends StatelessWidget {
  const CardMainInfoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final companyProvider = Provider.of<CompanySigninLoginProvider>(context);
    return Card(
      color: const Color(0xFF6B8CC7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Flexible(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: companyProvider.currentCompany!.img == null
                        ? const AssetImage('assets/images/YKB.png')
                        : NetworkImage(companyProvider.currentCompany!.img!),
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    companyProvider.currentCompany!.nameCompany!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    companyProvider.currentCompany!.location!,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 68, 68, 68),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
