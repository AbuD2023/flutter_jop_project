class JobData {
  final String companyName;
  final String location;
  final String logoPath;
  final String jobTitle;
  final String qualification;
  final String workType;
  final String area;
  final String applicationPeriod;
  final String salary;
  final String description;

  JobData({
    required this.companyName,
    required this.location,
    required this.logoPath,
    required this.jobTitle,
    required this.qualification,
    required this.workType,
    required this.area,
    required this.applicationPeriod,
    required this.salary,
    required this.description,
  });
}

final List<JobData> jobsList = [
  JobData(
    companyName: 'بنك اليمن والكويت',
    location: 'صنعاء',
    logoPath: 'assets/images/YKB.png',
    jobTitle: 'تقنية معلومات',
    qualification: 'جامعي',
    workType: 'جزئي',
    area: 'صنعاء - حدة',
    applicationPeriod: 'يوماً 30',
    salary: 'يحدد بعد المقابلة',
    description:
        'نحن نبحث عن مطور تطبيقات موهوب للانضمام إلى فريقنا المتنامي. يجب أن يكون لديك خبرة في تطوير تطبيقات الموبايل وفهم عميق لتقنيات البرمجة الحديثة.',
  ),
  JobData(
    companyName: 'شركة يمن موبايل',
    location: 'صنعاء',
    logoPath: 'assets/images/YKB.png',
    jobTitle: 'مهندس شبكات',
    qualification: 'بكالوريوس هندسة',
    workType: 'دوام كامل',
    area: 'صنعاء - شارع الستين',
    applicationPeriod: 'يوماً 15',
    salary: '800 دولار',
    description:
        'مطلوب مهندس شبكات ذو خبرة لا تقل عن 3 سنوات في مجال إدارة وصيانة شبكات الاتصالات.',
  ),
  JobData(
    companyName: 'مستشفى السعيد',
    location: 'تعز',
    logoPath: 'assets/images/YKB.png',
    jobTitle: 'طبيب عام',
    qualification: 'بكالوريوس طب',
    workType: 'دوام كامل',
    area: 'تعز - المركز',
    applicationPeriod: 'يوماً 20',
    salary: 'حسب الخبرة',
    description:
        'نبحث عن طبيب عام للعمل في قسم الطوارئ. يشترط خبرة سنتين على الأقل.',
  ),
  JobData(
    companyName: 'شركة النفط اليمنية',
    location: 'عدن',
    logoPath: 'assets/images/YKB.png',
    jobTitle: 'مهندس بترول',
    qualification: 'ماجستير هندسة بترول',
    workType: 'دوام كامل',
    area: 'عدن - المنصورة',
    applicationPeriod: 'يوماً 45',
    salary: '1500 دولار',
    description:
        'مطلوب مهندس بترول للعمل في حقول النفط. يشترط خبرة في مجال التنقيب.',
  ),
  JobData(
    companyName: 'جامعة صنعاء',
    location: 'صنعاء',
    logoPath: 'assets/images/YKB.png',
    jobTitle: 'أستاذ مساعد',
    qualification: 'دكتوراه',
    workType: 'دوام كامل',
    area: 'صنعاء - الجامعة',
    applicationPeriod: 'شهرين',
    salary: 'حسب اللائحة',
    description: 'مطلوب أستاذ مساعد في كلية الهندسة قسم الحاسوب.',
  ),
  JobData(
    companyName: 'كاك بنك',
    location: 'صنعاء',
    logoPath: 'assets/images/YKB.png',
    jobTitle: 'محاسب',
    qualification: 'بكالوريوس محاسبة',
    workType: 'دوام كامل',
    area: 'صنعاء - التحرير',
    applicationPeriod: 'يوماً 25',
    salary: 'يحدد بعد المقابلة',
    description:
        'نبحث عن محاسب ذو خبرة في العمل المصرفي والتعامل مع النظم المحاسبية الحديثة.',
  ),
  JobData(
    companyName: 'شركة سبأفون',
    location: 'صنعاء',
    logoPath: 'assets/images/YKB.png',
    jobTitle: 'مسؤول تسويق',
    qualification: 'بكالوريوس تسويق',
    workType: 'دوام كامل',
    area: 'صنعاء - شارع الزبيري',
    applicationPeriod: 'يوماً 20',
    salary: '600 دولار',
    description:
        'مطلوب مسؤول تسويق لديه خبرة في التسويق الرقمي وإدارة حملات السوشيال ميديا.',
  ),
  JobData(
    companyName: 'مدارس المستقبل',
    location: 'إب',
    logoPath: 'assets/images/YKB.png',
    jobTitle: 'مدرس لغة إنجليزية',
    qualification: 'بكالوريوس لغة إنجليزية',
    workType: 'دوام جزئي',
    area: 'إب - المركز',
    applicationPeriod: 'يوماً 15',
    salary: '400 دولار',
    description:
        'مطلوب مدرس لغة إنجليزية للمرحلة الثانوية. يشترط خبرة في التدريس.',
  ),
  JobData(
    companyName: 'مصنع الألبان',
    location: 'الحديدة',
    logoPath: 'assets/images/YKB.png',
    jobTitle: 'مهندس إنتاج',
    qualification: 'بكالوريوس هندسة صناعية',
    workType: 'دوام كامل',
    area: 'الحديدة - المينا',
    applicationPeriod: 'شهر',
    salary: '700 دولار',
    description: 'مطلوب مهندس إنتاج للإشراف على خطوط الإنتاج وضمان الجودة.',
  ),
  JobData(
    companyName: 'شركة التأمين اليمنية',
    location: 'صنعاء',
    logoPath: 'assets/images/YKB.png',
    jobTitle: 'مندوب مبيعات',
    qualification: 'دبلوم',
    workType: 'دوام كامل',
    area: 'صنعاء - حدة',
    applicationPeriod: 'يوماً 30',
    salary: 'راتب + عمولة',
    description:
        'نبحث عن مندوب مبيعات نشيط للعمل في مجال التأمين. التدريب متوفر للشخص المناسب.',
  ),
];
