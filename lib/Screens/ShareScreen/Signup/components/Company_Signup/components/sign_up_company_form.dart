import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jop_project/Models/company_model.dart';
import 'package:jop_project/Providers/SignUp/company_signin_login_provider.dart';
import 'package:provider/provider.dart';
import '../../../../../../components/already_have_an_account_acheck.dart';
import '../../../../../../constants.dart';
import '../../../../Login/login_screen.dart';
import 'package:jop_project/Providers/Countries/country_provider.dart';
import 'package:jop_project/Models/country_model.dart';

class SignUpCompanyForm extends StatefulWidget {
  const SignUpCompanyForm({super.key});

  @override
  State<SignUpCompanyForm> createState() => _SignUpCompanyFormState();
}

class _SignUpCompanyFormState extends State<SignUpCompanyForm> {
  File? _imageFile;
  final nameCompanyController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final specializationController = TextEditingController();
  final locationController = TextEditingController();
  final phoneOneController = TextEditingController();
  final phoneTowController = TextEditingController();
  String companyType = '';
  final TextEditingController _imageController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  CountryModel? selectedCountry;
  List<CountryModel> countries = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CountryProvider>(context, listen: false).fetchCountries();
    });
  }

  Future<void> _selectImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
          _imageController.text = image.path.split('/').last;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ في اختيار الصورة')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final companyProvider = Provider.of<CompanySigninLoginProvider>(context);
    // final countryProvider = Provider.of<CountryProvider>(context);
    return Form(
      key: formKey,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  // color: kPrimaryLightColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: kPrimaryColor, width: 2),
                ),
                child: _imageFile != null
                    ? ClipOval(
                        child: Image.file(
                          _imageFile!,
                          fit: BoxFit.cover,
                          width: 120,
                          height: 120,
                        ),
                      )
                    : const Icon(
                        Icons.business,
                        size: 60,
                        color: kPrimaryColor,
                      ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: _selectImage,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            controller: nameCompanyController,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(color: kBorderColor, width: 2.0),
              ),
              hintText: "أسم الشركة",
              suffixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.apartment_outlined, color: kBorderColor),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الحقل مطلوب';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: emailController,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (email) {},
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(color: kBorderColor, width: 2.0),
                ),
                hintText: "البريد الالكتروني",
                suffixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.email, color: kBorderColor),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الحقل مطلوب';
                }
                return null;
              },
            ),
          ),
          TextFormField(
            controller: passwordController,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            textInputAction: TextInputAction.done,
            obscureText: true,
            cursorColor: kPrimaryColor,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(color: kBorderColor, width: 2),
              ),
              hintText: "كلمة المرور",
              suffixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.lock, color: kBorderColor),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الحقل مطلوب';
              }
              return null;
            },
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            controller: specializationController,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (typeCompany) {},
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(color: kBorderColor, width: 2.0),
              ),
              hintText: "التخصص",
              suffixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.apartment_outlined, color: kBorderColor),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الحقل مطلوب';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: locationController,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              textInputAction: TextInputAction.done,
              obscureText: false,
              cursorColor: kPrimaryColor,
              onSaved: (location) {},
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(color: kBorderColor, width: 2),
                ),
                hintText: "موقع الشركة (الفرع الرئيسي)",
                suffixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.location_on, color: kBorderColor),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الحقل مطلوب';
                }
                return null;
              },
            ),
          ),
          TextFormField(
            controller: phoneOneController,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (phone1) {},
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(color: kBorderColor, width: 2.0),
              ),
              hintText: "رقم التواصل 1",
              suffixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.phone_callback, color: kBorderColor),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الحقل مطلوب';
              }
              return null;
            },
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            controller: phoneTowController,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (phone2) {},
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الحقل مطلوب';
              }
              return null;
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(color: kBorderColor, width: 2.0),
              ),
              hintText: "رقم التواصل 2",
              suffixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.phone_callback, color: kBorderColor),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding * 2),
          Container(
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.all(8.0),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'النوع:',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RadioListTile(
                        title: const Text('خاص'),
                        value: 'خاص',
                        groupValue: companyType,
                        onChanged: (value) {
                          setState(() {
                            companyType = value!;
                          });
                        },
                      ),
                      RadioListTile(
                        title: const Text('حكومي'),
                        value: 'حكومي',
                        groupValue: companyType,
                        onChanged: (value) {
                          setState(() {
                            companyType = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Consumer<CountryProvider>(builder: (context, countryProvider, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: countryProvider.isLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<CountryModel>(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        ),
                        isExpanded: true,
                        hint: const Text('اختر الدولة'),
                        value: selectedCountry,
                        items: countryProvider.countries.map((country) {
                          return DropdownMenuItem<CountryModel>(
                            value: country,
                            child: Text(country.name),
                          );
                        }).toList(),
                        onChanged: (CountryModel? newValue) {
                          setState(() {
                            selectedCountry = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'الرجاء اختيار الدولة';
                          }
                          return null;
                        },
                      ),
                    ),
            );
          }),
          const SizedBox(height: defaultPadding),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate() &&
                  selectedCountry != null &&
                  (companyType.isNotEmpty || companyType != '')) {
                try {
                  if (!companyProvider.isLoading) {
                    await showDialog(
                      context: context,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ).timeout(
                      const Duration(seconds: 3),
                      onTimeout: () async {
                        final company = CompanyModel(
                          id: 0,
                          desc: null,
                          section: null,
                          nameCompany: nameCompanyController.text,
                          email: emailController.text,
                          pass: passwordController.text,
                          special: specializationController.text,
                          location: locationController.text,
                          phone: phoneOneController.text,
                          phone2: phoneTowController.text,
                          typeCompany: companyType,
                          img: _imageFile?.path,
                          countryId: selectedCountry!.id,
                        );

                        await companyProvider.registerCompany(
                          companyModel: company,
                        );
                        if (!companyProvider.isLoading) {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        }
                        if (companyProvider.error == null) {
                          Get.snackbar('تم التسجيل بنجاح', '',
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              duration: const Duration(seconds: 3),
                              icon: const Icon(Icons.check_circle),
                              margin: const EdgeInsets.all(10),
                              snackPosition: SnackPosition.BOTTOM);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                    );
                  }

                  if (!context.mounted) return;
                } catch (e) {
                  // تم معالجة الخطأ في Provider
                }
              }
            },
            child: companyProvider.isLoading
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : Text("تسجيل".toUpperCase()),
          ),
          if (companyProvider.error != null)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'خطاء في الإميل او كلمة المرور',
                style: TextStyle(color: Colors.red),
              ),
            ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }
}
