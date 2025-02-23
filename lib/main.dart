import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jop_project/Providers/Desires/desires_provider.dart';
import 'package:jop_project/Providers/Experience/experience_provider.dart';
import 'package:jop_project/Providers/Job/job_provider.dart';
import 'package:jop_project/Providers/Orders/order_provider.dart';
import 'package:jop_project/Providers/SignUp/searcher_signin_login_provider.dart';
import 'package:jop_project/Providers/skills/skills_provider.dart';
import 'package:jop_project/Screens/JopScreen/Home/home_screen.dart';
import 'package:jop_project/Screens/Onboarding/onboarding_screen.dart';
import 'package:jop_project/Screens/CompanyScreen/company_dashboard_screen.dart';
import 'package:jop_project/constants.dart';
import 'package:jop_project/size_config.dart';
import 'package:provider/provider.dart';
import 'package:jop_project/Providers/SignUp/company_signin_login_provider.dart';
import 'package:jop_project/Providers/Countries/country_provider.dart';
import 'package:jop_project/Providers/Companies/companies_provider.dart';
import 'package:jop_project/Providers/Searchers/searchers_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CompanySigninLoginProvider()),
        ChangeNotifierProvider(create: (_) => CountryProvider()),
        ChangeNotifierProvider(create: (_) => JobsProvider()..getJobs()),
        ChangeNotifierProvider(create: (_) => SearcherSigninLoginProvider()),
        ChangeNotifierProvider(
            create: (_) => CompaniesProvider()..getAllCompanies()),
        ChangeNotifierProvider(create: (_) => SkillsProvider()..getSkills()),
        ChangeNotifierProvider(create: (_) => DesiresProvider()..getDesires()),
        ChangeNotifierProvider(
            create: (_) => ExperienceProvider()..getExperiences()),
        ChangeNotifierProvider(create: (_) => OrderProvider()..getOrders()),
        ChangeNotifierProvider(
            create: (_) => SearchersProvider()..getAllSearchers()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GetMaterialApp(
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          labelLarge: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: "Mulish",
          ),
          labelMedium: TextStyle(
              color: Colors.white,
              fontFamily: "Mulish",
              fontSize: (SizeConfig.screenW! <= 750) ? 18 : 22),
          labelSmall: const TextStyle(color: Colors.black54, fontSize: 14),
          titleMedium: const TextStyle(color: Colors.black, fontSize: 16),
          // bodySmall: const TextStyle(color: Colors.white, fontSize: 20),
          // headlineMedium: TextStyle(
          //     color: Colors.white,
          //     fontFamily: "Mulish",
          //     fontSize: (SizeConfig.screenW! <= 750) ? 14 : 20),
          // bodyLarge: const TextStyle(
          //     color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          // displaySmall: const TextStyle(
          //     color: Color.fromARGB(255, 118, 118, 118), fontSize: 16),
          // bodyMedium: const TextStyle(
          //     color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          // displayLarge: const TextStyle(
          //     color: kPrimaryColor,
          //     fontSize: 20,
          //     fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(
          color: kBorderColor,
          applyTextScaling: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 3,
            foregroundColor: Colors.white,
            backgroundColor: kPrimaryColor,
            shape: const StadiumBorder(),
            // maximumSize: Size(SizeConfig.screenW!, 56),
            // minimumSize: Size(SizeConfig.screenW!, 56),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Colors.white,
          // focusColor: kBorderColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: kBorderColor, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: kBorderColor, width: 2.0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: kBorderColor, width: 2.0),
          ),
          contentPadding: EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: defaultPadding),
          hintStyle: TextStyle(
            color: kBorderColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      // home: const ProfileScreen(),
      // home: const HomeScreen(),
      // home: const WelcomeScreen(),
      home: const InitialScreen(),
      // localizationsDelegates: const [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      // supportedLocales: const [
      //   Locale('ar', 'SA'), // العربية
      // ],
      // locale: const Locale('ar', 'SA'), // تعيين اللغة العربية كلغة افتراضية
    );
  }
}

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final companyProvider =
        Provider.of<CompanySigninLoginProvider>(context, listen: false);
    final searcherProvider =
        Provider.of<SearcherSigninLoginProvider>(context, listen: false);
    await companyProvider.initializeApp();
    await searcherProvider.initializeApp();
    if (!mounted) return;

    // التحقق من وجود شركة مسجلة الدخول
    if (companyProvider.currentCompany != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CompanyDashboardScreen(
            company: companyProvider.currentCompany!,
          ),
        ),
      );
    } else if (searcherProvider.currentSearcher != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OnboardingScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:jop_project/Screens/Welcome/welcome_screen.dart';
// import 'package:jop_project/constants.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Auth',
//       theme: ThemeData(
//           primaryColor: kPrimaryColor,
//           scaffoldBackgroundColor: Colors.white,
//           elevatedButtonTheme: ElevatedButtonThemeData(
//             style: ElevatedButton.styleFrom(
//               elevation: 0,
//               foregroundColor: Colors.white,
//               backgroundColor: kPrimaryColor,
//               shape: const StadiumBorder(),
//               maximumSize: const Size(double.infinity, 56),
//               minimumSize: const Size(double.infinity, 56),
//             ),
//           ),
//           inputDecorationTheme: const InputDecorationTheme(
//             filled: true,
//             fillColor: kPrimaryLightColor,
//             iconColor: kPrimaryColor,
//             prefixIconColor: kPrimaryColor,
//             contentPadding: EdgeInsets.symmetric(
//                 horizontal: defaultPadding, vertical: defaultPadding),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.all(Radius.circular(30)),
//               borderSide: BorderSide.none,
//             ),
//           )),
//       home: const WelcomeScreen(),
//     );
//   }
// }
