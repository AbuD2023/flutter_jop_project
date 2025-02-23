
class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "ابحث عن الوظيفة الأنسب",
    image: "assets/images/image1.png",
    desc:
        "نقوم بنشر آلاف الوظائف يومياً في تطبيقنا، يمكنك العثور على وظيفة أحلامك هنا",
  ),
  OnboardingContents(
    title: "قدّم على أي وظيفة تعجبك",
    image: "assets/images/image2.png",
    desc: "تستطيع العمل من أي مكان ميزة العمل عن بعد",
  ),
  OnboardingContents(
    title: "نمِ مهنتك معنا",
    image: "assets/images/image3.png",
    desc: "معنا ، أصبح من السهل جداً الاستمرار في النمو وبناء مهنتك.",
  ),
];
