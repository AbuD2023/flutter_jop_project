import 'package:jop_project/Screens/CompanyScreen/messages_screen.dart';
import 'package:jop_project/data/company_model.dart';

// بيانات تجريبية للمتقدمين
final List<ApplicantModel> mockApplicants = [
  ApplicantModel(
    name: 'محمد أحمد',
    avatarPath: 'assets/images/avatar1.png',
    status: 0,
    email: 'mohammed@example.com',
    phone: '777123456',
    age: 25,
    city: 'صنعاء',
    district: 'حدة',
    address: 'شارع الستين',
  ),
  // يمكن إضافة المزيد من المتقدمين
];

// بيانات تجريبية للمقبولين
final List<ApplicantModel> mockAcceptedApplicants = [
  ApplicantModel(
    name: 'علي محمد',
    avatarPath: 'assets/images/avatar2.png',
    status: 1,
    email: 'ali@example.com',
    phone: '777654321',
    age: 28,
    city: 'صنعاء',
    district: 'السبعين',
    address: 'شارع الرباط',
  ),
  // يمكن إضافة المزيد من المقبولين
];

// بيانات تجريبية للرسائل
final List<Message> mockMessages = [
  Message(
    senderName: 'أحمد علي',
    content: 'السلام عليكم، أود الاستفسار عن الوظيفة المعلنة',
    time: '10:30 ص',
    avatarPath: 'assets/images/avatar3.png',
  ),
  // يمكن إضافة المزيد من الرسائل
]; 