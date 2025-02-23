import 'package:flutter/material.dart';
import 'package:jop_project/Providers/SignUp/searcher_signin_login_provider.dart';
import 'package:jop_project/Screens/JopScreen/Home/components/home_body.dart';
import 'package:jop_project/components/background.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final searcherProvider = Provider.of<SearcherSigninLoginProvider>(context);
    return Background(
      isCompany: false,
      userImage: searcherProvider.currentSearcher!.img ?? '',
      userName: searcherProvider.currentSearcher!.fullName ?? '',
      showListNotiv: true,
      title: 'الوظائف المتاحة',
      availableJobs: 50,
      child: const HomeBody(),
    );
  }
}

class MobileHomeScreen extends StatelessWidget {
  const MobileHomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const HomeBody();
  }
}
